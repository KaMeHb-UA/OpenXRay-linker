FROM debian

ADD AppRun /

ADD .gitignore /
ADD git /

RUN apt update && \
    cd / && \
    /git init && \
    apt install -y libglew2.1 libfreeimage3 libfreeimageplus3 liblockfile1 libopenal1 libtbb2 libcrypto++6 libogg0 libtheora0 libvorbis0a libsdl2-2.0-0 liblzo2-2 libjpeg62-turbo libreadline7 && \
    /git add . && \
    LC_ALL=C /git status | grep "new file:" | cut -c 14-

WORKDIR /

ADD https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage /appimagetool.AppImage

ENTRYPOINT apt update && apt install -y $(/deps) && git diff --name-only --diff-filter=A
