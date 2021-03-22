clean:
	rm -rf dist/

make-dist:
	[ -d ./dist ] || mkdir ./dist

bomberman: make-dist
	./scripts/wren-build ./src/bomberman/main.wren ./dist/bomberman.wren