# 💻 Comandos para Copiar/Colar - Deploy Render

## 🚀 Passo 1: Setup GitHub Local

### Para Windows (CMD)

**Copie e cole isto na CMD:**

```cmd
# Criar pasta
mkdir travel-agency-documents
cd travel-agency-documents

# Inicializar Git
git init

# Conectar ao GitHub (SUBSTITUA seu-username)
git remote add origin https://github.com/seu-username/travel-agency-documents.git

# Verificar
git remote -v
```

**Resultado esperado:**
```
origin  https://github.com/seu-username/travel-agency-documents.git (fetch)
origin  https://github.com/seu-username/travel-agency-documents.git (push)
```

---

### Para Mac/Linux (Terminal)

```bash
mkdir travel-agency-documents
cd travel-agency-documents
git init
git remote add origin https://github.com/seu-username/travel-agency-documents.git
git remote -v
```

---

## 📂 Passo 2: Copiar Arquivos

Copie estes arquivos para a pasta `travel-agency-documents`:

```
app.py
index.html
requirements.txt
README.md
QUICKSTART.md
ARCHITECTURE.md
.env.example
.gitignore
Dockerfile
docker-compose.yml
DEPLOY_RENDER.md
DEPLOY_COMMANDS.md
```

**Verificar no Terminal/CMD:**

```bash
ls -la    # Mac/Linux
dir       # Windows
```

Deve listar todos os arquivos! ✅

---

## 🔄 Passo 3: Primeira Subida para GitHub

### Windows (CMD)

```cmd
# Adicionar todos os arquivos
git add .

# Criar commit
git commit -m "Versão inicial: Sistema de processamento de documentos"

# Subir para GitHub (usando branch main)
git branch -M main
git push -u origin main
```

**Primeira vez pode pedir autenticação:**
- Username: seu username GitHub
- Password: seu token pessoal (gere em Settings → Developer settings → Tokens)

---

### Mac/Linux (Terminal)

```bash
git add .
git commit -m "Versão inicial: Sistema de processamento de documentos"
git branch -M main
git push -u origin main
```

---

### Verificar no GitHub

Abra: `https://github.com/seu-username/travel-agency-documents`

Deve ver todos os arquivos listados! ✅

---

## 🎯 Passo 4: Testar Localmente (ANTES de Deploy)

### Setup Local

#### Windows (CMD)

```cmd
# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt

# Iniciar servidor
python app.py
```

#### Mac/Linux (Terminal)

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```

---

### Testar no Navegador

Abra: **http://localhost:8000**

Deve ver a interface com 5 passos! ✅

Se não funcionar:
1. Verifique se Python está instalado: `python --version`
2. Verifique requirements.txt
3. Procure por erros no terminal

---

## 🚀 Passo 5: Deploy no Render

### 5.1: Criar Repositório no GitHub

1. Aceda a https://github.com/new
2. Preencha:
   - Repository name: `travel-agency-documents`
   - Description: `Sistema de processamento de documentos`
   - Public: Selecione ✅
   - Add .gitignore: Python

3. Clique **Create repository**

---

### 5.2: Conectar Render.com

1. Aceda a https://render.com
2. Clique **Sign up with GitHub**
3. Autorize acesso

---

### 5.3: Criar Web Service

**Na dashboard Render:**

```
Clique: + New
Selecione: Web Service
Clique: Connect a repository
Selecione: travel-agency-documents
Clique: Connect
```

---

### 5.4: Configuração do Web Service

**Preencha exatamente:**

```
Name: travel-agency-api
Environment: Python 3
Build Command: pip install -r requirements.txt
Start Command: uvicorn app:app --host 0.0.0.0 --port 8000
Instance Type: Free
```

**Clique: Create Web Service**

---

### ⏳ Aguarde Deploy

Você verá:
```
Building...
Fetching requirements...
Installing dependencies...
Starting server...
Live ✓
```

**Pode demorar 5-10 minutos!**

---

## ✅ Passo 6: Verificar Deploy

### Testar Health Check

No navegador, abra:
```
https://travel-agency-api.onrender.com/api/health
```

Deve responder:
```json
{
  "status": "healthy"
}
```

Se vir isto: **Deploy bem-sucedido!** ✅

---

### Testar Interface Completa

Abra:
```
https://travel-agency-api.onrender.com
```

Deve ver a interface com os 5 passos! 🎉

---

## 🔄 Passo 7: Atualizar Código (Futuros Deploys)

Sempre que fizer mudanças:

### Windows (CMD)

```cmd
# Ver status
git status

# Adicionar mudanças
git add .

# Commit
git commit -m "Descrição da mudança"

# Push para GitHub
git push origin main

# Render detecta automaticamente e redeploy em 2-3 minutos!
```

### Mac/Linux (Terminal)

```bash
git status
git add .
git commit -m "Descrição da mudança"
git push origin main
```

---

## 🐛 Troubleshooting Rápido

### Se Build Falhar

```bash
# 1. Verificar requirements.txt localmente
pip install -r requirements.txt

# 2. Se erro, reinstalar
pip install --upgrade -r requirements.txt

# 3. Commit
git add requirements.txt
git commit -m "Fix: atualizar requirements"
git push origin main

# 4. No Render: Manual Deploy
```

---

### Se API Não Responder

**Verificar Logs no Render:**

1. Dashboard → seu Web Service
2. Aba **Logs**
3. Procure por erros (red text)
4. Clique **Manual Deploy** para redeploy

---

### Se Câmera Não Funciona

**Verificar:**
- URL começa com `https://` ✅
- Não é `http://` ❌
- Permissão da câmera no navegador

Render.com oferece HTTPS grátis! ✅

---

## 📊 Monitorar Aplicação

### Ver Logs Contínuos

```bash
# No Render Dashboard:
Dashboard → Logs → (ver em tempo real)
```

---

### Reiniciar Servidor

```bash
# No Render Dashboard:
Dashboard → Manual Deploy → Deploy latest commit
```

---

### Ver Métricas

```bash
# No Render Dashboard:
Dashboard → Metrics
- Requisições/segundo
- Tempo de resposta
- CPU/RAM
- Erros
```

---

## 🎁 Bônus: Configurar Variáveis de Ambiente

No Render Dashboard:

```
Clique: Environment
Adicione:

DEBUG = false
ZIP_PASSWORD = Angola2019@
MAX_UPLOAD_SIZE = 52428800
```

**No código Python, usar:**
```python
import os
debug = os.getenv("DEBUG", "false")
password = os.getenv("ZIP_PASSWORD", "Angola2019@")
```

---

## 🎉 Parabéns!

Sua aplicação está **online** em:
```
https://travel-agency-api.onrender.com
```

---

## 📝 Notas Importantes

### ⚠️ Render Free tem Limitações

- "Sleep" após 15 minutos de inatividade
- Primeira requisição pode ser lenta (wake up)
- Limite de 3 Web Services grátis

**Solução:** Upgrade para Paid (~$7/mês) quando tiver tráfego

---

### 💾 Banco de Dados

- SQLite funciona, mas dados sumirem no Render Free
- **Recomendado:** Usar PostgreSQL (grátis no Render)

---

### 🔒 Segurança

- HTTPS automático ✅
- Variáveis sensíveis em Environment ✅
- GitHub privado recomendado em produção ✅

---

## 📚 Documentação Completa

Para mais detalhes, leia:
- `DEPLOY_RENDER.md` - Guia passo-a-passo
- `README.md` - Documentação geral
- `QUICKSTART.md` - Início rápido

---

**Pronto? Execute os comandos acima e seu app está online! 🚀**
