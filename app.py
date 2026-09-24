"""
Travel Agency Document Processing System
Backend API com FastAPI
"""

from fastapi import FastAPI, UploadFile, File, HTTPException, Form
from fastapi.responses import FileResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import sqlite3
import os
import shutil
from datetime import datetime
from pathlib import Path
import base64
import io
import zipfile
import pyminizip

# Configuração
app = FastAPI(title="Travel Agency API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Diretórios
UPLOAD_DIR = Path("uploads")
DATABASE_FILE = "viagens.db"
TEMP_DIR = Path("temp")

UPLOAD_DIR.mkdir(exist_ok=True)
TEMP_DIR.mkdir(exist_ok=True)

# Senha fixa para ZIP
ZIP_PASSWORD = "Angola2019@"


def init_database():
    """Inicializa banco de dados SQLite"""
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS clientes_downloads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numero_passaporte TEXT NOT NULL,
            nome_arquivo_zip TEXT NOT NULL,
            data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ip_cliente TEXT,
            status TEXT DEFAULT 'concluido'
        )
    ''')
    
    conn.commit()
    conn.close()


def salvar_registro_banco(passport_number: str, zip_filename: str, ip_cliente: str = None):
    """Salva registro no banco de dados"""
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT INTO clientes_downloads 
        (numero_passaporte, nome_arquivo_zip, ip_cliente)
        VALUES (?, ?, ?)
    ''', (passport_number, zip_filename, ip_cliente))
    
    conn.commit()
    conn.close()


def criar_zip_protegido(passport_number: str, passport_image: bytes, selfie_image: bytes) -> str:
    """
    Cria arquivo ZIP protegido por senha com as imagens
    Retorna caminho do arquivo ZIP criado
    """
    zip_filename = f"{passport_number}.zip"
    zip_path = UPLOAD_DIR / zip_filename
    temp_pass_path = TEMP_DIR / f"{passport_number}_passaporte.jpg"
    temp_self_path = TEMP_DIR / f"{passport_number}_selfie.jpg"
    
    try:
        # Salva imagens temporárias
        with open(temp_pass_path, "wb") as f:
            f.write(passport_image)
        with open(temp_self_path, "wb") as f:
            f.write(selfie_image)
        
        # Cria ZIP sem proteção primeiro (pyminizip requer isso)
        temp_zip = TEMP_DIR / f"temp_{zip_filename}"
        with zipfile.ZipFile(temp_zip, 'w', zipfile.ZIP_DEFLATED) as zf:
            zf.write(temp_pass_path, arcname="passaporte.jpg")
            zf.write(temp_self_path, arcname="selfie.jpg")
            
            # Adiciona arquivo de metadata
            metadata = f"""Documento gerado em: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}
Número do Passaporte: {passport_number}
Tipo: Processamento de Documentos - Agência de Viagens
"""
            zf.writestr("METADATA.txt", metadata)
        
        # Converte para ZIP protegido com senha usando pyminizip
        pyminizip.compress_file(
            str(temp_zip),
            '',
            str(zip_path),
            5,
            ZIP_PASSWORD.encode('utf-8')
        )
        
        # Remove arquivos temporários
        temp_zip.unlink(missing_ok=True)
        temp_pass_path.unlink(missing_ok=True)
        temp_self_path.unlink(missing_ok=True)
        
        return zip_filename
        
    except Exception as e:
        print(f"Erro ao criar ZIP: {str(e)}")
        raise


@app.get("/")
async def root():
    """Retorna a página HTML principal"""
    return FileResponse("index.html", media_type="text/html")


@app.post("/api/process-documents")
async def process_documents(
    passport_number: str = Form(...),
    passport_image: UploadFile = File(...),
    selfie_image: UploadFile = File(...)
):
    """
    Processa as imagens, cria ZIP protegido e registra no banco
    """
    try:
        # Validação básica
        if not passport_number or len(passport_number) < 8 or len(passport_number) > 10:
            raise HTTPException(status_code=400, detail="Número de passaporte inválido")
        
        # Lê imagens
        passport_data = await passport_image.read()
        selfie_data = await selfie_image.read()
        
        if not passport_data or not selfie_data:
            raise HTTPException(status_code=400, detail="Imagens vazias")
        
        # Cria ZIP protegido
        zip_filename = criar_zip_protegido(passport_number, passport_data, selfie_data)
        
        # Registra no banco de dados
        salvar_registro_banco(passport_number, zip_filename)
        
        return JSONResponse({
            "status": "success",
            "message": "Documentos processados com sucesso",
            "zip_filename": zip_filename,
            "passport_number": passport_number
        })
        
    except HTTPException:
        raise
    except Exception as e:
        print(f"Erro no processamento: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Erro ao processar documentos: {str(e)}")


@app.get("/api/download/{zip_filename}")
async def download_zip(zip_filename: str):
    """
    Download do arquivo ZIP protegido
    """
    try:
        # Validação de segurança - evita path traversal
        if ".." in zip_filename or "/" in zip_filename:
            raise HTTPException(status_code=400, detail="Nome de arquivo inválido")
        
        file_path = UPLOAD_DIR / zip_filename
        
        if not file_path.exists():
            raise HTTPException(status_code=404, detail="Arquivo não encontrado")
        
        return FileResponse(
            file_path,
            media_type="application/zip",
            filename=zip_filename
        )
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return JSONResponse({"status": "healthy"})


@app.on_event("startup")
async def startup_event():
    """Inicializa sistema ao iniciar"""
    init_database()
    print("✓ Sistema iniciado")
    print(f"✓ Banco de dados: {DATABASE_FILE}")
    print(f"✓ Diretório de uploads: {UPLOAD_DIR}")
    print(f"✓ Senha de ZIP: {ZIP_PASSWORD}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
