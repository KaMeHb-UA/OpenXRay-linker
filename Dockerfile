FROM debian

ADD AppRun /
ADD git /
ADD install-dummy-pkg /

RUN /install-dummy-pkg dbus x11-common sensible-utils libx11-6 libdbus-1-3 && \
    echo 'for i in $@; do \
        mkdir -p /__LIBS_TMP_DIR__/$(dirname $i); \
        cp -p $i /__LIBS_TMP_DIR__/$i; \
    done' > /install_lib && \
    printf '/var\n/proc\n/tmp\n/sys\n/usr/share\n/etc\n/lib/lsb\n/lib/systemd' > /.gitignore && \
    echo 'echo libglew2.1 libfreeimage3 libfreeimageplus3 liblockfile1 libopenal1 libtbb2 libcrypto++6 libogg0 libtheora0 libvorbis0a libsdl2-2.0-0 liblzo2-2 libjpeg62-turbo libreadline7 libncurses6' > /deps && \
    chmod 755 /install_lib && \
    chmod 755 /deps && \
    cd / && \
    apt update && \
    apt autoremove -y && \
    /git init && \
    /git add . && \
    /git -c user.name='Me' -c user.email='my@email.org' commit -m 'i' > /dev/null && \
    apt install -y $(/deps) --no-upgrade && \
    /git add . && \
    LC_ALL=C /git status | grep "new file:" | cut -c 14- | xargs /install_lib && \
    apt remove -y $(/deps) && \
    apt autoremove -y && \
    rm -rf /var/cache /deps /.git /git /.gitignore /install-dummy-pkg && \
    echo '#!/bin/sh\n\
        cp -rp /__LIBS_TMP_DIR__/* /xray-16/; \
        cd /xray-16; \
        cp ../AppRun .; \
        cp usr/share/applications/openxray.desktop .; \
        cp usr/share/icons/hicolor/64x64/apps/openxray.png .; \
    ' > /install_lib

WORKDIR /

ENTRYPOINT [ "/install_lib" ]
