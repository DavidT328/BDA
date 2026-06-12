#!/bin/bash


echo "Desmontando forzosamente todas las carpetas del proyecto y sesiones previas..."
sudo umount -f ${UNAM_HOME}/bda/pf/c0/d01 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/c1/d01 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/c1/d02 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/c2/d01 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/core/d01 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/core/d02 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/pf/fra 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/disks/d01 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/disks/d02 2>/dev/null
sudo umount -f ${UNAM_HOME}/bda/disks/d03 2>/dev/null

echo "Purgando la memoria del gestor de dispositivos virtuales (loop devices)..."
sudo losetup -D

echo "Erradicando los archivos de imagen de disco fisicos..."
sudo rm -rf ${UNAM_HOME}/bda/disk-images/disk*.img

echo "Eliminando la estructura de directorios del proyecto..."
sudo rm -rf ${UNAM_HOME}/bda/pf
sudo rm -rf ${UNAM_HOME}/bda/disks

echo "Limpieza profunda finalizada exitosamente. El entorno ha regresado a 0."

export UNAM_HOME=/unam



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
mkfs.ext4 -F disk1.img
mkfs.ext4 -F disk2.img
mkfs.ext4 -F disk3.img
mkfs.ext4 -F disk4.img
mkfs.ext4 -F disk5.img
mkfs.ext4 -F disk6.img
mkfs.ext4 -F disk7.img

echo "Creando la estructura de directorios"
mkdir -p ${UNAM_HOME}/bda/pf/c0/d01
mkdir -p ${UNAM_HOME}/bda/pf/c1/d01
mkdir -p ${UNAM_HOME}/bda/pf/c1/d02
mkdir -p ${UNAM_HOME}/bda/pf/c2/d01
mkdir -p ${UNAM_HOME}/bda/pf/core/d01
mkdir -p ${UNAM_HOME}/bda/pf/core/d02
mkdir -p ${UNAM_HOME}/bda/pf/fra 


echo "Montando los discos en las carpetas correspondientes..."
mount -o loop /unam/bda/disk-images/disk1.img /unam/bda/pf/c0/d01
mount -o loop /unam/bda/disk-images/disk2.img /unam/bda/pf/c1/d01
mount -o loop /unam/bda/disk-images/disk3.img /unam/bda/pf/c1/d02
mount -o loop /unam/bda/disk-images/disk4.img /unam/bda/pf/c2/d01
mount -o loop /unam/bda/disk-images/disk5.img /unam/bda/pf/core/d01
mount -o loop /unam/bda/disk-images/disk6.img /unam/bda/pf/core/d02
mount -o loop /unam/bda/disk-images/disk7.img /unam/bda/pf/fra

sudo df -h
echo "Simulacion de discos finalizada exitosamente."
