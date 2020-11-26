![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cbtcr/supercronic?style=flat)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/cbtcr/supercronic/latest?style=flat)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/cbtcr/supercronic?style=flat)
![Docker Pulls](https://img.shields.io/docker/pulls/cbtcr/supercronic?style=flat)
![GitHub](https://img.shields.io/github/license/CalumBThomson/supercronic?style=flat)

# supercronic
Dockerised container image for Supercronic running on an Alpine base with tini init.  

## Quick Start
Create a crontab file on the host file system (see Supercronic repo for details). Then launch a new container -- mount the crontab file to `/etc/crontabs/nobody`:  
```
docker run --rm --name supercronic -d -v /path-to-crontab-file/my-crontab:/etc/crontabs/nobody cbtcr/supercronic
```

Alternatively, create a Dockerfile to build a new image based on this one, then copy in your crontab file:  
```
FROM cbtcr/supercronic
COPY ["sample-crontab","/etc/crontabs/nobody"]
```

## References
- Supercronic -- https://github.com/aptible/supercronic
- Alpine -- https://hub.docker.com/_/alpine
- tini -- https://github.com/krallin/tini
