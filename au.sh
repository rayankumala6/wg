#!/bin/bash

# Konfigurasi
img_file="windows11.img"
iso_link="http://134.199.163.87/WIN11.iso"
iso_file="windows11.iso"
virtio_iso="virtio-win.iso"
vm_ram="8G"  # 8 GB RAM untuk VM
vm_cpus="4"  # 4 vCPU untuk VM
rdp_port="6969"  # Port RDP yang akan digunakan

# Langkah 1: Unduh ISO Windows 11
echo "Mengunduh ISO Windows 11..."
wget -O "$iso_file" "$iso_link"

# Langkah 2: Unduh VirtIO ISO
echo "Mengunduh VirtIO ISO..."
wget -O "$virtio_iso" 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso'

# Langkah 3: Buat Disk Image untuk Windows 11
echo "Membuat disk image untuk Windows 11..."
qemu-img create -f qcow2 "$img_file" 40G

# Langkah 4: Jalankan VM Windows 11 dengan QEMU/KVM
echo "Menjalankan VM Windows 11..."
qemu-system-x86_64 \
  -m "$vm_ram" \
  -cpu host \
  -enable-kvm \
  -smp "$vm_cpus" \
  -boot order=d \
  -drive file="$iso_file",media=cdrom \
  -drive file="$img_file",format=qcow2,if=virtio \
  -drive file="$virtio_iso",media=cdrom \
  -netdev user,id=net0,hostfwd=tcp::"$rdp_port"-:3389 \
  -device virtio-net,netdev=net0 \
  -device usb-ehci,id=usb,bus=pci.0,addr=0x4 \
  -device usb-tablet \
  -vnc :0

echo "VM Windows 11 berhasil dijalankan. Gunakan VNC viewer untuk mengakses VM di port 5900."
echo "Gunakan RDP dengan alamat IP VPS dan port $rdp_port."
