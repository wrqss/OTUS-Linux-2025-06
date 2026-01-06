Приложения развернуты с помощью docker-compose на отдельной ВМ без использования Vagrant
Конфигурация ВМ выполняется с помощью ansible-playbook web.yaml

Результатом выполннения playbook, установлены необходимые компоненты докера из официального репозитория
Результатом выполненения compose, созданы необходимые контейнеры:

```
root@web:/home/wrqs/web# docker ps -a
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS          PORTS                                                                     NAMES
89b9fc6e12ed   web-app                      "gunicorn --workers=…"   18 minutes ago   Up 18 minutes                                                                             app
27a0fe49d9d2   nginx:1.15.12-alpine         "nginx -g 'daemon of…"   45 minutes ago   Up 10 minutes   80/tcp, 0.0.0.0:8081-8083->8081-8083/tcp, [::]:8081-8083->8081-8083/tcp   nginx
c494be93b36a   wordpress:5.1.1-fpm-alpine   "docker-entrypoint.s…"   45 minutes ago   Up 10 minutes   9000/tcp                                                                  wordpress
e9aff8cc7190   mysql:8.0                    "docker-entrypoint.s…"   45 minutes ago   Up 45 minutes   3306/tcp, 33060/tcp                                                       database
eaa31627926e   node:16.13.2-alpine3.15      "docker-entrypoint.s…"   45 minutes ago   Up 45 minutes                            
```

Проверка выполненных работ:
```bash
curl -i localhost:8081
HTTP/1.1 200 OK
Server: nginx/1.15.12
Date: Tue, 06 Jan 2026 13:21:36 GMT
Content-Type: text/html
Content-Length: 16351
Connection: keep-alive
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: same-origin
```

```
curl -i localhost:8082
HTTP/1.1 200 OK
Server: nginx/1.15.12
Date: Tue, 06 Jan 2026 13:07:31 GMT
Content-Type: text/plain
Content-Length: 25
Connection: keep-alive

Hello from node js server
```
```
curl -i localhost:8083
HTTP/1.1 302 Found
Server: nginx/1.15.12
Date: Tue, 06 Jan 2026 13:21:42 GMT
Content-Type: text/html; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
X-Powered-By: PHP/7.2.18
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Cache-Control: no-cache, must-revalidate, max-age=0
X-Redirect-By: WordPress
Location: http://localhost:8083/wp-admin/install.php
```
