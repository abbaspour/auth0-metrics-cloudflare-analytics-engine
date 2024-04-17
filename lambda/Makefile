bundle=lambda.zip

lambda: $(bundle)

%.zip: src/index.js node_modules
	zip -qr $(bundle) src node_modules/
	@echo "files list:"
	@unzip -t $(bundle) |  grep -v node_modules

node_modules: package.json package-lock.json
	npm ci

package-lock.json:
	npm i
