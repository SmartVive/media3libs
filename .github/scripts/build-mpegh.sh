#!/bin/bash

echo "Build MPEG-H"

MPEGH_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_mpegh/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_mpegh/build.gradle"


#Fetch libmpegh library:

cd "${MPEGH_MODULE_PATH}/jni"
git clone https://github.com/Fraunhofer-IIS/mpeghdec.git libmpegh

## Enable publishing
echo "
android {
    namespace 'androidx.media3.decoder.mpegh'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-mpegh'
     releaseName = 'Media3 mpegh module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"
