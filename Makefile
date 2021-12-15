.PHONY: help check-pkg update-checksums build-pkg install-pkg update-srcinfo update-pkg publish
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check-pkg: ## check PKGBUILDs for common packaging mistakes.
	namcap $(pkg)/PKGBUILD && \
	echo "Done checking the package"

update-checksums: ## update PKGBUILD checksums
	updpkgsums $(pkg)/PKGBUILD && \
	echo "Done updating checksums"

build-pkg: ## build the PKGBUILD
	cd $(pkg) && \
	makepkg --clean --syncdeps -f && \
	echo "Done building the PKGBUILD"

install-pkg: ## install the package after building it
	cd $(pkg) && \
	makepkg --install && \
	echo "Done installing the package"

update-srcinfo: ## print SRCINFO into a file
	cd $(pkg) && \
	makepkg --printsrcinfo > .SRCINFO && \
	echo "Done updating the .SRCINFO"

update-pkg: check-pkg update-checksums build-pkg install-pkg update-srcinfo ## update and upload the package to the AUR

publish: ## publish the PKGBUILD to the AUR
	aurpublish $(pkg)
