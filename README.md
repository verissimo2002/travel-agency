# 🎫 Sistema de Processamento de Documentos - Agência de Viagens

Sistema web completo e profissional para captura, processamento e encriptação de documentos de viagem. Desenvolvido com FastAPI (Backend) e HTML5/JavaScript vanilla (Frontend).

## ✨ Características

- ✅ **Interface Multi-etapa**: 5 passos guiados para captura de documentos
- ✅ **Acesso à Câmera**: Captura nativa de fotos via navegador
- ✅ **Processamento em Real-time**: Validações instantâneas
- ✅ **Encriptação ZIP**: Proteção com senha fixa `Angola2019@`
- ✅ **Banco de Dados SQLite**: Rastreamento de downloads
- ✅ **Design Mobile-first**: Totalmente responsivo e moderno
- ✅ **Barra de Progresso Visual**: Indicador de etapas concluídas
- ✅ **Preview de Imagens**: Visualização antes de confirmar

## 📋 Pré-requisitos

- Python 3.11+
- pip (gerenciador de pacotes Python)
- Navegador moderno com suporte a WebRTC
- Git (opcional)

## 🚀 Instalação Rápida (Local)

### 1. Clone ou Baixe os Arquivos

```bash
# Se usando git
git clone <seu-repositorio>
cd travel-agency-system

# Ou simplesmente extraia os arquivos
```

### 2. Crie um Ambiente Virtual (Recomendado)

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Mac/Linux
python3 -m venv venv
source venv/bin/activate
```

### 3. Instale as Dependências

```bash
pip install -r requirements.txt
```

### 4. Inicie o Servidor

```bash
python app.py
```

Você verá algo como:
```
✓ Sistema iniciado
✓ Banco de dados: viagens.db
✓ Diretório de uploads: uploads
✓ Senha de ZIP: Angola2019@
```

### 5. Acesse a Aplicação

Abra seu navegador em: **http://localhost:8000**

## 🐳 Instalação com Docker (Recomendado para Produção)

### Pré-requisitos
- Docker instalado
- Docker Compose instalado

### Passo 1: Build da Imagem

```bash
docker-compose build
```

### Passo 2: Iniciar Container

```bash
docker-compose up
```

A aplicação estará disponível em: **http://localhost:8000**

## 📁 Estrutura do Projeto

```
travel-agency-system/
├── app.py                  # Servidor FastAPI (Backend)
├── index.html              # Interface web (Frontend)
├── requirements.txt        # Dependências Python
├── Dockerfile              # Configuração Docker
├── docker-compose.yml      # Orquestração Docker
├── README.md              # Este arquivo
├── viagens.db             # Banco de dados SQLite (criado automaticamente)
├── uploads/               # Pasta com ZIPs gerados
└── temp/                  # Pasta temporária
```

## 🎨 Fluxo da Aplicação

### Passo 1: ID do Passaporte
- Usuário digita número do passaporte (8-10 caracteres)
- Validação em tempo real
- Botão "Continue" ativa ao validar

### Passo 2: Foto do Passaporte
- Acesso à câmera do dispositivo
- Captura com botão circular
- Preview e opções de retomar/aceitar

### Passo 3: Preparação Facial
- Instruções em 4 etapas
- Ambiente bem iluminado requerido
- Preparação antes do escaneamento

### Passo 4: Escaneamento Facial
- Máscara circular no centro
- "Look at the camera" → "Hold still"
- Captura automática após 3 segundos
- Processamento de imagens

### Passo 5: Download
- Preview da foto de passaporte
- Card com informações do arquivo
- Botão de download do ZIP encriptado
- Botão para terminar e recomeçar

## 🔐 Segurança & Encriptação

### Proteção de ZIP
- **Senha fixa**: `Angola2019@`
- **Algoritmo**: ZIP deflate com encriptação
- **Conteúdo**: Passaporte + Selfie + Metadata

### Banco de Dados
- **Engine**: SQLite (viagens.db)
- **Dados armazenados**:
  - Número do passaporte
  - Nome do arquivo ZIP
  - Data/Hora do processamento
  - IP do cliente (opcional)

## 💾 Banco de Dados

### Tabela `clientes_downloads`

```sql
CREATE TABLE clientes_downloads (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_passaporte TEXT NOT NULL,
    nome_arquivo_zip TEXT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_cliente TEXT,
    status TEXT DEFAULT 'concluido'
);
```

### Consultar Registros

```bash
# Abrir SQLite CLI
sqlite3 viagens.db

# Consultar downloads
SELECT * FROM clientes_downloads;

# Ver downloads por dia
SELECT DATE(data_hora), COUNT(*) as total 
FROM clientes_downloads 
GROUP BY DATE(data_hora);
```

## 🛠️ API Endpoints

### Health Check
```
GET /api/health
Response: {"status": "healthy"}
```

### Processar Documentos
```
POST /api/process-documents
Content-Type: multipart/form-data

Parâmetros:
- passport_number: string (8-10 chars)
- passport_image: file (JPG)
- selfie_image: file (JPG)

Response:
{
    "status": "success",
    "message": "Documentos processados com sucesso",
    "zip_filename": "N16E7272.zip",
    "passport_number": "N16E7272"
}
```

### Download ZIP
```
GET /api/download/{zip_filename}
Response: arquivo binário ZIP
```

## 🌐 Deploy em Produção

### Option 1: Render.com (Recomendado para você)

1. Faça push do repositório para GitHub
2. Conecte Render.com ao repositório
3. Crie novo "Web Service"
4. Configure:
   - Build command: `pip install -r requirements.txt`
   - Start command: `uvicorn app:app --host 0.0.0.0`
   - Environment: Python 3.11

### Option 2: Heroku

```bash
# Login Heroku
heroku login

# Criar app
heroku create seu-app-name

# Deploy
git push heroku main
```

### Option 3: DigitalOcean/Linode

```bash
# Instalar Python
sudo apt update && sudo apt install python3.11 python3-pip

# Clonar repositório
git clone seu-repo

# Setup environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Usar systemd ou supervisor para manter rodando
```

## 📊 Monitoramento & Logs

### Ver logs em tempo real (Docker)
```bash
docker-compose logs -f web
```

### Analisar banco de dados
```bash
# Ver todos os downloads
sqlite3 viagens.db "SELECT * FROM clientes_downloads;"

# Ver estatísticas
sqlite3 viagens.db "SELECT COUNT(*) as total_downloads FROM clientes_downloads;"

# Exportar para CSV
sqlite3 viagens.db ".headers on" ".mode csv" "SELECT * FROM clientes_downloads;" > relatorio.csv
```

## 🐛 Troubleshooting

### Erro: "Câmera não disponível"
- Verifique permissões do navegador
- Use HTTPS em produção (câmera requer contexto seguro)
- Teste em navegador diferente

### Erro: "Não consegui criar ZIP"
- Verifique espaço em disco
- Confirme permissões na pasta `uploads/`
- Reinstale pyminizip: `pip install --upgrade pyminizip`

### Erro: "Banco de dados bloqueado"
- Feche outras conexões SQLite
- Aguarde alguns segundos e tente novamente
- Em produção, considere usar PostgreSQL

### Lentidão no upload
- Verifique conexão de internet
- Comprime imagens antes de enviar
- Use CDN para servir assets estáticos

## 🔄 HTTPS em Produção

**IMPORTANTE**: Para usar câmera em produção, você PRECISA de HTTPS.

### Com Let's Encrypt (Nginx)
```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Gerar certificado
sudo certbot certonly --standalone -d seu-dominio.com

# Configurar Nginx com SSL
# ... (veja documentação oficial)
```

### Self-signed (Teste apenas)
```bash
openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365
```

## 📱 Compatibilidade

| Browser | Desktop | Mobile |
|---------|---------|--------|
| Chrome  | ✅      | ✅     |
| Firefox | ✅      | ✅     |
| Safari  | ✅      | ✅     |
| Edge    | ✅      | ✅     |

**Nota**: iOS Safari tem restrições com acesso à câmera. Recomenda-se usar app nativo ou PWA.

## 🎯 Configurações Personalizáveis

### Alterar Senha do ZIP
Edite `app.py`:
```python
ZIP_PASSWORD = "SuaSenhaAqui@"
```

### Ajustar Duração do Escaneamento Facial
Edite `index.html`:
```javascript
this.facialScanDuration = 3000; // em milissegundos
```

### Mudar Cores
Edite `index.html`, na seção `<style>`:
```css
:root {
    --primary-color: #6366f1;  /* Azul roxo */
    --secondary-color: #8b5cf6; /* Roxo */
    /* ... outras cores */
}
```

## 📞 Suporte & Contribuição

Para problemas ou sugestões:
1. Verifique esta documentação
2. Consulte logs do servidor
3. Teste em ambiente local primeiro
4. Relate issues no GitHub

## 📄 Licença

Este sistema é fornecido para uso profissional em agências de viagem.

## 🚀 Próximos Passos

1. **Personalize cores e marca** - Edite CSS em `index.html`
2. **Configure banco de dados** - Use PostgreSQL em produção
3. **Setup HTTPS** - Use Certbot/Let's Encrypt
4. **Deploy** - Use Render, Heroku ou DigitalOcean
5. **Monitore** - Configure alertas de erro

---

**Desenvolvido com ❤️ para sua Agência de Viagens**

Última atualização: 2026
