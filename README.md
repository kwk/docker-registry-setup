# Docker Registry Setup

This project is intended for people like me who need to get their hands on a
piece of technology before they can fully grasp it.

The purpose of this project is rather educational. I'll show you how you can
setup a docker registry v2 and an authorization server to be used with the
registry.

# Preparation

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
WARNING: login credentials saved in /home/kkleine/.docker/config.json
Login Succeeded
The push refers to a repository [0.0.0.0:5000/anyuser/busybox] (len: 1)
d7057cb02084: Image successfully pushed 
cfa753dfea5e: Image successfully pushed 
latest: digest: sha256:a2d7824b17c3837e6cf1d8f0be99574956b7555a925851ff192aa4e4e7cafa6e size: 3214
```

 These password
combinations are defined in `auth/config/simple.yml`:

  * admin:badmin    (can push and pull)
  * test:123   (can only pull)

Have fun!
