#!/bin/bash

echo "Creando directorio para las imágenes de disco..."
mkdir -p ${UNAM_HOME}/bda/disk-images
cd ${UNAM_HOME}/bda/disk-images

echo "Creando disk1.img (Capa 0 TEMP) - 500 MB"
dd if=/dev/zero of=disk1.img bs=100M count=5

echo "Creando disk2.img (Capa 1 Principal) - 1.5 GB"
dd if=/dev/zero of=disk2.img bs=100M count=15

echo "Creando disk3.img (Capa 1 Multiplexado) - 500 MB"
dd if=/dev/zero of=disk3.img bs=100M count=5

echo "Creando disk4.img (Capa 2 LOBs) - 3.0 GB"
dd if=/dev/zero of=disk4.img bs=100M count=30

echo "Creando disk5.img (Core 1) - 500 MB"
dd if=/dev/zero of=disk5.img bs=100M count=5

echo "Creando disk6.img (Core 2) - 500 MB"
dd if=/dev/zero of=disk6.img bs=100M count=5

echo "Creando disk7.img (FRA) - 3.0 GB"
dd if=/dev/zero of=disk7.img bs=100M count=30

echo "Mostrando la creación de los archivos:"
du -sh disk*.img 

echo "Asignando loop devices..."
losetup -fP disk1.img
losetup -fP disk2.img
losetup -fP disk3.img
losetup -fP disk4.img
losetup -fP disk5.img
losetup -fP disk6.img
losetup -fP disk7.img

echo "Mostrando la creación de loop devices:"
losetup -a

echo "Dando formato ext4 a los discos..."
mkfs.ext4 disk1.img
mkfs.ext4 disk2.img
mkfs.ext4 disk3.img
mkfs.ext4 disk4.img
mkfs.ext4 disk5.img
mkfs.ext4 disk6.img
mkfs.ext4 disk7.img

echo "Creando la estructura de directorios"
mkdir -p ${UNAM_HOME}/bda/pf/c0/d01
mkdir -p ${UNAM_HOME}/bda/pf/c1/d01
mkdir -p ${UNAM_HOME}/bda/pf/c1/d02
mkdir -p ${UNAM_HOME}/bda/pf/c2/d01
mkdir -p ${UNAM_HOME}/bda/pf/core/d01
mkdir -p ${UNAM_HOME}/bda/pf/core/d02
mkdir -p ${UNAM_HOME}/bda/pf/fra

