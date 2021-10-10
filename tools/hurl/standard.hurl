# STEP 1. Start Standard flow
GET {{host}}/auth/realms/{{realm}}/protocol/openid-connect/auth

[QueryStringParams]
client_id: {{client_id}}
client_secret: {{client_secret}}
redirect_uri: {{redirect_uri}}
state: 12345678
response_type: code
scope: {{scope}}

#we only accept 200
HTTP/1.1 200

[Captures]
action: xpath "normalize-space(//form[@id='kc-form-login'][1]/@action)"
session_code: xpath "normalize-space(//form[@id='kc-form-login'][1]/@action)" regex "session_code=([^&]*)"

[Asserts]
variable "action" contains "session_code"
cookie "AUTH_SESSION_ID[SameSite]" exists
cookie "AUTH_SESSION_ID_LEGACY[HttpOnly]" exists
cookie "KC_RESTART[HttpOnly]" exists

# STEP 2. Fill username and password fields
POST {{action}}
[FormParams]
username: {{username}}
password: {{password}}

HTTP/1.1 302

[Captures]
session_state: header "Location" regex "session_state=([^&]*)"
code: header "Location" regex "code=([^&]*)"

[Asserts]
header "Location" contains "session_state"
header "Location" contains "code"
cookie "KEYCLOAK_SESSION[SameSite]" exists
cookie "KEYCLOAK_SESSION_LEGACY" exists

# STEP 3. Exchange code for token
POST {{host}}/auth/realms/{{realm}}/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

[FormParams]
client_id: {{client_id}}
client_secret: {{client_secret}}
grant_type: authorization_code
state: 12345678
code: {{code}}
session_code: {{session_code}}
redirect_uri: {{redirect_uri}}

#We only accept 200
HTTP/1.1 200

#grab the token type
[Captures]
token_type: jsonpath "$['token_type']"

#make sure it is a bearer token
[Asserts]
variable "token_type" == "bearer"