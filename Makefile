#!make

# Copyright (c) 2021 Romullo @hiukky.

# This file is part of FlateOS
# (see https://github.com/flateos).

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

include .env

WORKDIR=/tmp/archiso-tmp
SCRITPS=$(PWD)/scripts
SPACE=$(PWD)/space
DIST=$(PWD)/$(OUT)

export

# @name: exec
# @desc: Executes a command in the defined environment.
define exec
    [[ $(USE_DOCKER) == true ]] && docker exec -it $(NAME) $(1) || /bin/bash -c $(1)
endef

# @name: get_manifest_url
# @desc: Obtains project URL for the specified protocol.
define get_manifest_url
    $(shell [[ $(USE_SSH) == true ]] && echo "git@github.com:flateos/manifest.git" || echo "https://github.com/flateos/manifest.git")
endef

# @name: sync
# @desc: Synchronizes all source code needed for construction.
.PHONY: sync
sync:
	repo init -u $(call get_manifest_url) -b main && repo sync

# @name: build
# @desc: Build ISO for FlateOS.
.PHONY: build
build:
	@$(call exec, sudo mkarchiso -v -w $(WORKDIR) -o $(DIST) $(PWD)/platform)

# @name: clean
# @desc: Clean the work directory.
.PHONY: clean
clean:
	@$(call exec, sudo rm -rf $(WORKDIR))

# @name: run
# @desc: Perform the new build on a VM.
.PHONY: run
run:
	@$(call exec, sudo run_archiso -i $(DIST)/$(NAME)-$(VERSION)-x86_64.iso)

# @name: space
# @desc: Compile and update local packages.
.PHONY: space
space:
	@$(call exec, $(SCRITPS)/space.sh)
