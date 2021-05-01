# WikiDocs Docker build

This Dockerfile will set up an Apache2/PHP server running [WikiDocs](https://github.com/Zavy86/WikiDocs).

## Configuration
- **PUID/PGID** (optional): in linuxserver.io fashion, this sets the UID/GID of the apache user within the container, so you can easily match a user on the host machine. Defaults to 1000/1000 if not set.
- **documents volume**: as WikiDocs stores entries as flat-files in plain text, mapping this on the host allows easy access to the wiki content. This can also be a named volume if you prefer.

## Quick run
```
docker run -d -p 80:80 -v /path/to/documents:/documents -e PUID=1000 -e PGID=1000 reyemxela/wikidocs
```

## docker-compose
```
version: '2'

services:
  wikidocs:
    image: reyemxela/wikidocs
    environment:
      - PUID=1000
      - PGID=1000
    ports:
      - 80:80
    volumes:
      - /path/to/documents:/documents
```
