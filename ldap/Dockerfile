FROM debian:jessie
MAINTAINER "Konrad Kleine"

############################################################
# Speedup DPKG and don't use cache for packages
############################################################

# Taken from here: https://gist.github.com/kwk/55bb5b6a4b7457bef38d
#
# this forces dpkg not to call sync() after package extraction and speeds up
# install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# # we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

############################################################
# Install slapd, LDAP utils, and supervisor
############################################################

RUN export LC_ALL=C \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y update \
    && apt-get -y install \
      slapd \
      ldap-utils \
      supervisor \
      netcat-openbsd \
      --no-install-recommends \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* 

# LDAP configuration
ENV LDAP_ROOTPASS password
ENV LDAP_ORGANISATION My Example Organization
ENV LDAP_DOMAIN example.com

ADD ./setup-ldap-schema.ldif /setup-ldap-schema.ldif
ADD ./setup-ldap-schema.sh /setup-ldap-schema.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD slapd.sh /slapd.sh

# Supervisor manager slapd and the schema setup
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 389
