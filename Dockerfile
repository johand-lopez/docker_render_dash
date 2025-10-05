# ======================================================
#   Imagen base ligera de Python
# ======================================================
FROM python:3.10-slim

# ======================================================
#   Configurar directorio de trabajo
# ======================================================
WORKDIR /app

# ======================================================
#   Instalar dependencias del sistema necesarias
#   para geopandas, shapely, fiona, gdal, etc.
# ======================================================
RUN apt-get update && apt-get install -y \
    build-essential \
    gdal-bin \
    libgdal-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# ======================================================
#   Copiar los archivos de requerimientos
# ======================================================
COPY requirements.txt .

# ======================================================
#   Instalar librerías de Python
# ======================================================
RUN pip install --no-cache-dir -r requirements.txt

# ======================================================
#   Copiar el resto de los archivos de la app
# ======================================================
COPY . .

# ======================================================
#   Exponer el puerto dinámico de Render
# ======================================================
EXPOSE 8501

# ======================================================
#   Comando de ejecución (Render asigna $PORT)
# ======================================================
CMD ["python", "-m", "streamlit", "run", "app.py", "--server.port=${PORT}", "--server.address=0.0.0.0"]
