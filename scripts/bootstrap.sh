#! /bin/bash

# Copyright (c) 2021 Romullo @hiukky.

# This file is part of UnaveOS
# (see https://github.com/unaveos).

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


cat >> /etc/pacman.conf <<EOM

[space]
SigLevel = Optional TrustedOnly
Server = https://unaveos.github.io/space/x86_64
EOM

function install_deps() {
    pacman -Syu sudo archiso base-devel --noconfirm
}

function main() {
    install_deps

    sleep 3

    echo "Done!!"
}

main
while(true); do sleep 5; done
