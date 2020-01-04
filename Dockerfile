FROM alpine:3.11 as chktex_builder

ADD http://git.savannah.nongnu.org/cgit/chktex.git/snapshot/chktex-127e9ea31f80e6738d137e8a5022cbb2ab601f4c.tar.gz /

RUN tar -xf chktex-127e9ea31f80e6738d137e8a5022cbb2ab601f4c.tar.gz

RUN mv chktex-127e9ea31f80e6738d137e8a5022cbb2ab601f4c chktex

WORKDIR /chktex/chktex

RUN apk --no-cache add automake autoconf make gcc g++

RUN ./autogen.sh
RUN ./configure
RUN make

FROM alpine:3.11

RUN apk --no-cache add \
    texlive \
    texmf-dist-langjapanese \
    texmf-dist-bibtexextra \
    texmf-dist-science \
    texmf-dist-fontsextra

COPY --from=chktex_builder /chktex/chktex/chktex /usr/local/bin
COPY --from=chktex_builder /chktex/chktex/chktexrc /usr/local/etc/chktexrc
