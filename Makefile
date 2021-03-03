#!make

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

WORKDIR=/tmp/archiso-tmp
VERSION=$(shell date +%Y.%m.%d)

PLATFORM=$(PWD)/platform
SCRIPTS=$(PWD)/scripts
OUT=$(PWD)/out

#
# @name: bootstrap
# @desc: Configures the environment.
#
.PHONY: bootstrap

bootstrap:
	sudo $(SCRIPTS)/bootstrap.sh

#
# @name: sync
# @desc: Synchronizes all source code needed for construction.
#
.PHONY: sync

sync:
	repo init -u git@github.com:unaveos/manifest.git -b main && repo sync

#
# @name: build
# @desc: Build ISO for UnaveOS.
#
.PHONY: build

build:
	sudo mkarchiso -v -w $(WORKDIR) -o $(OUT) $(PLATFORM)

#
# @name: clean
# @desc: Clean the work directory.
#
.PHONY: clean

clean:
	sudo rm -rf $(WORKDIR)

#
# @name: run
# @desc: Perform the new build on a VM.
#
.PHONY: run

run:
	run_archiso -i $(OUT)/unaveos-$(VERSION)-x86_64.iso
