# call userinfo endpoint
POST {{host}}/auth/realms/{{realm}}/protocol/openid-connect/token/introspect
Authorization: Basic {{client_auth}}

[FormParams]
token: {{token}}

#we only accept 200
HTTP/1.1 200

[Asserts]
jsonpath "$.exp" exists