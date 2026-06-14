#!/bin/bash

TOTAL_REGISTROS=2000

mkdir -p dummy_media/{videos,audios,albumes,letras}

echo "Generando archivos..."

for i in $(seq 1 $TOTAL_REGISTROS); do

    # Albumes (~50 KB)
    head -c 51200 /dev/urandom \
        > dummy_media/albumes/album_${i}.jpg

    # Videos (~250 KB)
    head -c 256000 /dev/urandom \
        > dummy_media/videos/video_${i}.mp4

    # Audios (~100 KB)
    head -c 102400 /dev/urandom \
        > dummy_media/audios/audio_${i}.mp3

    # Letras (~5 KB)
    base64 /dev/urandom | head -c 5120 \
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