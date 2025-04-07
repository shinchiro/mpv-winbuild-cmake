ExternalProject_Add(readline
    DEPENDS
        termcap
    GIT_REPOSITORY https://git.sailfishos.org/mirror/readline.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        ${autoreconf_conf_args}
        --without-curses
        CFLAGS='-DNEED_EXTERN_PC -DS_IFLNK=0120000'
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(readline install)
