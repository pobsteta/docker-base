# SIME stack
#
# This image includes the following tools
# - Ubuntu 14.04
#
# Version 1.0

FROM ubuntu:14.04
MAINTAINER Pascal Obstetar <pascal.obstetar@gmail.com>

ADD . /bd_build

RUN /bd_build/prepare.sh && \
    /bd_build/system_services.sh && \
    /bd_build/utilities.sh && \
    /bd_build/cleanup.sh

ENTRYPOINT ["/sbin/my_init", "--"]

