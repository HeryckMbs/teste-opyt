# 💼 Bem-vindo ao Projeto Violet Wallet!

Olá, querida pessoa avaliadora! Espero que este projeto lhe encontre bem. A seguir estão os passos para executar o projeto. Qualquer dúvida pode mandar no email: heryckmota@gmail.com

## 🚀 Tecnologias Utilizadas

- **Docker**
- **TypeScript**
- **Typeorm**
- **MariaDB**
- **Flutter**

## 📂 Como Instalar o Projeto


### • Ambiente de Desenvolvimento:


1. **Subir os containers com Docker:**
   ```bash
   $ docker compose up -d
   ```
   ou
      ```bash
   $ docker-compose up -d
   ```
2. **Pegar id do container backend (server):**
     ```bash
   docker ps
   ```
     
3. **Entrar no container com id do backend encontrado acima:**
     ```bash
   docker exec -it {ID_CONTAINER} sh
   ```
4. **Executar as migrações:**


   ```bash
       npm run db:reset
   ```
 
5. **Configurar o `.env` no flutter na pasta assets/.env:**
   > Lembre-se de obter o seu IP local para preencher <br>
   > Preencha o arquivo `assets/.env` com:
   ```bash
    host=192.168.1.102:8080

   ```


6. **Rodar o Flutter**
     ```bash
       flutter run
   ```
