# get the oidc info page
GET {{host}}/auth/realms/{{realm}}/.well-known/openid-configuration
Content-Type: application/json

#check the response
HTTP/1.1 200
[Asserts]
jsonpath "$.issuer" == "{{host}}/auth/realms/{{realm}}"