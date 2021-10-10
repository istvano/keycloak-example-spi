# do ROPC
POST {{host}}/auth/realms/{{realm}}/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

[FormParams]
client_id: {{client_id}}
client_secret: {{client_secret}}
grant_type: password
username: {{username}}
password: {{password}}

#we only accept 200
HTTP/1.1 200

#grab the token type
[Captures]
token_type: jsonpath "$['token_type']"

#make sure it is a bearer token
[Asserts]
variable "token_type" == "bearer"