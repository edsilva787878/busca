# 1. Imagem base - Python 3.9 slim (leve)
FROM python:3.9-slim

# 2. Definir diretório de trabalho dentro do container
WORKDIR /app

# 3. Copiar arquivo de dependências PRIMEIRO (para aproveitar cache)
COPY requirements.txt .

# 4. Instalar as dependências
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar TODO o resto da aplicação
COPY . .

# 6. Expor a porta que a aplicação usa
EXPOSE 5000

# 7. Comando para iniciar a aplicação
CMD ["python", "app.py"]