#!/bin/bash
set -eu

FFMPEG_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_ffmpeg/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_ffmpeg/build.gradle"

echo "
android {
    namespace 'androidx.media3.decoder.ffmpeg'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-ffmpeg'
     releaseName = 'Media3 ffmpeg module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"

#cat "${GD_PATH}"

echo "Build FFmpeg"
echo $ANDROID_NDK_HOME
echo $NDK_PATH
ANDROID_ABI=21
HOST_PLATFORM="linux-x86_64"
ENABLED_DECODERS=(vorbis opus flac alac pcm_mulaw pcm_alaw mp3 amrnb amrwb aac ac3 eac3 dca mlp truehd h264 hevc vp8 vp9 mpeg1video mpeg2video mpeg4 msmpeg4v2 msmpeg4v3 av1 mjpeg h263 flv vc1 theora)


echo "NDK path is ${NDK_PATH}"
echo "FFMPEG_MODULE_PATH is ${FFMPEG_MODULE_PATH}"
echo "Host platform is ${HOST_PLATFORM}"
echo "ANDROID_ABI is ${ANDROID_ABI}"
echo "Enabled decoders are ${ENABLED_DECODERS[@]}"


cd "${FFMPEG_MODULE_PATH}/jni"
rm -rf ffmpeg
git clone --depth=1 -b release/6.0  git://source.ffmpeg.org/ffmpeg
cd ffmpeg
FFMPEG_PATH="$(pwd)"
pwd


cd "${FFMPEG_MODULE_PATH}/jni"
rm -rf libyuv
git clone --depth=1 https://github.com/lemenkov/libyuv.git
cd libyuv
YUV_PATH="$(pwd)"
pwd


echo "Run build_ffmpeg.sh"

cd "${FFMPEG_MODULE_PATH}/jni" && \
./build_ffmpeg.sh \
  "${FFMPEG_MODULE_PATH}" "${NDK_PATH}" "${HOST_PLATFORM}" "${ANDROID_ABI}" "${ENABLED_DECODERS[@]}"


echo "Run build_yuv.sh"

cd "${FFMPEG_MODULE_PATH}/jni" && \
./build_yuv.sh \
  "${FFMPEG_MODULE_PATH}" "${NDK_PATH}" "${ANDROID_ABI}"