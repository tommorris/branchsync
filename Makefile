bin/branchsync:
	crystal build src/branchsync.cr -o bin/branchsync

.PHONY: clean

clean:
	-rm bin/branchsync
