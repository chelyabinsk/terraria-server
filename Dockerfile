FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive \
    TERRARIA_VERSION=1449 \
    USER=terraria \
    HOME=/home/terraria

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        lib32gcc-s1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d "$HOME" -s /bin/bash "$USER" && \
    mkdir -p "$HOME/.local/share/Terraria/Worlds" && \
    chown -R "$USER:$USER" "$HOME/.local"

WORKDIR /opt/terraria

RUN wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip -O terraria-server.zip && \
    unzip terraria-server.zip -d server && \
    mv server/*/Linux/* ./ && \
    rm -rf terraria-server.zip server

COPY --chown=terraria:terraria serverconfig.txt .
COPY --chown=terraria:terraria start.sh .
COPY --chown=terraria:terraria Worlds/ ./Worlds/

RUN chmod +x start.sh TerrariaServer.bin.x86_64

USER "$USER"

EXPOSE 7777

HEALTHCHECK --interval=30s --timeout=5s \
  CMD pgrep TerrariaServer.bin.x86_64 || exit 1

ENTRYPOINT ["./start.sh"]

