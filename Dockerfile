FROM debian:latest
MAINTAINER Jesse White <anonymuse@gmail.com>

RUN    apt-get update && apt-get install -y \
    gnupg \
    --no-install-recommends \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 \
    && echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list \
    && echo "deb http://ftp.de.debian.org/debian jessie main " >> /etc/apt/sources.list.d/workaround.list \
    && apt-get update && apt-get install -y \
    alsa-utils \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpangoxft-1.0-0 \
    libssl1.0.0 \
    libssl1.0.2 \
    libxss1 \
    spotify-client \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /home/spotify
ENV USER spotify
RUN useradd --create-home --home-dir $HOME $USER \
    && gpasswd -a $USER audio \
    && chown -R $USER:$USER $HOME

WORKDIR $HOME
USER $USER

# make search bar text better
RUN echo "QLineEdit { color: #000 }" > /home/spotify/spotify-override.css

ENTRYPOINT    [ "spotify" ]
CMD [ "-stylesheet=/home/spotify/spotify-override.css" ]

