# call userinfo endpoint
POST {{host}}/auth/realms/{{realm}}/protocol/openid-connect/userinfo
Authorization: Bearer {{token}}

#we only accept 200
HTTP/1.1 200

[Asserts]
jsonpath "$.sub" exists