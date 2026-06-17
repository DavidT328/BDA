#!/bin/bash

TOTAL_REGISTROS=20

mkdir -p dummy_media/{videos,audios,albumes,letras}

echo "Generando archivos..."

for i in $(seq 1 $TOTAL_REGISTROS); do

    # Albumes (~300 bytes)
    head -c 300 /dev/urandom \
        > dummy_media/albumes/album_${i}.jpg

    # Videos (~900 bytes) - El más pesado, al multiplicarse por 2000 dará ~1.8 MB
    head -c 900 /dev/urandom \
        > dummy_media/videos/video_${i}.mp4

    # Audios (~500 bytes)
    head -c 500 /dev/urandom \
        > dummy_media/audios/audio_${i}.mp3

    # Letras (~100 bytes)
    base64 /dev/urandom | head -c 100 \
        > dummy_media/letras/letra_${i}.txt

done

echo "Comprimiendo..."

cd dummy_media

zip -q -j albumes.zip albumes/*
zip -q -j videos.zip videos/*
zip -q -j audios.zip audios/*
zip -q -j letras.zip letras/*

mv *.zip ..
cd ..
rm -rf dummy_media

echo "Archivos generados:"
ls -lh *.zip