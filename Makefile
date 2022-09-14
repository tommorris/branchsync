.DEFAULT_GOAL: bin/branchsync

bin/branchsync: bin
	crystal build src/branchsync.cr -o bin/branchsync

bin:
	mkdir bin

.PHONY: clean

clean:
	-rm bin/branchsync
