#!/bin/bash
sleep 2
su - vgscq -c "\
  export DISPLAY=:0; \
  export XDG_SESSION_TYPE=wayland; \
  export XDG_RUNTIME_DIR=/run/user/1000; \
  export SESSION_MANAGER=local/unix:@/tmp/.ICE-unix/4051,unix/unix:/tmp/.ICE-unix/4051; \
  export XDG_CURRENT_DESKTOP=GNOME; \
  export XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.RCDDK2; \
  scrcpy --turn-screen-off --stay-awake --show-touches --power-off-on-close" | tee /tmp/aaaa

