# ======================================================
#   Imagen base de Python (Render usa 3.10 estable)
# ======================================================
FROM python:3.10-slim

# ======================================================
#   Directorio de trabajo
# ======================================================
WORKDIR /app

# ======================================================
#   Instalar dependencias del sistema necesarias
#   para geopandas, fiona, shapely, gdal, etc.
# ======================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gdal-bin \
    libgdal-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# ======================================================
#   Copiar requerimientos
# ======================================================
COPY requirements.txt .

# 🔥 NUEVO PASO AÑADIDO 🔥
# Esto asegura que pip esté instalado y actualizado ANTES
# de ejecutar pip install (previene el error de 'No module named streamlit')
RUN python3 -m ensurepip
RUN python3 -m pip install --upgrade pip

# ======================================================
#   Instalar dependencias del proyecto
# ======================================================
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# ======================================================
#   Copiar el resto de los archivos del proyecto
# ======================================================
COPY . .

# ======================================================
#   Exponer puerto dinámico (Render usa la variable $PORT)
# ======================================================
EXPOSE 8501

# ======================================================
#   Ejecutar la app Streamlit
# ======================================================
CMD ["python3", "-m", "streamlit", "run", "app.py", "--server.port=${PORT}", "--server.address=0.0.0.0"]

