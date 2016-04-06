TEMPLATE = app
TARGET = sandcoins-qt
VERSION = 2.0.1.0
INCLUDEPATH += src src/json src/qt
QT += core gui network widgets qml quick
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE USE_IPV6 __NO_SYSTEM_INCLUDES
CONFIG += no_include_pwd
CONFIG += thread
CONFIG += static

BOOST_LIB_SUFFIX=-mgw49-mt-s-1_55
BOOST_THREAD_LIB_SUFFIX=$$BOOST_LIB_SUFFIX
BOOST_INCLUDE_PATH=C:/deps/boost_1_55_0
BOOST_LIB_PATH=C:/deps/boost_1_55_0/stage/lib
BDB_INCLUDE_PATH=C:/deps/db-4.8.30.NC/build_unix
BDB_LIB_PATH=C:/deps/db-4.8.30.NC/build_unix
BDB_LIB_SUFFIX=-4.8
OPENSSL_INCLUDE_PATH=C:/deps/openssl-1.0.2d/include
OPENSSL_LIB_PATH=C:/deps/openssl-1.0.2d
MINIUPNPC_INCLUDE_PATH=C:/deps/
MINIUPNPC_LIB_PATH=C:/deps/miniupnpc
QRENCODE_INCLUDE_PATH=C:/deps/qrencode-3.4.3
QRENCODE_LIB_PATH=C:/deps/qrencode-3.4.3/.libs

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
QMAKE_CXXFLAGS *= -fstack-protector-all
QMAKE_LFLAGS *= -fstack-protector-all
# Exclude on Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
# This can be enabled for Windows, when we switch to MinGW >= 4.4.x.

# for extra security (see: https://wiki.debian.org/Hardening): this flag is GCC compiler-specific
QMAKE_CXXFLAGS *= -D_FORTIFY_SOURCE=2
# for extra security on Windows: enable ASLR and DEP via GCC linker flags
QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat
# on Windows: enable GCC large address aware linker flag
QMAKE_LFLAGS *= -Wl,--large-address-aware
# i686-w64-mingw32
QMAKE_LFLAGS *= -static-libgcc -static-libstdc++

# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    #LIBS += -lqrencode
    LIBS += -lqrencode $$join(QRENCODE_LIB_PATH,,-L,)
}

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP STATICLIB
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1"
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

INCLUDEPATH += src/leveldb/include src/leveldb/helpers
LIBS += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a
# make an educated guess about what the ranlib command is called
isEmpty(QMAKE_RANLIB) {
   QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
}
LIBS += -lshlwapi
genleveldb.target = $$PWD/src/leveldb/libleveldb.a
genleveldb.depends = FORCE
PRE_TARGETDEPS += $$PWD/src/leveldb/libleveldb.a
QMAKE_EXTRA_TARGETS += genleveldb
# Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
# On windows manually execute: make TARGET_OS=OS_WINDOWS_CROSSCOMPILE libleveldb.a libmemenv.a
QMAKE_CLEAN += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a;

# regenerate src/build.h
contains(USE_BUILD_INFO, 1) {
    genbuild.depends = FORCE
    genbuild.commands = cd $$PWD; /bin/sh share/genbuild.sh $$OUT_PWD/build/build.h
    genbuild.target = $$OUT_PWD/build/build.h
    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
    QMAKE_EXTRA_TARGETS += genbuild
    DEFINES += HAVE_BUILD_INFO
}

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wformat -Wformat-security -Wno-unused-parameter -Wno-strict-aliasing -Wstack-protector

QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-local-typedefs -Wno-maybe-uninitialized

##### Include Project Files #####

include(csc-sources.pri)

##### Include Project Files #####

contains(USE_QRCODE, 1) {
   HEADERS += src/qt/qrcodedialog.h
   SOURCES += src/qt/qrcodedialog.cpp
   FORMS += src/qt/forms/qrcodedialog.ui
}

contains(BITCOIN_QT_TEST, 1) {
   SOURCES += src/qt/test/test_main.cpp \
      src/qt/test/uritests.cpp
   HEADERS += src/qt/test/uritests.h
   DEPENDPATH += src/qt/test
   QT += testlib
   TARGET = casinocoin-qt_test
   DEFINES += BITCOIN_QT_TEST
}

contains(USE_SSE2, 1) {
   DEFINES += USE_SSE2
   gccsse2.input  = SOURCES_SSE2
   gccsse2.output = $$PWD/build/${QMAKE_FILE_BASE}.o
   gccsse2.commands = $(CXX) -c $(CXXFLAGS) $(INCPATH) -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME} -msse2 -mstackrealign
   QMAKE_EXTRA_COMPILERS += gccsse2
   SOURCES_SSE2 += src/scrypt-sse2.cpp
}

# for lrelease/lupdate
# also add new translations to src/qt/bitcoin.qrc under translations/
TRANSLATIONS = $$files(src/qt/locale/bitcoin_*.ts)

isEmpty(QMAKE_LRELEASE) {
   QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
}

isEmpty(QM_DIR):QM_DIR = $$PWD/src/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    BOOST_LIB_SUFFIX = -mgw46-mt-s-1_53
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

DEFINES += WIN32
RC_FILE = src/qt/res/bitcoin-qt.rc

!contains(MINGW_THREAD_BUGFIX, 0) {
   # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
   # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
   # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
   # it is prepended to QMAKE_LIBS_QT_ENTRY.
   # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
   # any problems on some untested qmake profile now or in the future.
   DEFINES += _MT
   QMAKE_LIBS_QT_ENTRY = -lmingwthrd $$QMAKE_LIBS_QT_ENTRY
}

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX -lpthread
# -lgdi32 has to happen after -lcrypto (see  #681)
LIBS += -lws2_32 -lole32 -lmswsock -loleaut32 -luuid -lgdi32 -lshlwapi
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX
LIBS += -lboost_chrono$$BOOST_LIB_SUFFIX

system($$QMAKE_LRELEASE -silent $$TRANSLATIONS)
