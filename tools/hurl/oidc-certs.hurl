# get the certs
GET {{host}}/auth/realms/{{realm}}/protocol/openid-connect/certs
Content-Type: application/json

#check the response
HTTP/1.1 200
[Asserts]
jsonpath "$.keys" exists