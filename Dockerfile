#
# Copyright © 2020 Maestro Creativescape
#
# SPDX-License-Identifier: GPL-3.0
#
# Docker Image Builder for building the latest windows ISO

FROM baalajimaestro/uup_dumper:latest

COPY . /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'