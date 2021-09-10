# Keycloak Example SPIs

## Authenticators

### Secret Question

Required actions:

* register the required action
* enable required action on the realm

Authenticator:

* copy the auth flow
* add secret question auth to the form as last step
* change the bindings to the new flow
* open http://localhost:8080/auth/realms/acme-demo/protocol/openid-connect/auth?client_id=acme-standard-client&client_secret=acme-standard-client-1-secret&redirect_uri=http://localhost/acme-standard-client/login*&state=12345678&response_type=code&scope=openid%20profile%20email
* logout http://localhost:8080/auth/realms/acme-demo/protocol/openid-connect/logout