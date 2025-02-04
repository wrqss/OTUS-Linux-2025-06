

1. Команда для запуска

```
ansible-playbook --private-key ~/.ssh/ansible -i inventory.ini nginx.yaml --ask-vault-pass
```

2. Параметр --ask-vault-pass указывает о том, чтобы спрашивало пароль для ansible-vault

3. Ansible-vault лежит в папке vars/nginx-vault.yml и зашифрован

4. В плейбуке переменная вызввается через  

```
vars_files:
    - vars/nginx-vault.yml
```
