# 🚀 Quick Start Guide

## Iniciar em 5 Minutos

### ⚡ Opção 1: Execução Local (Windows/Mac/Linux)

```bash
# 1. Abra terminal/CMD na pasta do projeto

# 2. Execute o script de inicialização
# Windows:
start.bat dev

# Mac/Linux:
chmod +x start.sh
./start.sh dev

# 3. Acesse no navegador
# http://localhost:8000
```

### 🐳 Opção 2: Com Docker (Recomendado)

```bash
# 1. Certifique-se que Docker está instalado
docker --version

# 2. Execute (Windows/Mac/Linux):
docker-compose up

# 3. Acesse
# http://localhost:8000
```

### 🔧 Opção 3: Manual Step-by-Step

```bash
# 1. Criar ambiente virtual
python -m venv venv

# 2. Ativar (Windows)
venv\Scripts\activate

# 2. Ativar (Mac/Linux)
source venv/bin/activate

# 3. Instalar dependências
pip install -r requirements.txt

# 4. Rodar servidor
python app.py

# 5. Abrir navegador em http://localhost:8000
```

---

## 📝 Teste a Aplicação

1. **Passo 1**: Digite um número de passaporte (8-10 caracteres)
   - Exemplo: `N16E7272`

2. **Passo 2**: Tire foto do passaporte
   - Clique no botão circular para capturar
   - Aceite a foto

3. **Passo 3**: Preparação facial
   - Leia as 4 instruções
   - Clique em "Começar Escaneamento"

4. **Passo 4**: Escaneamento
   - O sistema capturará automaticamente
   - Processamento em andamento...

5. **Passo 5**: Download
   - Clique em "Baixar ZIP"
   - Arquivo será baixado automaticamente

---

## 🔍 Verificar se Funcionou

### Ver Banco de Dados

```bash
# Abrir SQLite
sqlite3 viagens.db

# Dentro do SQLite:
SELECT * FROM clientes_downloads;

# Sair
.exit
```

### Ver Arquivos Gerados

```bash
# Listar arquivos ZIP gerados
ls uploads/
# ou no Windows:
dir uploads\
```

### Ver Logs do Servidor

Procure por mensagens como:
```
✓ Sistema iniciado
✓ Banco de dados: viagens.db
✓ Diretório de uploads: uploads
```

---

## ⚠️ Erros Comuns & Soluções

### "Módulo não encontrado"
```bash
# Solução: reinstalar dependências
pip install -r requirements.txt --upgrade
```

### "Porta 8000 já em uso"
```bash
# Solução 1: usar porta diferente
python app.py --port 8001

# Solução 2: matar processo usando porta 8000
# Windows: netstat -ano | findstr :8000
# Mac/Linux: lsof -i :8000 e kill -9 <PID>
```

### "Câmera não funciona"
- Verifique permissões no navegador
- Teste em outro navegador
- Use HTTPS em produção (câmera requer)

### "ZIP não cria"
```bash
# Verificar pyminizip
pip install --upgrade pyminizip

# Verificar espaço em disco
df -h  # Linux/Mac
```

### "Erro de permissão na pasta uploads"
```bash
# Dar permissões (Linux/Mac)
chmod 755 uploads/
chmod 755 temp/
```

---

## 📦 Banco de Dados

### Ver Downloads Registrados
```bash
sqlite3 viagens.db "SELECT * FROM clientes_downloads;"
```

### Limpar Downloads Antigos
```bash
sqlite3 viagens.db "DELETE FROM clientes_downloads WHERE datetime(data_hora) < datetime('now', '-30 days');"
```

### Backup
```bash
sqlite3 viagens.db ".backup backup_$(date +%Y%m%d).db"
```

---

## 🔐 Segurança Básica

### Senha do ZIP
Atualmente: `Angola2019@`

Para mudar, edite em `app.py`:
```python
ZIP_PASSWORD = "SuaSenhaAqui@"
```

### HTTPS em Produção
**CRÍTICO**: Use HTTPS para câmera funcionr em produção

### Variáveis Sensíveis
1. Copie `.env.example` para `.env`
2. Edite valores sensíveis
3. Nunca faça commit de `.env`

---

## 🌐 Deploy Rápido

### Render.com (Recomendado)
1. Push para GitHub
2. Conecte Render.com
3. Selecione `Web Service`
4. BuildCommand: `pip install -r requirements.txt`
5. StartCommand: `uvicorn app:app --host 0.0.0.0`

### Heroku
```bash
heroku login
heroku create seu-app-name
git push heroku main
```

### DigitalOcean
1. Crie droplet Ubuntu 22.04
2. SSH e execute:
```bash
sudo apt update && sudo apt install python3.11 python3-pip nginx
git clone seu-repo
cd seu-repo
pip install -r requirements.txt
# Configure Nginx + Systemd
```

---

## 📞 Contato & Suporte

- Verifique primeiro: `README.md` → Troubleshooting
- Consulte logs do servidor
- Teste em navegador moderno (Chrome/Firefox)
- Valide permissões de câmera

---

## 📚 Documentação Completa

Consulte `README.md` para:
- Guia de instalação detalhado
- Arquitetura do sistema
- API endpoints
- Configurações avançadas
- Deploy em produção
- Monitoramento

---

**Pronto para começar? Execute `./start.sh dev` ou `start.bat dev` 🚀**
