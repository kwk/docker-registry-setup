#!/bin/sh

# Copy over certificates to correct place and update certificate storage
find "/config/ldap_certificates" -type f -exec cp -fv {} /usr/local/share/ca-certificates/ \;
update-ca-certificates

# Replace newline and carriage returns in password file
cat /config/ldap_password.txt | tr -d '\r\n' > /tmp/ldap_password.txt.clean

# If we see a custom config file, we load that instead of the default one
CONF_PATH=/config/auth_config.yml
if [ -f $CONF_PATH.custom ]; then
  CONF_PATH=$CONF_PATH.custom
fi

# Start the auth server
/auth_server -v=5 -alsologtostderr=true -log_dir=/logs $CONF_PATH
