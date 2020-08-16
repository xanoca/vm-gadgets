#!/usr/bin/env bash

VM_NAME=$1
OS_TYPE=Ubuntu_64
ISO='/home/'${USER}'/Downloads/xubuntu-20.04-desktop-amd64.iso'

AMOUNT_CPU=4
AMOUNT_MEMORY=4096
GRAPHICS_CONTROLLER=vboxsvga
AMOUNT_VIDEO_MEMORY=48
SIZE_HDD=51200
PATH_SHARED='/home/'${USER}'/VM/share'
PATH_HDD='/home/'${USER}'/VirtualBox VMs/'${VM_NAME}'/'${VM_NAME}'.vdi'

# basic registration
VBoxManage createvm --name "${VM_NAME}" --ostype ${OS_TYPE} --register

# set system performance
VBoxManage modifyvm "${VM_NAME}" --cpus ${AMOUNT_CPU} --memory ${AMOUNT_MEMORY} --vram ${AMOUNT_VIDEO_MEMORY} --graphicscontroller ${GRAPHICS_CONTROLLER}

# removable media
VBoxManage storagectl "${VM_NAME}" --name "IDE Controller" --add ide
VBoxManage storageattach "${VM_NAME}" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "${ISO}"
VBoxManage storageattach "${VM_NAME}" --storagectl "IDE Controller" --port 1 --device 1 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso

# hdd
VBoxManage createhd --filename "${PATH_HDD}" --size ${SIZE_HDD} --variant Standard
VBoxManage storagectl "${VM_NAME}" --name "SATA Controller" --add sata --bootable on
VBoxManage storageattach "${VM_NAME}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${PATH_HDD}"

# shared folder
VBoxManage sharedfolder add "${VM_NAME}" --name share --hostpath "${PATH_SHARED}" --automount

VBoxManage showvminfo "${VM_NAME}"
VBoxManage startvm "${VM_NAME}"
