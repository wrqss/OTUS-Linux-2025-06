1. Установка docker выполнена путем выполнения скрипта docker-install.sh
Сборка образа и запуск контейнера выполняется выполнением комманд:

docker build -t mynginx:custom 
docker run --name mynginx -d -p 8080:80 mynginx:custom

![image](https://github.com/user-attachments/assets/7828b50a-a648-41b1-9112-049a41c8ee8a)
