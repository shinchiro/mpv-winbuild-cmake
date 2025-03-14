ExternalProject_Add(lzo
    URL "https://fossies.org/linux/misc/lzo-2.10.tar.gz"
    URL_HASH SHA1=4924676a9bae5db58ef129dc1cebce3baa3c4b5d
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ""
    COMMAND ${EXEC} sed -i [['/^lzo_add_executable.*$/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/install.*examples/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/testmini/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} sed -i [['/install.*CMAKE_INSTALL_FULL_DOCDIR/d']] <SOURCE_DIR>/CMakeLists.txt
    COMMAND ${EXEC} CONF=1 ${CMAKE_COMMAND} -H<SOURCE_DIR> -B<BINARY_DIR>
        ${cmake_conf_args}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ${CMAKE_COMMAND} --install <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(lzo install)
