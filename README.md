# Dummy Puma Sinatra Docker app. running on a socket

Given your NginX server is expecting connection on unix socket `unix:///var/shared/app.sock`
This docker image recipe will run small [Sinatra](http://www.sinatrarb.com/)
dummy application that will run [Puma server](http://puma.io/) on this socket.

For example:

```
/etc/nginx/nginx.conf
# ...
upstream myapp {
  server unix:///var/shared/app.sock;
}
# ...
```

## Running as Ruby without Docker

To launch server

```
git clone git@github.com:equivalent/dummy-sinatra-puma-socket-docker-app.git
cd ./dummy-sinatra-puma-socket-docker-app
bundle install
bundle exec puma config.ru -C puma.rb
```

## Run as Docker image

```bash
git clone git@github.com:equivalent/dummy-sinatra-puma-socket-docker-app.git
cd ./dummy-sinatra-puma-socket-docker-app

# build docker image
docker build -t=dummy-sinatra-puma-socket-docker-app .

# Prepare and run Docker image
mkdir -p /tmp/dummy-app
docker run -v /tmp/dummy-app/:/var/shared/ -d dummy-sinatra-puma-socket-docker-app

# Check
docker ps
```

Now you have a puma running on a socket `/tmp/dummy-app/app.sock`

## step 2 - Lunch NginX

Create & start NginX that is expecting connection on socket `/tmp/dummy-app/app.sock`

for example:

```
/etc/nginx/nginx.conf
# ...
upstream myapp {
  server unix:///tmp/dummy-app/app.sock;
}
# ...
```

or build a Docker NginX image using your config


```
/etc/nginx/nginx.conf
# ...
upstream myapp {
  server unix:///var/shared/app.sock;
}

# ...

server {
  # ...
  location / {
    # ...
    proxy_pass        http://myapp;
    # ...
  }
}
```

```
cd ./your-nginx-docker-project
docker build -t=testnginx .
docker run -v /tmp/dummy-app/:/var/shared/ -p 80:80 -it testnginx
```

> if you are getting 504 you may be running nginx before Puma server

## Notes

* This is a demo app. Be sure to fork and alter any config according to your
  needs
* If you want some NginX example check
  https://gist.github.com/ctalkington/4448153#file-nginx-conf-L4 or
  https://www.youtube.com/watch?v=jSy1Bnf3WIk
