# tcpdump

[tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html) dumbs network traffic.
It is useful for inspecting the traffic between Keycloak nodes.
In our setup we want to investigate Keycloak traffic in various situations.
Especially when it comes to clustering this is helpful.

Kudos to: 
1. https://rmoff.net/2019/11/29/using-tcpdump-with-docker/
2. https://xxradar.medium.com/how-to-tcpdump-effectively-in-docker-2ed0a09b5406

## build container
```
docker build -t thomasdarimont/tcpdump .
```

## run examples
Simply see what keycloak does with plain http:
```
docker run --tty --net=container:dev_acme-keycloak_1 thomasdarimont/tcpdump tcpdump -N -A 'port 8080'
```
Pipe https traffic directly into wireshark: 
```
docker run --tty --net=container:dev_acme-keycloak_1 thomasdarimont/tcpdump tcpdump -N -A 'port 8443' | wireshark -k -i -
```
