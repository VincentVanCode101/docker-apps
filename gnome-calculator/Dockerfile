FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    gnome-calculator \
    libgtk-4-1 libglib2.0-0 pulseaudio-utils \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["gnome-calculator"]
