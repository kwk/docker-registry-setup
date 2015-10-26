# Creation of example certificates

**NOTE:** You should replace these files with your own!!!

# Certificate and key for the registry

The `registry.crt` and `registry.key` files have been created using this command:

```
openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt
Generating a 4096 bit RSA private key
............................................................................................++
........................................................................................++
writing new private key to 'registry.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:Example State
Locality Name (eg, city) []:Example City
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example Company
Organizational Unit Name (eg, section) []:Example Organization Unit
Common Name (e.g. server FQDN or YOUR name) []:registry.example.com
Email Address []:admin@registry.example.com
```

# Certificate and key for the auth server

The `auth.crt` and `auth.key` files have been created using this command:

```
openssl req -newkey rsa:4096 -nodes -sha256 -keyout auth.key -x509 -days 365 -out auth.crt
Generating a 4096 bit RSA private key
................................................................................................................................................................................................................++
........................................................................++
writing new private key to 'auth.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:Example State
Locality Name (eg, city) []:Example City 
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example Company
Organizational Unit Name (eg, section) []:Example Organizational Unit
Common Name (e.g. server FQDN or YOUR name) []:auth.example.com
Email Address []:admin@auth.example.com
```

# How to list the contents of one of the certificates

```bash
openssl x509 -in registry.crt -text
```

Output

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 15377324996609959013 (0xd5673b9ca2abe465)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=DE, ST=Example State, L=Example City, O=Example Company, OU=Example Organization Unit, CN=registry.example.com/emailAddress=admin@registry.example.com
        Validity
            Not Before: Oct 26 11:02:58 2015 GMT
            Not After : Oct 25 11:02:58 2016 GMT
        Subject: C=DE, ST=Example State, L=Example City, O=Example Company, OU=Example Organization Unit, CN=registry.example.com/emailAddress=admin@registry.example.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:b3:90:24:96:67:de:56:aa:e3:b5:7d:27:5d:34:
                    4d:ce:60:bd:cf:9b:68:9e:af:e6:89:6d:95:74:9e:
                    3e:c6:27:8f:b6:34:52:ba:8b:9e:02:dc:a6:7c:a9:
                    84:6b:40:e1:ad:5b:c0:19:f4:8d:3d:81:76:2d:e9:
                    f1:2f:d4:20:7d:50:15:6d:cb:b6:cd:93:eb:f7:d2:
                    9c:99:90:1b:b6:99:d8:ad:a5:7a:df:92:2f:ab:8e:
                    b8:04:a9:cc:34:7f:d0:21:6a:46:89:a0:d5:2b:46:
                    f8:41:4a:ee:2a:d7:57:04:a1:33:c8:3f:fd:a4:10:
                    81:1b:5b:5b:91:c9:0e:0c:91:0e:ea:fe:36:2e:f3:
                    c7:be:01:2f:f4:fc:b0:ac:57:3b:d2:93:a8:0c:ad:
                    23:81:07:71:ef:3a:7e:6f:a4:52:c3:dc:ba:7e:db:
                    99:3c:c5:e0:66:88:8d:d2:f6:29:6c:a5:ac:9c:ba:
                    a7:dd:2d:a0:8b:ad:54:b2:ff:a0:c6:26:90:15:0c:
                    f9:2f:f8:d9:80:27:5a:52:08:8e:eb:84:5d:24:fe:
                    ad:05:e9:c2:6e:e2:f2:03:ce:fc:2d:37:7e:cf:c5:
                    ec:6d:45:d1:05:ed:97:11:f9:6b:89:66:dd:cc:4c:
                    fd:b7:18:71:be:f5:c7:ac:e1:6a:a5:6a:78:ab:66:
                    15:0e:65:6b:08:47:8b:06:31:99:ab:bb:70:50:8e:
                    2f:a9:d6:9a:86:39:c8:79:ef:b6:64:d6:00:2b:8d:
                    79:c2:c5:c6:6f:02:5b:50:56:64:4e:7e:f4:74:63:
                    4f:80:6d:b2:55:13:4e:95:93:1e:66:1b:28:9c:6c:
                    6b:1c:62:63:fb:9a:8a:ed:08:c8:e0:5c:04:f3:dd:
                    bb:c0:c5:d2:54:23:b8:bd:aa:95:30:62:ff:27:68:
                    41:bb:68:be:5b:f8:69:ef:3e:6f:81:fb:08:a4:f7:
                    fb:07:82:c9:53:09:d3:ae:48:02:47:db:ef:60:b1:
                    d7:be:6d:c1:d1:2d:ec:50:27:b2:29:9e:43:b4:e6:
                    2a:bb:99:23:1b:4b:27:89:c4:b8:64:30:33:a4:3b:
                    b4:a1:fb:65:7b:ff:50:32:0e:68:ea:de:e2:5f:b1:
                    11:e3:3c:e9:b2:70:aa:7f:6e:7c:01:0d:00:f9:f9:
                    02:65:fc:84:03:aa:78:66:16:04:ae:31:ba:02:bf:
                    3c:8c:f6:2b:0b:ec:a5:e2:f9:eb:9a:ce:31:cc:17:
                    3e:49:65:39:77:94:68:60:d8:56:5e:61:4d:5b:af:
                    12:1d:f8:b8:7b:a5:32:0b:99:c4:ba:cb:d3:b4:2c:
                    93:97:b9:fc:96:85:d8:27:0c:d2:9c:81:4e:85:70:
                    f0:a0:69
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                1C:1B:FC:0C:39:36:72:76:48:06:B0:90:26:F7:E3:E4:5D:1C:3D:14
            X509v3 Authority Key Identifier: 
                keyid:1C:1B:FC:0C:39:36:72:76:48:06:B0:90:26:F7:E3:E4:5D:1C:3D:14

            X509v3 Basic Constraints: 
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         8e:d2:18:07:b1:f9:f1:4d:60:45:98:e0:a5:64:8e:77:4d:3d:
         fd:31:3f:14:2a:bd:35:c9:f5:93:a8:00:63:05:54:41:44:6c:
         fe:f0:ab:e8:04:b8:b3:58:e2:6f:dc:63:58:92:63:bb:6a:cc:
         2d:83:71:00:17:87:91:d5:24:88:11:8e:47:d0:65:e9:16:c1:
         fe:92:e2:89:6d:56:f0:69:33:34:c3:e2:1f:57:00:6f:58:3c:
         61:2f:a4:bf:74:93:5f:f4:72:2e:59:61:19:58:00:0c:13:0c:
         a4:ad:2a:81:b5:78:4f:d2:ed:3d:4c:80:a8:65:66:66:95:9f:
         5a:9f:a9:85:05:2c:4b:e5:cb:74:e6:a3:4c:3f:2b:4f:cf:f9:
         53:b2:a0:11:b0:55:d4:7a:55:30:00:d8:a9:30:95:f1:06:58:
         00:03:96:c5:cc:d1:4e:b1:f8:57:87:79:d0:b1:ce:bb:95:27:
         5a:96:d1:fb:4b:15:5e:60:37:ab:1d:41:4b:c2:f7:13:2a:c0:
         bb:0f:b8:b9:1f:16:28:80:76:96:1f:7c:da:b4:d8:9e:ed:2f:
         e7:80:e7:63:bc:4d:e4:2a:20:3c:c4:cc:34:8a:cc:8f:c5:0a:
         c4:ca:90:e6:32:af:b6:bd:2a:74:86:ce:72:3c:f0:01:69:15:
         57:41:11:4e:55:d1:26:83:9b:7c:f4:ad:67:bb:af:4a:43:37:
         4f:94:93:92:00:f2:08:b8:65:18:4a:db:0f:06:2a:b7:e2:4d:
         2d:b0:62:9c:45:4a:9d:8d:b3:25:d0:99:c7:ed:21:e0:33:4b:
         dc:3e:15:77:79:54:ae:0c:31:1b:1d:d6:8f:7c:1e:0f:70:6c:
         96:6f:3d:fa:60:db:a5:3e:a9:3a:bd:ec:2e:d1:49:8f:ec:d2:
         2c:05:e6:55:8d:55:57:b8:a6:b3:7c:8a:a8:a1:b5:11:50:21:
         db:7d:f9:cb:24:db:e8:20:03:eb:ca:ac:5f:14:79:ad:e6:ff:
         1e:d4:1e:35:6c:0f:15:b4:b8:c2:ab:40:2b:e6:25:a4:14:1b:
         02:e7:16:27:a8:3a:6f:5f:79:96:11:b3:4a:77:6d:fc:cd:4d:
         d0:16:7f:c3:0b:9e:fa:d6:0c:4d:bd:92:dd:43:54:7f:b7:28:
         27:5b:14:26:72:d2:55:66:6c:1c:e0:ac:1e:11:41:d2:8b:8c:
         0e:c6:97:d8:b2:c1:5e:05:8f:66:55:d5:d0:b0:38:de:16:a4:
         38:d4:65:ef:db:ba:62:44:8d:88:18:93:72:a7:5c:14:d6:ed:
         0e:a2:25:e8:45:d1:0a:3b:2c:1d:21:94:be:1e:3c:e2:be:6c:
         e3:c3:26:41:5f:f0:6b:5b
-----BEGIN CERTIFICATE-----
MIIGXTCCBEWgAwIBAgIJANVnO5yiq+RlMA0GCSqGSIb3DQEBCwUAMIHEMQswCQYD
VQQGEwJERTEWMBQGA1UECAwNRXhhbXBsZSBTdGF0ZTEVMBMGA1UEBwwMRXhhbXBs
ZSBDaXR5MRgwFgYDVQQKDA9FeGFtcGxlIENvbXBhbnkxIjAgBgNVBAsMGUV4YW1w
bGUgT3JnYW5pemF0aW9uIFVuaXQxHTAbBgNVBAMMFHJlZ2lzdHJ5LmV4YW1wbGUu
Y29tMSkwJwYJKoZIhvcNAQkBFhphZG1pbkByZWdpc3RyeS5leGFtcGxlLmNvbTAe
Fw0xNTEwMjYxMTAyNThaFw0xNjEwMjUxMTAyNThaMIHEMQswCQYDVQQGEwJERTEW
MBQGA1UECAwNRXhhbXBsZSBTdGF0ZTEVMBMGA1UEBwwMRXhhbXBsZSBDaXR5MRgw
FgYDVQQKDA9FeGFtcGxlIENvbXBhbnkxIjAgBgNVBAsMGUV4YW1wbGUgT3JnYW5p
emF0aW9uIFVuaXQxHTAbBgNVBAMMFHJlZ2lzdHJ5LmV4YW1wbGUuY29tMSkwJwYJ
KoZIhvcNAQkBFhphZG1pbkByZWdpc3RyeS5leGFtcGxlLmNvbTCCAiIwDQYJKoZI
hvcNAQEBBQADggIPADCCAgoCggIBALOQJJZn3laq47V9J100Tc5gvc+baJ6v5olt
lXSePsYnj7Y0UrqLngLcpnyphGtA4a1bwBn0jT2Bdi3p8S/UIH1QFW3Lts2T6/fS
nJmQG7aZ2K2let+SL6uOuASpzDR/0CFqRomg1StG+EFK7irXVwShM8g//aQQgRtb
W5HJDgyRDur+Ni7zx74BL/T8sKxXO9KTqAytI4EHce86fm+kUsPcun7bmTzF4GaI
jdL2KWylrJy6p90toIutVLL/oMYmkBUM+S/42YAnWlIIjuuEXST+rQXpwm7i8gPO
/C03fs/F7G1F0QXtlxH5a4lm3cxM/bcYcb71x6zhaqVqeKtmFQ5lawhHiwYxmau7
cFCOL6nWmoY5yHnvtmTWACuNecLFxm8CW1BWZE5+9HRjT4BtslUTTpWTHmYbKJxs
axxiY/uaiu0IyOBcBPPdu8DF0lQjuL2qlTBi/ydoQbtovlv4ae8+b4H7CKT3+weC
yVMJ065IAkfb72Cx175twdEt7FAnsimeQ7TmKruZIxtLJ4nEuGQwM6Q7tKH7ZXv/
UDIOaOre4l+xEeM86bJwqn9ufAENAPn5AmX8hAOqeGYWBK4xugK/PIz2KwvspeL5
65rOMcwXPkllOXeUaGDYVl5hTVuvEh34uHulMguZxLrL07Qsk5e5/JaF2CcM0pyB
ToVw8KBpAgMBAAGjUDBOMB0GA1UdDgQWBBQcG/wMOTZydkgGsJAm9+PkXRw9FDAf
BgNVHSMEGDAWgBQcG/wMOTZydkgGsJAm9+PkXRw9FDAMBgNVHRMEBTADAQH/MA0G
CSqGSIb3DQEBCwUAA4ICAQCO0hgHsfnxTWBFmOClZI53TT39MT8UKr01yfWTqABj
BVRBRGz+8KvoBLizWOJv3GNYkmO7aswtg3EAF4eR1SSIEY5H0GXpFsH+kuKJbVbw
aTM0w+IfVwBvWDxhL6S/dJNf9HIuWWEZWAAMEwykrSqBtXhP0u09TICoZWZmlZ9a
n6mFBSxL5ct05qNMPytPz/lTsqARsFXUelUwANipMJXxBlgAA5bFzNFOsfhXh3nQ
sc67lSdaltH7SxVeYDerHUFLwvcTKsC7D7i5HxYogHaWH3zatNie7S/ngOdjvE3k
KiA8xMw0isyPxQrEypDmMq+2vSp0hs5yPPABaRVXQRFOVdEmg5t89K1nu69KQzdP
lJOSAPIIuGUYStsPBiq34k0tsGKcRUqdjbMl0JnH7SHgM0vcPhV3eVSuDDEbHdaP
fB4PcGyWbz36YNulPqk6vewu0UmP7NIsBeZVjVVXuKazfIqoobURUCHbffnLJNvo
IAPryqxfFHmt5v8e1B41bA8VtLjCq0Ar5iWkFBsC5xYnqDpvX3mWEbNKd238zU3Q
Fn/DC5761gxNvZLdQ1R/tygnWxQmctJVZmwc4KweEUHSi4wOxpfYssFeBY9mVdXQ
sDjeFqQ41GXv27piRI2IGJNyp1wU1u0OoiXoRdEKOywdIZS+HjzivmzjwyZBX/Br
Ww==
-----END CERTIFICATE-----

```
