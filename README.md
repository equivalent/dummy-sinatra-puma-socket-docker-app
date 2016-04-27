# Dummy Puma Sinatra Docker app. runnig on a socket

Given your NginX server is expecting connection on unix socket `unix:///var/shared/app.sock`
This docker image recipie will run small [Sinatra](http://www.sinatrarb.com/)
dummy application that will run [Puma server](http://puma.io/) on this socket.

for example:

```
/etc/nginx/nginx.conf
# ...
upstream myapp {
  server unix:///var/shared/app.sock;
}
# ...
```

## Plain Ruby

to lunch server

```
bundle install
bundle exec puma config.ru -C puma.rb
```

## Docker 


#### step 1 - lunch server


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

#### step - lunch NginX

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
