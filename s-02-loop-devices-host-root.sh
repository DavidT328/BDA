#!/bin/bash

echo "Creando directorio para las imágenes de disco..."
mkdir -p ${UNAM_HOME}/bda/disk-images
cd ${UNAM_HOME}/bda/disk-images

echo "Creando disk1.img (Capa 0 TEMP) - 1G"
dd if=/dev/zero of=disk1.img bs=100M count=10

echo "Creando disk2.img (Capa 1 Principal) - 1.5 GB"
dd if=/dev/zero of=disk2.img bs=100M count=15

echo "Creando disk3.img (Capa 1 Multiplexado) - 1.5G"
dd if=/dev/zero of=disk3.img bs=100M count=15

echo "Creando disk4.img (Capa 2 LOBs) - 4.0 GB"
dd if=/dev/zero of=disk4.img bs=100M count=40

echo "Creando disk5.img (Core 1) - 6G"
dd if=/dev/zero of=disk5.img bs=100M count=60

echo "Creando disk6.img (Core 2) - 6G"
dd if=/dev/zero of=disk6.img bs=100M count=60

echo "Creando disk7.img (FRA) - 4.0 GB" 
dd if=/dev/zero of=disk7.img bs=100M count=40

echo "Mostrando la creación de los archivos:"
du -sh disk*.img 

echo "Dando formato ext4 a los discos (Forzado para evitar pausas)..."
mkfs.ext4 -F disk1.img
mkfs.ext4 -F disk2.img
mkfs.ext4 -F disk3.img
mkfs.ext4 -F disk4.img
mkfs.ext4 -F disk5.img
mkfs.ext4 -F disk6.img
mkfs.ext4 -F disk7.img

echo "Asignando loop devices..."
losetup -fP disk1.img
losetup -fP disk2.img
losetup -fP disk3.img
losetup -fP disk4.img
losetup -fP disk5.img
losetup -fP disk6.img
losetup -fP disk7.img

echo "Mostrando la creación de loop devices (Revisa qué número de loop tomó cada uno):"
losetup -a

echo "Creando la estructura de directorios"
mkdir -p ${UNAM_HOME}/bda/pf/c0/d01
mkdir -p ${UNAM_HOME}/bda/pf/c0/d02
mkdir -p ${UNAM_HOME}/bda/pf/c0/d03
mkdir -p ${UNAM_HOME}/bda/pf/c0/fra
mkdir -p ${UNAM_HOME}/bda/pf/c1/d01
mkdir -p ${UNAM_HOME}/bda/pf/c1/d02
mkdir -p ${UNAM_HOME}/bda/pf/c2/d01

echo "Montando los discos en la estructura de directorios..."
# IMPORTANTE: Verifica con losetup -a que los loops coincidan (loop0 = disk1, loop1 = disk2, etc.)
#mount /dev/loop0 ${UNAM_HOME}/bda/pf/c0/d01

mount -o loop /dev/loop0 ${UNAM_HOME}/bda/disks/d01

echo "¡Infraestructura física lista!"
df -h | grep bda