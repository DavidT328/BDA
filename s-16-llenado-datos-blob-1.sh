#!/bin/bash
echo "1. Creando carpetas temporales para los archivos multimedia..."
mkdir -p /tmp/media_files/albumes
mkdir -p /tmp/media_files/videos

echo "2. Generando 50 imágenes dummy para los álbumes..."
for i in {1..50}; do
  # Crea un archivo de 50KB simulando un JPG
  dd if=/dev/urandom of=/tmp/media_files/albumes/album_${i}.jpg bs=1024 count=50 2>/dev/null
done

echo "3. Generando videos dummy (Asumiremos que el Python generó unos 1000 videos)..."
# Ajusta este número si tu Python genera más o menos videos
for i in {1..1500}; do
  # Crea un archivo de 100KB simulando un MP4
  dd if=/dev/urandom of=/tmp/media_files/videos/video_${i}.mp4 bs=1024 count=100 2>/dev/null
done

echo "4. Asignando permisos al usuario oracle..."
chown -R oracle:oinstall /tmp/media_files
chmod -R 750 /tmp/media_files

echo "¡Archivos físicos generados!"