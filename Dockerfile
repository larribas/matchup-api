# Based on shufo/phoenix (https://hub.docker.com/r/shufo/phoenix/~/dockerfile/)

FROM alpine:latest
MAINTAINER Lorenzo Arribas <larribas>

ENV ELIXIR_VERSION 1.2.5
ENV HOME /root

# Install Erlang/Elixir
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk --update --no-cache add ncurses-libs git make g++ wget python ca-certificates openssl \
                     erlang erlang-dev erlang-kernel erlang-hipe erlang-compiler \
                     erlang-stdlib erlang-erts erlang-tools erlang-syntax-tools erlang-sasl \
                     erlang-crypto erlang-public-key erlang-ssl erlang-ssh erlang-asn1 erlang-inets \
                     erlang-inets erlang-mnesia erlang-odbc erlang-xmerl \
                     erlang-erl-interface erlang-parsetools erlang-eunit && \
    update-ca-certificates --fresh && \
    wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    mkdir -p /opt/elixir-${ELIXIR_VERSION}/ && \
    unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ && \
    rm Precompiled.zip && \
    rm -rf /var/cache/apk/*

# Add elixir executables to path
ENV PATH $PATH:/opt/elixir-${ELIXIR_VERSION}/bin

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

# Add project code and set it up
WORKDIR /app
ADD . /app
RUN mix deps.get

EXPOSE 4000

CMD ["sh", "-c", "mix deps.get && mix phoenix.server"]