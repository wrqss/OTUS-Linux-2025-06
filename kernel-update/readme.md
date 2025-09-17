1. Проверяем текущую версию ядра
<img width="590" height="62" alt="image" src="https://github.com/user-attachments/assets/c8bad33a-96d8-4195-9f92-b8f300d8e5fc" />

2. Скачиваем пакеты для обновления
    
    `wget https://kernel.ubuntu.com/mainline/v6.15/amd64/linux-headers-6.15.0-061500-generic_6.15.0-061500.202505260036_amd64.deb`

    `wget https://kernel.ubuntu.com/mainline/v6.15/amd64/linux-headers-6.15.0-061500_6.15.0-061500.202505260036_all.deb`

    `wget https://kernel.ubuntu.com/mainline/v6.15/amd64/linux-image-unsigned-6.15.0-061500-generic_6.15.0-061500.202505260036_amd64.deb`

    `wget https://kernel.ubuntu.com/mainline/v6.15/amd64/linux-modules-6.15.0-061500-generic_6.15.0-061500.202505260036_amd64.deb`    

<img width="2014" height="254" alt="image" src="https://github.com/user-attachments/assets/9ae957e0-1d4a-469d-982f-b8d665d06018" />

3. Переходим в папку скачивания и устанавливаем все скаченные пакеты dpkg -i *.deb
4. Проверяем, что ядро появилось ls -ahlt /boot
5. Обновляем загрузчик update-grub

<img width="1710" height="1276" alt="image" src="https://github.com/user-attachments/assets/30d961cf-e2e7-4b90-a305-e9cc02c78e55" />

6. Проверяем, какой версией ядра загрузилась ОС

<img width="688" height="58" alt="image" src="https://github.com/user-attachments/assets/671f7985-a485-41cc-95bc-1bf511286e82" />

