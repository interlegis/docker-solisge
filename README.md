# docker-solisge
Docker containers for SolisGE Educational Management Suite (formerly sagu)

## Requirements

### Docker

To use this image you need docker daemon installed. Run the following commands as root:

```
curl -ssl https://get.docker.com | sh
```

### Docker-compose

Docker-compose is desirable (run as root as well):

```
curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

## Docker-compose Example

Save the following snippet as docker-compose.yaml in any folder you like, or clone this repository, which contains the same file.

```
sagu:
  image: interlegis/solisge:latest
  links:
    - postgresql
  ports:
    - "80:80"
  volumes:
    - 'sagu_files:/var/solisge-files'

postgresql:
  image: 'postgresql:alpine'
  environment:
    - POSTGRESQL_PASSWORD=password123
  volumes:
    - 'sagu_psqldb:/var/lib/postgresql/data'

```

## Running

```
cd <folder where docker-compose.yaml is>
docker-compose up -d
```

You must set the following variable inside postgresql.conf for SolisGE (Sagu) to work correctly:

```
standard_conforming_strings = off
```

## Contributing

Pull requests welcome!
