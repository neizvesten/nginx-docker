FROM debian:buster-20200908

WORKDIR /tmp

RUN apt update && \
    apt install -y dh-make quilt lsb-release debhelper dpkg-dev dh-systemd \
                   build-essential autoconf automake pkg-config libtool \
                   libpcre++-dev zlib1g-dev libssl-dev wget

RUN wget https://nginx.org/download/nginx-1.19.2.tar.gz -O nginx.tar.gz && \
    tar -xzf nginx.tar.gz && \
    rm nginx.tar.gz

WORKDIR /tmp/nginx-1.19.2

RUN wget http://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/nginx_1.19.2-1~buster.debian.tar.xz -O nginx.deb.tar.xz && \
    tar -xJf nginx.deb.tar.xz && \
    rm nginx.deb.tar.xz

COPY nginx.conf /tmp/nginx-1.19.2/debian/nginx.conf

COPY rules /tmp/nginx-1.19.2/debian/rules

ENV LOGNAME root

RUN dh_make -y -s --copyright gpl -s -p nginx_1.19.2 --createorig || true && \
    find /tmp/nginx* && \
    dpkg-buildpackage -us -uc


FROM debian:buster-20200908

COPY --from=0 /tmp/nginx_1.19.2-1~buster_amd64.deb /root/

RUN apt update && \
    apt install -y libssl1.1 lsb-base

RUN dpkg -i /root/nginx_1.19.2-1~buster_amd64.deb || true

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
