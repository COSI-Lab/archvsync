bindir = /usr/bin
docdir = /usr/share/doc/ftpsync
examplesdir = ${docdir}/examples

SCRIPTS = bin/ftpsync bin/ftpsync-cron bin/rsync-ssl-tunnel bin/runmirrors

all: $(SCRIPTS:%=%.install)

bin/%.install: bin/% bin/common
	sed -r \
		-e '\#^\. .*/common"# {' -e 'r bin/common' -e 'd' -e '};' \
		-e 's/^(BASE|BIN|CONF|LOCK|LOG)DIR=.*$$/\1DIR=/;' \
		-e 's/^VERSION=.*$$/VERSION="${DEB_VERSION}"/;' \
		$^ > $@

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir}
	install bin/ftpsync.install ${DESTDIR}/${bindir}/ftpsync
	install bin/ftpsync-cron.install ${DESTDIR}/${bindir}/ftpsync-cron
	install bin/rsync-ssl-tunnel.install ${DESTDIR}/${bindir}/rsync-ssl-tunnel
	install bin/runmirrors.install ${DESTDIR}/${bindir}/runmirrors
	install -m644 \
		README.md \
		${DESTDIR}/${docdir}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}

clean:
	rm -f $(SCRIPTS:%=%.install)
