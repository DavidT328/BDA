#!/bin/bash
# s-15-copia-media.sh
# Descripción: Creación de directorios físicos y descompresión de archivos LOB

base_path="/opt/oracle/oradata/FREE/files/unam/bda/pf/media"

echo "==> Crear directorios físicos en el server para todos los LOBs"
sudo -u oracle bash << EOF
mkdir -p ${base_path}/videos
mkdir -p ${base_path}/audios
mkdir -p ${base_path}/letras
mkdir -p ${base_path}/albumes

# Limpiar las carpetas por si ya tenían basura
rm -f ${base_path}/videos/*
rm -f ${base_path}/audios/*
rm -f ${base_path}/letras/*
rm -f ${base_path}/albumes/*

# Descomprimir los zips en sus respectivas carpetas
# (Asegúrate de tener estos archivos .zip en la misma ruta donde ejecutas este script)
unzip -j videos.zip -d ${base_path}/videos
unzip -j audios.zip -d ${base_path}/audios
unzip -j letras.zip -d ${base_path}/letras
unzip -j albumes.zip -d ${base_path}/albumes

echo "==> Verificando archivos copiados:"
echo "Total Videos: \$(ls -1 ${base_path}/videos | wc -l)"
echo "Total Audios: \$(ls -1 ${base_path}/audios | wc -l)"
echo "Total Letras: \$(ls -1 ${base_path}/letras | wc -l)"
echo "Total Álbumes: \$(ls -1 ${base_path}/albumes | wc -l)"
EOF