# Rails Vine

Rails apps should start off with a bunch of great defaults and a fully
configured VueJS development setup including testing, with docker.

**Note:** Requires Docker and Docker Compose

## Getting Started

Vine is a Rails template, so you pass it in as an option when creating a new app.

#### Creating a new app

```bash

docker run --rm -v `pwd`:`pwd` -w `pwd` -u $(id -u ${USER}):$(id -g ${USER}) bmartel/ruby:2.6-base sh -c "gem install rails && rails new myapp -T -d postgresql -m https://raw.githubusercontent.com/bmartel/vine/master/template.rb"
```

Or if you have downloaded this repo, you can reference template.rb locally:

```bash
docker run --rm -v `pwd`:`pwd` -w `pwd` -u $(id -u ${USER}):$(id -g ${USER}) bmartel/ruby:2.6-base sh -c "gem install rails && rails new myapp -T -d postgresql -m template.rb"
```

```bash
cd myapp
docker-compose up -f docker-compose.dev.yml up -d
```

#### Cleaning up

```bash
docker-compose up -f docker-compose.dev.yml down -v
cd ..
rm -rf myapp
```
