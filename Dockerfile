FROM alpine:3.11 as chktex_builder

ADD http://git.savannah.nongnu.org/cgit/chktex.git/snapshot/chktex-version-1.7.6.tar.gz /

RUN tar -xf chktex-version-1.7.6.tar.gz

WORKDIR /chktex-version-1.7.6/chktex

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

COPY --from=chktex_builder /chktex-version-1.7.6/chktex/chktex /usr/local/bin
