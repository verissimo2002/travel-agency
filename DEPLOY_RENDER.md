# 🚀 Guia Completo: Deploy FastAPI no Render.com

## 📋 Pré-requisitos

- ✅ Conta GitHub (grátis em github.com)
- ✅ Conta Render.com (grátis em render.com)
- ✅ Git instalado no seu computador
- ✅ Todos os arquivos do projeto

---

## PARTE 1: Preparar Repositório GitHub

### Passo 1.1: Criar Repositório GitHub

1. Aceda a **https://github.com/new**
2. Preencha:
   - **Repository name**: `travel-agency-documents` (ou outro nome)
   - **Description**: `Sistema de processamento de documentos para agência de viagens`
   - **Public**: Selecione (para Render conseguir aceder)
   - **Add .gitignore**: Selecione `Python`

3. Clique **Create repository**

---

### Passo 1.2: Copiar URL do Repositório

Depois de criar, você verá um campo como:
```
https://github.com/seu-username/travel-agency-documents.git
```

**Guarde esta URL!** Vai precisar.

---

### Passo 1.3: Preparar Pasta Local

#### Windows (CMD)
```cmd
# 1. Criar pasta
mkdir travel-agency-documents
cd travel-agency-documents

# 2. Inicializar Git
git init

# 3. Adicionar remote (copie sua URL acima)
git remote add origin https://github.com/seu-username/travel-agency-documents.git
```

#### Mac/Linux (Terminal)
```bash
mkdir travel-agency-documents
cd travel-agency-documents
git init
git remote add origin https://github.com/seu-username/travel-agency-documents.git
```

---

### Passo 1.4: Copiar Arquivos do Projeto

Copie **TODOS** estes arquivos para a pasta `travel-agency-documents`:

```
✅ app.py
✅ index.html
✅ requirements.txt
✅ Dockerfile (opcional)
✅ docker-compose.yml (opcional)
✅ README.md
✅ QUICKSTART.md
✅ ARCHITECTURE.md
✅ .env.example
✅ .gitignore
```

**Não copie:**
- ❌ viagens.db (será criado no servidor)
- ❌ uploads/ (será criado no servidor)
- ❌ temp/ (será criado no servidor)
- ❌ venv/ (ambiente virtual local)
- ❌ __pycache__/ (arquivos Python compilados)

---

### Passo 1.5: Adicionar & Fazer Commit

#### Windows (CMD)
```cmd
# 1. Adicionar todos os arquivos
git add .

# 2. Criar commit
git commit -m "Versão inicial: Sistema de processamento de documentos"

# 3. Fazer push para GitHub
git branch -M main
git push -u origin main
```

#### Mac/Linux (Terminal)
```bash
git add .
git commit -m "Versão inicial: Sistema de processamento de documentos"
git branch -M main
git push -u origin main
```

**Pode pedir para autenticar no GitHub - use seu username e token pessoal**

---

### Verificar no GitHub

1. Aceda a https://github.com/seu-username/travel-agency-documents
2. Você deve ver todos os arquivos listados ✅

---

## PARTE 2: Configurar Render.com

### Passo 2.1: Criar Conta Render

1. Aceda a **https://render.com**
2. Clique **Sign up**
3. Escolha **Sign up with GitHub**
4. Autorize o acesso
5. Complete o registo

---

### Passo 2.2: Conectar Repositório

1. Dashboard Render → Clique **+ New**
2. Selecione **Web Service**
3. Clique **Connect a repository**
4. Selecione seu repositório `travel-agency-documents`
5. Clique **Connect**

---

### Passo 2.3: Configurar Web Service

**Preencha exatamente assim:**

| Campo | Valor |
|-------|-------|
| **Name** | `travel-agency-api` (ou outro nome) |
| **Environment** | `Python 3` |
| **Build Command** | `pip install -r requirements.txt` |
| **Start Command** | `uvicorn app:app --host 0.0.0.0 --port 8000` |
| **Instance Type** | `Free` (inicialmente) |

---

### Passo 2.4: Variáveis de Ambiente (Opcional)

Se quiser adicionar variáveis (recomendado):

1. Scroll para **Environment**
2. Clique **Add Environment Variable**
3. Adicione:

```
Key: DEBUG
Value: false

Key: ZIP_PASSWORD
Value: Angola2019@

Key: MAX_UPLOAD_SIZE
Value: 52428800
```

---

### Passo 2.5: Deploy

1. Clique **Create Web Service**
2. **Aguarde 5-10 minutos** enquanto Render faz deploy

Você verá:
```
Building...
Installing requirements...
Starting server...
Live ✓
```

---

## PARTE 3: Verificar Deploy

### Passo 3.1: URL do Seu App

No dashboard Render, você verá:
```
https://travel-agency-api.onrender.com
```

**Este é seu URL!** Guarde-o.

---

### Passo 3.2: Testar API

Abra em novo separador do navegador:

```
https://travel-agency-api.onrender.com/api/health
```

Você deve ver:
```json
{
  "status": "healthy"
}
```

Se vir isto, **está funcionando!** ✅

---

### Passo 3.3: Testar Interface

Aceda a:
```
https://travel-agency-api.onrender.com
```

Deve ver a interface com os 5 passos. **Tudo funcionando!** 🎉

---

## PARTE 4: Testar Fluxo Completo

### Teste Local (recomendado primeiro)

1. **Passo 1**: Digite número passaporte
   - Exemplo: `N16E7272`
   - Botão ativa ao validar ✅

2. **Passo 2**: Captura foto passaporte
   - Clique botão circular
   - Tirar foto
   - Clicar "Aceitar e continuar"

3. **Passo 3-4**: Escaneamento facial
   - "Look at camera" → "Hold still" → "Done"

4. **Passo 5**: Download
   - Clique "Baixar ZIP"
   - Arquivo baixa: `N16E7272.zip`

5. **Banco de Dados**: Verificar

```bash
# SSH no Render (será adicionado em breve)
# Por enquanto, verificar na pasta do servidor
```

---

## PARTE 5: Gerenciar Aplicação

### Ver Logs em Tempo Real

1. Dashboard Render → seu Web Service
2. Clique na aba **Logs**
3. Veja tudo o que está acontecendo

---

### Reiniciar Aplicação

1. Dashboard Render → seu Web Service
2. Clique **Manual Deploy**
3. Selecione **Deploy latest commit**

---

### Atualizar Código

Quando fizer mudanças:

```bash
# 1. Localmente
git add .
git commit -m "Descrição da mudança"
git push origin main

# 2. Render detecta automaticamente
# 3. Faz novo deploy em 2-3 minutos
```

---

## PARTE 6: Produção & Otimizações

### Aumentar para Paid (quando tiver muitos users)

1. Dashboard → seu Web Service
2. Clique **Instance Type**
3. Upgrade para Paid (~$7/mês)

**Benefícios:**
- Sem "sleep mode" (fica sempre online)
- Mais rápido
- Mais storage

---

### Adicionar Domínio Personalizado

1. Dashboard → seu Web Service
2. Clique **Custom Domain**
3. Adicione seu domínio (ex: `docs.suaagencia.com`)
4. Configure DNS no seu registar de domínios

---

### HTTPS Automático

Render.com configura HTTPS automaticamente! ✅

Seu URL:
- ❌ http://travel-agency-api.onrender.com (vai redirecionar)
- ✅ https://travel-agency-api.onrender.com (correto)

---

## PARTE 7: Troubleshooting

### Problema: "Build failed"

**Solução:**
```bash
# 1. Verifique requirements.txt localmente
pip install -r requirements.txt

# 2. Se erro, reinstale dependências
pip install -r requirements.txt --upgrade

# 3. Commit & push
git add requirements.txt
git commit -m "Fix: atualizar dependências"
git push origin main
```

---

### Problema: "Service Unavailable"

**Solução:**
1. Aguarde 5 minutos (Render pode estar inicializando)
2. Se persistir, vá a Logs e veja o erro
3. Faça novo deploy: **Manual Deploy**

---

### Problema: Câmera não funciona

**Causa:** Precisa HTTPS em produção

**Verificar:**
- URL começa com `https://` ✅
- Não `http://` ❌

Render.com oferece HTTPS de graça! ✅

---

### Problema: Upload de arquivo falha

**Verificar:**
1. Tamanho do arquivo (máx 50MB)
2. Permissões na pasta `uploads/`
3. Espaço em disco do servidor

**Logs:**
```
Dashboard → Logs → procure "error" ou "Upload"
```

---

### Problema: Banco de dados não persiste

**Razão:** Render free tem filesystem efémero

**Solução**: Usar banco de dados externo (PostgreSQL Render grátis)

---

## PARTE 8: Banco de Dados em Produção

### Adicionar PostgreSQL (Gratuito)

1. Dashboard Render → **+ New**
2. Selecione **PostgreSQL**
3. Preencha:
   - **Name**: `travel-agency-db`
   - **Database**: `viagens`
   - **User**: `postgres`

4. Clique **Create**

---

### Conectar ao FastAPI

Edite `app.py`:

```python
import os
from sqlalchemy import create_engine

# Usar PostgreSQL em produção
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "sqlite:///./viagens.db"  # fallback local
)

if DATABASE_URL.startswith("postgresql"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://")

engine = create_engine(DATABASE_URL)
```

---

## PARTE 9: Monitoramento

### Alertas de Erro

1. Dashboard Render → seu Web Service
2. Clique **Notifications**
3. Configure email para alertas

---

### Estatísticas

1. Aba **Metrics**
2. Veja:
   - Requisições por segundo
   - Tempo de resposta
   - Uso de CPU/RAM
   - Erros 4xx/5xx

---

## ✅ Checklist Final

- [ ] Repositório GitHub criado
- [ ] Arquivos no GitHub
- [ ] Render.com conectado
- [ ] Web Service criado
- [ ] Build bem-sucedido
- [ ] API /health respondendo
- [ ] Interface carregando
- [ ] Testes executados
- [ ] Banco de dados funcionando
- [ ] Logs limpos de erros

---

## 🎉 Pronto!

Sua aplicação está **online** em:
```
https://travel-agency-api.onrender.com
```

**Compartilhe este URL** com seus clientes! 🚀

---

## 📱 URL para Compartilhar

Crie um link curto:
```
https://travel-agency-api.onrender.com
```

Ou personalize em:
- bit.ly
- short.link
- seu próprio domínio

---

## 🔄 Próximos Passos

1. **Testar com usuários reais**
2. **Monitorar logs diariamente**
3. **Fazer backup do banco de dados**
4. **Considerar upgrade para Paid**
5. **Adicionar domínio personalizado**

---

## 📞 Problemas?

1. Verifique **Logs** no Render
2. Veja **Metrics** para performance
3. Consulte este guia na seção **Troubleshooting**
4. Faça novo **Manual Deploy**

---

**Última atualização: 2026-09-24**
**Versão: 1.0**
