#!/bin/bash

# Atualizar o sistema e instalar o base-devel
sudo pacman -Syu base-devel

# Criar uma partição de boot
fdisk /dev/sda

# Formatar a partição de boot como ext4
mkfs.ext4 /dev/sda1

# Montar a partição de boot
mount /dev/sda1 /mnt

# Baixar e instalar o Arch Linux
pacstrap /mnt base linux linux-firmware

# Gerar o arquivo fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Entrar na nova instalação do Arch Linux
arch-chroot /mnt

# Configurar o idioma do sistema
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Configurar o fuso horário
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

# Configurar o hostname
echo "myhostname" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 myhostname.localdomain myhostname" >> /etc/hosts

# Configurar o grub
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# senha root
passwd root

# Criar um usuário
useradd -m -G wheel myuser
passwd myuser

# Habilitar o suporte a sudo
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/10-wheel

# network
pacman -Sy networkmanager

# active network
systemctl start NetworkManager

# Sair da instalação do Arch Linux e reiniciar o sistema
exit
reboot
