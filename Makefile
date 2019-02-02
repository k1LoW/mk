PKG = github.com/k1LoW/mk
COMMIT = $$(git describe --tags --always)
OSNAME=${shell uname -s}
ifeq ($(OSNAME),Darwin)
	DATE = $$(gdate --utc '+%Y-%m-%d_%H:%M:%S')
else
	DATE = $$(date --utc '+%Y-%m-%d_%H:%M:%S')
endif

BUILD_LDFLAGS = -X $(PKG).commit=$(COMMIT) -X $(PKG).date=$(DATE)
RELEASE_BUILD_LDFLAGS = -s -w $(BUILD_LDFLAGS)

GO ?= GO111MODULE=on go

build:
	$(GO) build -ldflags="$(BUILD_LDFLAGS)"

depsdev:
	GO111MODULE=off go get golang.org/x/lint/golint
	GO111MODULE=off go get github.com/motemen/gobump/cmd/gobump
	GO111MODULE=off go get github.com/Songmu/goxz/cmd/goxz
	GO111MODULE=off go get github.com/tcnksm/ghr
	GO111MODULE=off go get github.com/Songmu/ghch/cmd/ghch

crossbuild: depsdev
	$(eval ver = v$(shell gobump show -r))
	GO111MODULE=on goxz -pv=$(ver) -os=linux,darwin -arch=386,amd64 -build-ldflags="$(RELEASE_BUILD_LDFLAGS)" \
	  -d=./dist/$(ver)

prerelease:
	$(eval ver = v$(shell gobump show -r))
	ghch -w -N ${ver}

release:
	$(eval ver = v$(shell gobump show -r))
	ghr -username k1LoW -replace ${ver} dist/${ver}
