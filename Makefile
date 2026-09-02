# lovergine.com -- Haunted lovergine.com site
# Copyright (C) 2024-2026 Francesco P Lovergine <mbox@lovergine.com>
#
# lovergine.com is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# lovergine.com is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with lovergine.com.  If not, see <http://www.gnu.org/licenses/>.

SITE:=lovergine
CONFIG:=$(SITE).scm
PORT=8889
$(info CONFIG=$(CONFIG))

.PHONY: all build planet full clean default serve preview

DIRS:=css fonts js images videos

# Never let a HAUNT_MODE inherited from the environment leak into
# serve/publish -- it would point them at a scratch build directory.
unexport HAUNT_MODE

default: all

all: full

# Posts, pages, feeds, tags, static assets -- everything but the planet
# aggregator, which is slow because it fetches external feeds. Builds
# to a scratch dir (haunt wipes its build dir on every run) then merges
# into site/, leaving site/planet/ untouched.
build: | $(DIRS)
	HAUNT_MODE=build haunt build --config=$(CONFIG)
	rsync -a --delete --exclude=planet/ _site-build/ site/
	rm -rf _site-build

# Planet aggregator only (fetches external feeds -- the slow part).
# Builds to a scratch dir then merges just site/planet/, leaving the
# rest of site/ untouched.
planet: | $(DIRS)
	HAUNT_MODE=planet haunt build --config=$(CONFIG)
	rsync -a --delete _site-planet/planet/ site/planet/
	rm -rf _site-planet

# Everything: build + planet, in a single haunt invocation straight to
# site/.
full: | $(DIRS)
	haunt build --config=$(CONFIG)

clean:
	git clean -fdx

site/index.html:
	$(MAKE) full

serve: site/index.html | $(DIRS)
	haunt serve --config=$(CONFIG) --watch --port=$(PORT)

# Fast preview loop for writing: builds and serves posts/pages only
# (no planet), and HAUNT_MODE stays set to `build` for the whole
# `haunt serve` process so watch-triggered rebuilds keep skipping the
# slow planet feed fetches too. Serves its own scratch dir, so it
# never touches site/ -- /planet/ links are unavailable during preview.
preview: | $(DIRS)
	HAUNT_MODE=build haunt build --config=$(CONFIG)
	HAUNT_MODE=build haunt serve --config=$(CONFIG) --watch --port=$(PORT)

publish: full
	rsync -avczz site/ rivendell.lovergine.com:/var/www/html/.

$(DIRS):
	mkdir -p $@
