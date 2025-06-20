.PHONY: install
ifeq ($(OS),Windows_NT)
  EXE=make-$(project_version)/GccRel/gnumake.exe
else
  EXE=make-$(project_version)/make
endif

$(EXE): make-$(project_version)/src/config.h
ifeq ($(OS),Windows_NT)
	sh -c 'cd make-$(project_version) && ./build_w32.bat gcc'
else
	$(MAKE) -C make-$(project_version)
endif

install: make-$(project_version)/src/gnumake.h $(EXE)
ifeq ($(OS),Windows_NT)
	install -Dm644 $< -t $(includedir)
	install -D $(EXE) $(bindir)/make.exe
	rm $(EXE)
else
	DESTDIR=$(prefix) $(MAKE) -C make-$(project_version) install
	rm make-$(project_version)/configure
endif

make-$(project_version)/src/config.h: make-$(project_version)/configure
ifeq ($(OS),Windows_NT)
	install -Dm644 make-$(project_version)/src/config.h.W32 $@
else
	cd make-$(project_version) && ../$^ --disable-dependency-tracking --prefix=/
endif

make-$(project_version)/configure: make-$(project_version).tar.gz
	tar xzf $<

make-$(project_version).tar.gz:
	curl -O https://ftp.gnu.org/gnu/make/$@
