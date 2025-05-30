IMAGE_TAG=gnome-calculator-ubuntu24.04

XSOCK=/tmp/.X11-unix
XAUTH_HOST="${HOME}/.Xauthority"

DOCKER_EXTRA_OPTS="-it \
  -e DISPLAY=${DISPLAY} \
  -e XAUTHORITY=/root/.Xauthority \
  -v ${XSOCK}:${XSOCK} \
  -v ${XAUTH_HOST}:/root/.Xauthority:ro"

# ATTENTION:
# This:

# xhost +local:root

# needs to be executed on the linux host before running the bin
