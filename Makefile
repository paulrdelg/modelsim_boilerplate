
ifeq ($(OS),Windows_NT)
	include scripts/win_bash.make
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		include scripts/linux.make
	endif
endif
