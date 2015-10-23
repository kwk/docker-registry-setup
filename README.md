# Docker Registry Setup

This project is intended for people like me who need to get their hands on a
piece of technology before they can fully grasp it.

The purpose of this project is rather educational. I'll show you how you can
setup a docker registry v2 and an authorization server with an LDAP backend.

# Preparation

## Configure docker deamon

These instructions only need to be done once. For the purpose of demonstation we
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

And voila, you'll be prompted for a username and a password.

```
The push refers to a repository [0.0.0.0:5000/anyuser/busybox] (len: 1)
d7057cb02084: Image push failed 

Please login prior to push:
Username: admin
Password: 
Email: admin@example.com
WARNING: login credentials saved in /home/kwk/.docker/config.json
Login Succeeded
The push refers to a repository [0.0.0.0:5000/anyuser/busybox] (len: 1)
d7057cb02084: Image successfully pushed 
cfa753dfea5e: Image successfully pushed 
latest: digest: sha256:a2d7824b17c3837e6cf1d8f0be99574956b7555a925851ff192aa4e4e7cafa6e size: 3214
```

These password combinations are defined in `auth/config/simple.yml`:

  * admin:badmin    (can push and pull)
  * test:123   (can only pull)

**Notice** that on a second pull or push you won't have to enter your
credentials again because they have been saved here: `~/.docker/config.json`.
Remove this file if you want to force another prompt for username and password.

# If you want LDAP authentication...

I've included an LDAP server in the `docker-compose.yml` that is also used for
authentication. This is the hierarchy:

```
dc
 |_philosophs
 |          |_schopenhauer
 |          |_kant
 |_musicians
           |_mozart
           |_bach
```

All musicians are allowed to login (see `base: "ou=musicians,dc=example,dc=com"` in
`auth/config/config.yml`.

## Test that LDAP auth is working

This will connect to the LDAP and query all information below the base (`-b`).
The user that is used to authenticate is called `YOUR_SERVICE_ACCOUNT`
and the password is taken from the file `./auth/config/ldap_password.txt`. But
since most editors append a newline (`\n`) or carriage return (`\r`) we first
remove those characters. The user `YOUR_SERVICE_ACCOUNT` is a service account,
but if you don't have one you can also try to login with your own email address
(`-D FIRSTNAME.LASTNAME@YOUR_COMPANY.com`).

```bash
ldapsearch -v \
  -H ldap://YOUR_LDAP_HOST:YOUR_LDAP_PORT \
  -x \
  -D YOUR_SERVICE_ACCOUNT \
  -b "dc=YOUR_COMPANY,dc=com" \
  -w $(cat ./auth/config/ldap_password.txt | tr -d '\r\n')
```

To find the entry for your own emailaddress, simply write:

```bash
ldapsearch -v \
  -H ldap://YOUR_LDAP_HOST:YOUR_LDAP_PORT \
  -x \
  -D YOUR_SERVICE_ACCOUNT \
  -b "dc=YOUR_COMPANY,dc=com" \
  -w $(cat ./auth/config/ldap_password.txt | tr -d '\r\n') \
  "(&(mail=FIRSTNAME.LASTNAME@YOUR_COMPANY.com)(objectClass=person))"
```

and appropriately replace `FIRSTNAME.LASTNAME@YOUR_COMPANY.com` with your own
email address.

## To use LDAP as your authentication backend...

1. If your LDAP server requires you to have certificates installed on the
machine that makes the query, copy those certificates to 
`auth/config/ldap_certificates/`. I've modified the auth container a bit by
introducing a start script that automatically searches for files in that
directory and update the cert store of the container on every start.
2. Copy the `auth/config/ldap_auth.yml.template` to 
`auth/config/config.yml.custom` and adjust all the settings inside to match the
LDAP configuration that you have validated above. The file
`auth/config/config.yml.custom` will be loaded instead of
`auth/config/config.yml` whenever it is present.
3. Put the password for the service account in this file: 
`auth/config/ldap_password.txt`.
4. Restart the registry and auth server: `docker-compose up -d --force-recreate`
5. Try pushing an image to the registry and login with your LDAP credentials.

# Test your auth server

Replace `USERNAME` and `PASSWORD` with credentials of somebody who wants to
authenticate against LDAP. You should get an `HTTP 200 OK` response containing
a JSON Web `token` if everything worked correctly.

```
curl -H "Authorization: Basic $(echo "USERNAME:PASSWORD" | base64)" -vk "https://127.0.0.1:5001/auth?service=Docker%20registry&scope=registry:catalog:*"
```

Have fun!
