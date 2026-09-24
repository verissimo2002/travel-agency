# 🏗️ Arquitetura do Sistema

## Visão Geral

```
┌─────────────────────────────────────────────────────────┐
│                   CAMADA APRESENTAÇÃO                   │
│  HTML5 + CSS3 + JavaScript Vanilla (index.html)         │
│  - Interface responsiva mobile-first                    │
│  - WebRTC para acesso à câmera                          │
│  - Progresso visual com 5 etapas                        │
└────────────────┬────────────────────────────────────────┘
                 │
         HTTP/HTTPS (REST API)
                 │
┌────────────────┴────────────────────────────────────────┐
│              CAMADA APLICAÇÃO                            │
│  FastAPI (app.py)                                       │
│  - Validação de entrada                                │
│  - Processamento de imagens                            │
│  - Geração de ZIP encriptado                           │
│  - Logs e tratamento de erros                          │
└────────────────┬────────────────────────────────────────┘
                 │
          ┌──────┴──────┐
          │             │
    ┌─────▼──────┐  ┌──▼──────────┐
    │  SQLite    │  │  Filesystem │
    │  (BD)      │  │  (uploads)  │
    └────────────┘  └─────────────┘
```

## Stack Tecnológico

### Backend
- **Framework**: FastAPI 0.104.1
- **Servidor**: Uvicorn 0.24.0
- **Banco de Dados**: SQLite 3
- **Processamento**: Pillow (PIL)
- **Encriptação**: pyminizip
- **Runtime**: Python 3.11+

### Frontend
- **HTML5** - Estrutura semântica
- **CSS3** - Layouts responsivos com Flexbox
- **JavaScript (ES6)** - Sem dependências externas
- **WebRTC** - Acesso à câmera
- **Fetch API** - Comunicação com servidor

### DevOps
- **Containerização**: Docker + Docker Compose
- **Versionamento**: Git
- **CI/CD**: GitHub Actions (opcional)

---

## Fluxo de Dados

### 1️⃣ Captura de Passaporte

```
User Input (Número Passaporte)
    ↓
✓ Validação (8-10 caracteres)
    ↓
Inicializar Câmera (getUserMedia)
    ↓
Canvas Capture (passportCanvas)
    ↓
Convert para Blob
    ↓
Store em this.passportImage
```

### 2️⃣ Escaneamento Facial

```
Inicializar Câmera (getUserMedia)
    ↓
Exibir Máscara Circular
    ↓
"Look at camera" → "Hold still" (3s)
    ↓
Canvas Capture (facialCanvas)
    ↓
Convert para Blob
    ↓
Store em this.selfieImage
```

### 3️⃣ Processamento Backend

```
FormData (POST /api/process-documents)
    ├─ passport_number (string)
    ├─ passport_image (blob)
    └─ selfie_image (blob)
    ↓
✓ Validações no Backend
    ↓
Create Temporary Files
    ├─ temp_pass_path (JPG)
    └─ temp_self_path (JPG)
    ↓
Create ZIP (deflate)
    ├─ passaporte.jpg
    ├─ selfie.jpg
    └─ METADATA.txt
    ↓
Encrypt ZIP com pyminizip
    └─ Senha: Angola2019@
    ↓
Save em uploads/{PASSAPORTE}.zip
    ↓
Register em SQLite
    ├─ numero_passaporte
    ├─ nome_arquivo_zip
    ├─ data_hora
    └─ ip_cliente
    ↓
Clean Temporary Files
    ↓
Return Success Response
```

### 4️⃣ Download

```
User Click "Baixar ZIP"
    ↓
GET /api/download/{zip_filename}
    ↓
✓ Validar nome arquivo (segurança)
    ↓
✓ Verificar existência arquivo
    ↓
FileResponse (application/zip)
    ↓
Browser Download Iniciado
```

---

## Estrutura de Pastas

```
travel-agency-system/
│
├── 📄 app.py                    # Backend FastAPI
│   ├── Endpoints REST
│   ├── Processamento de imagens
│   ├── Geração de ZIP
│   └── Banco de dados
│
├── 🎨 index.html                # Frontend Completo
│   ├── HTML (Estrutura)
│   ├── CSS (Estilos)
│   └── JavaScript (Lógica)
│
├── 📦 requirements.txt           # Dependências Python
├── 🐳 Dockerfile                # Containerização
├── 🐳 docker-compose.yml        # Orquestração
│
├── 📚 Documentação
│   ├── README.md                # Guia completo
│   ├── QUICKSTART.md            # Início rápido
│   ├── ARCHITECTURE.md          # Este arquivo
│   └── .env.example             # Variáveis exemplo
│
├── 🔧 Scripts
│   ├── start.sh                 # Inicialização (Unix)
│   └── start.bat                # Inicialização (Windows)
│
├── 📊 Dados
│   ├── viagens.db               # Banco SQLite (criado)
│   ├── uploads/                 # ZIPs gerados
│   └── temp/                    # Arquivos temporários
│
├── 🔍 Utilitários
│   ├── queries.sql              # SQL examples
│   └── .gitignore               # Git ignore rules
│
└── 📝 Versão: 1.0.0

```

---

## Endpoints da API

### Health Check
```http
GET /api/health
Response: {
    "status": "healthy"
}
```

### Processar Documentos
```http
POST /api/process-documents
Content-Type: multipart/form-data

Parameters:
- passport_number: string (8-10 chars)
- passport_image: file (JPG/PNG)
- selfie_image: file (JPG/PNG)

Response 200:
{
    "status": "success",
    "message": "Documentos processados com sucesso",
    "zip_filename": "N16E7272.zip",
    "passport_number": "N16E7272"
}

Response 400:
{
    "detail": "Número de passaporte inválido"
}
```

### Download ZIP
```http
GET /api/download/{zip_filename}

Response: 
- Content-Type: application/zip
- Content-Disposition: attachment; filename="{zip_filename}"
- Body: arquivo binário ZIP

Status:
- 200: Arquivo enviado
- 404: Arquivo não encontrado
- 400: Nome de arquivo inválido
```

---

## Schema do Banco de Dados

### Tabela: clientes_downloads

```sql
CREATE TABLE clientes_downloads (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_passaporte     TEXT NOT NULL,
    nome_arquivo_zip      TEXT NOT NULL,
    data_hora             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_cliente            TEXT,
    status                TEXT DEFAULT 'concluido'
);
```

### Exemplos de Dados

```
id | numero_passaporte | nome_arquivo_zip | data_hora              | status
1  | N16E7272          | N16E7272.zip     | 2024-01-15 14:30:45   | concluido
2  | AB123456          | AB123456.zip     | 2024-01-15 15:45:30   | concluido
```

---

## Fluxo de Frontend (State Machine)

```
         ┌─────────────────┐
         │   STEP 1        │
         │ Passport ID     │
         └────────┬────────┘
                  │ valid input
                  ▼
         ┌─────────────────┐
         │   STEP 2        │
         │ Passport Photo  │
         └────────┬────────┘
                  │ photo captured
                  ▼
         ┌─────────────────┐
         │   STEP 3        │
         │ Prepare Facial  │
         └────────┬────────┘
                  │ user ready
                  ▼
         ┌─────────────────┐
         │   STEP 4        │
         │ Facial Scan     │
         └────────┬────────┘
                  │ image captured
                  ▼ + processing
         ┌─────────────────┐
         │   STEP 5        │
         │ Download        │
         └────────┬────────┘
                  │ zip ready
                  ▼
           [USER DOWNLOADS]
```

---

## Validações de Segurança

### Client-Side
- ✅ Número passaporte: 8-10 caracteres
- ✅ Imagens não vazias
- ✅ Validação de entrada em tempo real
- ⚠️ NÃO sensível (pode ser bypassed)

### Server-Side
- ✅ Validação rigorosa de input
- ✅ Path traversal prevention
- ✅ Size limits em uploads
- ✅ Type checking de arquivo
- ✅ Rate limiting (recomendado)
- ✅ CORS configurável

### Encriptação
- ✅ ZIP com password
- ✅ Algoritmo deflate
- ✅ Senha fixa (configurável)

---

## Performance & Otimizações

### Frontend
- Compressão de imagens antes de upload
- Lazy loading de assets
- Event throttling em input
- Cache de objetos de canvas

### Backend
- Processamento de imagem otimizado
- Limpeza automática de temp files
- Connection pooling SQLite
- Response compression (gzip)

### Tamanho de Arquivo
- Imagem típica: 2-4 MB (bruta)
- Imagem comprimida: 200-500 KB
- ZIP final: ~400 KB (2 imagens + metadata)

---

## Estrutura JavaScript (Frontend)

```javascript
class DocumentProcessor {
    constructor()
        - Inicializa estado
        - Registra listeners de evento
    
    // Métodos Públicos
    initializeEventListeners()
        - Conecta eventos DOM
    
    updatePassportInput(e)
        - Validação em tempo real
    
    async goToStep(step)
        - Navega entre etapas
    
    async initializePassportCamera()
        - Acessa câmera para passaporte
    
    capturePassportPhoto()
        - Captura via canvas
    
    // ... outros métodos
    
    // Métodos Privados
    async performFacialScan()
        - Automação do scan
    
    async processDocuments()
        - Envia FormData ao servidor
    
    async startDownload()
        - Inicia download do ZIP
}
```

---

## Dependências Externas

### Instalação Automática
```bash
pip install -r requirements.txt
```

### Manual
```bash
pip install fastapi==0.104.1
pip install uvicorn==0.24.0
pip install python-multipart==0.0.6
pip install pyminizip==0.2.4
pip install pillow==10.1.0
```

---

## Segurança em Produção

### Recomendações
1. **HTTPS Obrigatório**
   - Use Let's Encrypt
   - Configure reverse proxy (Nginx)

2. **Rate Limiting**
   - Limit uploads por IP
   - Máximo 100 uploads/hora

3. **Autenticação** (opcional)
   - Adicionar JWT tokens
   - Validar origem de requisição

4. **Logs & Monitoramento**
   - ELK Stack para logs centralizados
   - Sentry para error tracking
   - Prometheus para métricas

5. **Backup Regular**
   - Backup diário do banco
   - Replicação de uploads

---

## Escalabilidade

### Padrão Atual
- ✅ Single server
- ✅ SQLite local
- ✅ Filesystem storage
- ⚠️ Limite: 1K+ uploads/dia

### Para Crescer
1. **Banco de Dados**
   - Migrar para PostgreSQL
   - Replicação + backup

2. **Storage**
   - S3/AWS ou equivalente
   - CDN para distribuição

3. **API**
   - Load balancer (Nginx)
   - Multiple workers (Gunicorn)
   - Message queue (Celery)

4. **Cache**
   - Redis para session
   - Memcache para temp data

---

## Monitoramento & Observabilidade

### Métricas Importantes
- Tempo de processamento
- Taxa de sucesso/erro
- Espaço em disco usado
- Conexões ativas
- Erros de câmera

### Logs
```bash
# Ver logs em tempo real
tail -f app.log

# Filtrar erros
grep ERROR app.log

# Estatísticas
grep 'Processado' app.log | wc -l
```

---

## Changelog

### v1.0.0 (Atual)
- ✅ Interface 5-step completa
- ✅ Captura de foto + facial
- ✅ ZIP encriptado
- ✅ Banco de dados SQLite
- ✅ Docker support
- ✅ Documentação completa

### v1.1.0 (Planejado)
- Multi-language support
- Email notifications
- Admin dashboard
- Analytics
- Enhanced security

---

## Suporte & Contribuição

Para dúvidas técnicas, consulte:
1. `README.md` - Documentação geral
2. `QUICKSTART.md` - Início rápido
3. Logs da aplicação
4. Console do navegador (F12)

---

**Última atualização: 2024**
**Versão do documento: 1.0**
