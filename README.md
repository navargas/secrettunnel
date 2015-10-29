# Secret Tunnel
*HTTP Tunnel for docker images on multiple hosts.*

I am a big fan of how intuitive it is to link containers with docker
compose and I wanted to extend this interface to cross-host links.

# Usage
dockercompose.yml on server 1
```
tunnel:
  image: navargas/secrettunnel
  ports:
    - "18210:80"
  extra_hosts:
    - "peer:IP_OF_SERVER2"
  environment:
    - expose=alpha:80 beta:80
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
alpha:
  image: navargas/hostecho
  links:
    - tunnel:gamma
    - tunnel:delta
beta:
  image: navargas/hostecho
```

dockercompose.yml on server 2
```
tunnel:
  image: navargas/secrettunnel
  ports:
    - "18210:80"
  extra_hosts:
    - "peer:IP_OF_SERVER1"
  environment:
    - expose=gamma:80 delta:80
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
gamma:
  image: navargas/hostecho
  links:
    - tunnel:alpha
delta:
  image: navargas/hostecho
```

Then, from ```alpha``` for example, you can use the hostname ```gamma``` to connect to container ```gamma``` on server 2, or hostname ```delta``` to connect to container ```delta```.

# Goals
* Simple interface that preserves the elegance of docker compose
* Does not require modification of existing images. Containers can
be moved to a different host without modification for other containers
* No daemon outside of container defined in dockercompose.yml
* Only one exposed port

Note: This functionality will eventually (hopefully) be replaced with a
solution from the docker/libnetwork

*TCP in future? Maybe!*

*Through the mountain!*
