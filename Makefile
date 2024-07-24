# lovergine.com -- Haunted lovergine.com site
# Copyright (C) 2024 Francesco P Lovergine <mbox@lovergine.com>
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

.PHONY: all clean default haunt serve

default: all

all: haunt

clean:
	git clean -fdx

haunt:
	haunt build --config=$(CONFIG)

site/index.html:
	$(MAKE) haunt

serve: site/index.html
	haunt serve --config=$(CONFIG) --watch --port=$(PORT)

publish: site/index.html
	rsync -avzz site/ rivendell.lovergine.com:/var/www/html/.

