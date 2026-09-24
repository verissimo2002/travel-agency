FROM python:3.11-slim

WORKDIR /app

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia requirements
COPY requirements.txt .

# Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia arquivos da aplicação
COPY app.py .
COPY index.html .

# Cria diretórios necessários
RUN mkdir -p uploads temp

# Expõe porta
EXPOSE 8000

# Comando para iniciar
CMD ["python", "app.py"]
