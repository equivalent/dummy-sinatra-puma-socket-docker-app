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

To lunch server

```
git clone git@github.com:equivalent/dummy-puma-sinatra-docker-app
cd ./test-puma-app
bundle install
bundle exec puma config.ru -C puma.rb
```

## Run as Docker image

```bash
git clone git@github.com:equivalent/dummy-puma-sinatra-docker-app
cd ./test-puma-app

# build docker image
bash docker build -t=dummy-puma-sinatra-docker-app .

# Prepare and run Docker image
mkdir -p /tmp/dummy-puma-sinatra-docker-app
docker run -v /tmp/dummy-puma-sinatra-docker-app/:/var/shared/ -d dummy-puma-sinatra-docker-app

# Check
docker ps
```

Now you have a puma running on a socket `/tmp/dummy-puma-sinatra-docker-app/app.sock`

## step 2 - Lunch NginX

Create / Lunch NginX that is expecting connection on socket `/tmp/dummy-puma-sinatra-docker-app/app.sock`

for example:

```
/etc/nginx/nginx.conf
# ...
upstream myapp {
  server unix:///tmp/dummy-puma-sinatra-docker-app/app.sock;
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
docker run -v /tmp/dummy-puma-sinatra-docker-app/:/var/shared/ -p 80:80 -it testnginx
```

> if you are getting 504 you may be running nginx before Puma server

## Notes

* This is a demo app. Be sure to alter any config according to your
  needs
* If you want some NginX example check
  https://gist.github.com/ctalkington/4448153#file-nginx-conf-L4 or
  https://www.youtube.com/watch?v=jSy1Bnf3WIk
