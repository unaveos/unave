#! /bin/bash

# Copyright (c) 2021 Romullo @hiukky.

# This file is part of UnaveOS
# (see https://github.com/unave).

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


function install_deps() {
    pacman -Syyu archiso virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat --noconfirm
}

function set_qemu() {
    systemctl enable libvirtd.service
    systemctl start libvirtd.service

    sed -i 's/#unix_sock_group/unix_sock_group/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#unix_sock_rw_perms/unix_sock_rw_perms/g' /etc/libvirt/libvirtd.conf

    usermod -a -G libvirt $(whoami)

    newgrp libvirt << EONG
        systemctl restart libvirtd.service
        modprobe -r kvm_intel
        modprobe kvm_intel nested=1
        echo "options kvm-intel nested=1" | tee /etc/modprobe.d/kvm-intel.conf
EONG
}

function main() {
    install_deps
    set_qemu

    sleep 3

    echo "Done!!"
}

main
