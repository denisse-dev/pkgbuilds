.PHONY: help check build install srcinfo update-checksums update-pkg publish
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check: ## check PKGBUILDs for common packaging mistakes.
	namcap $(pkg)/PKGBUILD

build: ## build the PKGBUILD
	cd $(pkg) && \
	makepkg --clean --syncdeps -f && \
	echo "Done!"

install: ## install the package after building it
	cd $(pkg) && \
	makepkg --install

srcinfo: ## print SRCINFO into a file
	cd $(pkg) && \
	makepkg --printsrcinfo > .SRCINFO && \
	echo "Done!"

update-checksums: ## update PKGBUILD checksums
	updpkgsums $(pkg)/PKGBUILD

update-pkg: check update-checksums build srcinfo ## update the and upload the package to the AUR

publish: ## publish the PKGBUILD to the AUR
	aurpublish $(pkg)
