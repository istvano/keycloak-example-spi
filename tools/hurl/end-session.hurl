POST {{host}}/auth/realms/{{realm}}/protocol/openid-connect/logout
Authorization: Bearer {{token}}

[FormParams]
client_id: {{client_id}}
client_secret: {{client_secret}}
refresh_token: {{refresh_token}}

HTTP/1.1 204