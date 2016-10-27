FROM ubuntu:16.04
MAINTAINER Pascal Obstetar <pascal.obstetar@obooqo.eu>

ADD . /bd_build

RUN /bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/fix_pam_bug.sh && \
	/bd_build/cleanup.sh

CMD ["/sbin/my_init"]
