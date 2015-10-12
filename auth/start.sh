#!/bin/bash

# Copy over certificates to correct place and update certificate storage
find "/config/ldap_certificates" -type f -exec cp -fv {} /usr/local/share/ca-certificates/ \;
update-ca-certificates

# Replace newline and carriage returns in password file
cat /config/ldap_password.txt | tr -d '\r\n' > /tmp/ldap_password.txt.clean

# Start the auth server
/auth_server -v=2 -alsologtostderr=true -log_dir=/logs /config/ldap_auth.yml
