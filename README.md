# Docker Registry Setup

This project is intended for people like me who need to get their hands on a
piece of technology before they can fully grasp it.

The purpose of this project is rather educational. I'll show you how you can
setup a docker registry v2 and an authorization server with an LDAP backend.
In fact, everything is already setup for you to run. There's a docker container
for the registry, the JWT auth server and the LDAP server. Feel free to connect
to your company LDAP if you want by making adjustments to the auth server's
config file (`auth/config/config.yml`). Just like that you can replace this
setup piece by piece to suite your needs.

Here's a graphic showing all the containers and how they talk to each other:

![](https://raw.githubusercontent.com/kwk/docker-registry-setup/master/docs/setup.png)

1. Attempt to begin a push/pull operation with the registry.
2. If the registry requires authorization it will return a 401 Unauthorized HTTP response with information on how to authenticate.
3. The registry client makes a request to the authorization service for a Bearer token.
4. The authorization server makes a request to the LDAP server to check if a user exists. We use a service account to connect to the LDAP server.
5. The LDAP server returns an answer to the user lookup.
6. The authorization service returns an opaque Bearer token representing the client's authorized access.
7. The client retries the original request with the Bearer token embedded in the request's Authorization header.
8. The Registry authorizes the client by validating the Bearer token and the claim set embedded within it and begins the push/pull session as usual.

[Here](https://github.com/docker/distribution/blob/master/docs/spec/auth/token.md)
you can read more about the Docker v2 registry authorization process.

# How are authentication and authorization configured

**NOTE** Remember, that *authentication* ensures that you are who you claim t
be. *Authorization* on the other hand defines rules of what somebody is
(dis)allowed to do.

The auth server is configured to try all authentication methods that
have been specified in `auth/config/config.yml`. Currently LDAP and a static
list of users/passwords are configured

These password combinations are defined statically:

  * admin:badmin (can push and pull)
  * test:123 (can only pull)

I've included an LDAP server in the `docker-compose.yml` that is also used for
authentication. This is the LDAP hierarchy:

```
com
  |_example
          |
          |_philosophs
          |         |_schopenhauer
          |         |_kant
          |_musicians
          |         |_mozart
          |         |_bach
          |_it
             |_serviceaccount
```

(This hierarchy is described here: `ldap/setup-ldap-schema.ldif`.)

All musicians (`mozart` and `bach`) are usernames that are authorized to login
using the password `password` and they can all push and pull images to or from
the registry. The philosophs (`schopenhauer` and `kant`) are not used and will
not function with the current LDAP search base (see
`base: "ou=musicians,dc=example,dc=com"` in `auth/config/config.yml`).

I use the `serviceaccount` username to connect to bind to LDAP from the auth
server. It 

**Notice** that on a successful second pull or push you won't have to enter your
credentials again because they have been saved here: `~/.docker/config.json`.
Remove this file if you want to force another prompt for username and password.

# Preparation

**IMPORTANT** Read these instructions to get up and running with your own
already configured docker registry v2 deployment.

## Configure docker deamon

These instructions only need to be executed once. For the purpose of demonstation we
will be running a registry on `localhost` and by default we must inform our
docker client about any insecure registry that we want to be using. Here's how
it works:

* Make sure you have docker > 1.8 as well as docker-compose installed.
* Ensure your `DOCKER_OPTS` contains this option: `--insecure-registry 0.0.0.0:5000`.
  On an Ubuntu 14.04 you can find this option in your `/etc/default/docker` file.
* Restart your docker service: `service docker restart`.

# How to run

```bash
# Clone the repository
git clone https://github.com/kwk/docker-registry-setup.git

# Navigate inside
cd docker-registry-setup

# Fire up the registry and the auth server as containers
# Notice that the docker registry is configured with a persistent storage volume
# from the docker host, hence --force-recreate will not wipe this storage for you.
docker-compose up -d --force-recreate

# Pull an image from the offical docker hub that we want push to our own secured registry
docker pull busybox

# Tag the image so that it can be pushed to our local registry
docker tag busybox 0.0.0.0:5000/anyuser/busybox
```

Okay, up until know we haven't pushed or pulled from our local registry. It is
now time to change this:

```bash
# First ensure we haven't stored any credentials:
mv -b ~/.docker/config.json ~/.docker/config.json.orig

# Push the image
docker push 0.0.0.0:5000/anyuser/busybox
```

And voila, you'll be prompted for a username and a password. Let's use the
username `mozart` (from the *musicians* organization unit in LDAP) and the
password `password`. The email address doesn't matter this much.

```
The push refers to a repository [0.0.0.0:5000/anyuser/busybox] (len: 1)
d7057cb02084: Image push failed 

Please login prior to push:
Username: mozart
Password: 
Email: mozart@example.com
WARNING: login credentials saved in /home/YOU/.docker/config.json
Login Succeeded
The push refers to a repository [0.0.0.0:5000/anyuser/busybox] (len: 1)
d7057cb02084: Image successfully pushed 
cfa753dfea5e: Image successfully pushed 
latest: digest: sha256:15eda5ab78f31658ab922650eebe9da9ccc6c16462d5ef0bfd6d9f29b8800569 size: 2743
```

## Test that LDAP auth is working

This will connect to the LDAP and query all information below the base (`-b`).
The user that is used to authenticate is called `YOUR_SERVICE_ACCOUNT`
and the password is taken from the file `./auth/config/ldap_password.txt`. But
since most editors append a newline (`\n`) or carriage return (`\r`) we first
remove those characters. The user `YOUR_SERVICE_ACCOUNT` is a service account,
but if you don't have one you can also try to login with your own email address
(`-D FIRSTNAME.LASTNAME@YOUR_COMPANY.com`).

```bash
LDAP_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' dockerregistrysetup_ldap_1)
ldapsearch -v \
  -H ldap://$LDAP_IP:389 \
  -x \
  -D "uid=serviceaccount,ou=it,dc=example,dc=com" \
  -b "ou=musicians,dc=example,dc=com" \
  -w password
```

To find an entry based on a user's email address execute this command:

```bash
LDAP_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' dockerregistrysetup_ldap_1)
ldapsearch -v \
  -H ldap://$LDAP_IP:389 \
  -x \
  -D "uid=serviceaccount,ou=it,dc=example,dc=com" \
  -b "ou=musicians,dc=example,dc=com" \
  -w password \
  "(&(mail=mozart@example.com)(objectClass=person))"
```

and appropriately replace `FIRSTNAME.LASTNAME@YOUR_COMPANY.com` with your own
email address.

## How to use your own LDAP as your authentication backend...

1. Chances are that your own LDAP server requires you to have certificates
installed on the machine that binds to LDAP. Simply copy those certificates to 
`auth/config/ldap_certificates/`. I've [modified the auth container](https://github.com/kwk/docker-registry-setup/blob/master/auth/start.sh#L4) a bit by
introducing a start script that automatically searches for files in that
that directory and updates the cert store of the container on every start.
2. Copy the `auth/config/auth_config.yml` to `auth/config/auth_config.yml.custom` and
adjust all the settings inside to match the LDAP configuration that you have
validated above. The file `auth/config/auth_config.yml.custom` will be loaded instead
of `auth/config/auth_config.yml` whenever it is present.
3. Put the password for the service account in this file: 
`auth/config/ldap_password.txt`.
4. Restart the registry and auth server: `docker-compose up -d --force-recreate`
5. Try pushing an image to the registry and login with your LDAP credentials.

# Test the auth server

Replace `USERNAME` and `PASSWORD` below with credentials of somebody who wants
to authenticate against LDAP (eg. `mozart` and `password`). You should get an
`HTTP 200 OK` response containing a JSON Web `token` if everything worked
correctly.

```
curl -H "Authorization: Basic $(echo "USERNAME:PASSWORD" | base64)" -vk "https://127.0.0.1:5001/auth?service=Docker%20registry&scope=registry:catalog:*"
```

# Manual token-based workflow to list repositories

You can skip this section if you're not interested in how a token can be
requested manually to list the repositories inside a registry.

```bash
# This is the operation we want to perform on the registry
registryURL=https://127.0.0.1:5000/v2/_catalog

# Save the response headers of our first request to the registry to get the Www-Authenticate header
respHeader=$(tempfile);
curl -k --dump-header $respHeader $registryURL

# Extract the realm, the service, and the scope from the Www-Authenticate header
wwwAuth=$(cat $respHeader | grep "Www-Authenticate")
realm=$(echo $wwwAuth | grep -o '\(realm\)="[^"]*"' | cut -d '"' -f 2)
service=$(echo $wwwAuth | grep -o '\(service\)="[^"]*"' | cut -d '"' -f 2)
scope=$(echo $wwwAuth | grep -o '\(scope\)="[^"]*"' | cut -d '"' -f 2)

# Build the URL to query the auth server
authURL="$realm?service=$service&scope=$scope"

# Query the auth server to get a token
token=$(curl -ks -H "Authorization: Basic $(echo -n "mozart:password" | base64)" "$authURL")

# Get the bare token from the JSON string: {"token": "...."}
token=$(echo $token | jq .token | tr -d '"')

# Query the registry again, but this time with a bearer token
curl -vk -H "Authorization: Bearer $token" $registryURL
```

As a result you should get a list of repositories in your registry. If you have
pushed only the busybox image from above to your registry you should see an HTTP
body like this:

```json
{"repositories":["anyuser/busybox"]}
```

# Plans

- [ ] Integrate a frontend

Have fun!
