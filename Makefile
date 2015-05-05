include /lib/modules/$(shell uname -r)/build/.config

ifeq ($(CONFIG_MODULE_SIG_ALL),y)
MODSECKEY = /lib/modules/$(shell uname -r)/build/signing_key.priv
MODPUBKEY = /lib/modules/$(shell uname -r)/build/signing_key.x509
mod_sign_cmd = perl /lib/modules/$(shell uname -r)/build/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
else
mod_sign_cmd = true
endif

export mod_sign_cmd

all: modules sign_modules

.PHONY: sign_modules
sign_modules:
	@set -e ; if [ -f $(MODPUBKEY) -a -f $(MODSECKEY) ]		;\
		then							\
		echo "  [SIGN] *.ko"					;\
		$(mod_sign_cmd) *.ko					;\
	fi

.PHONY: modules
modules:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

.PHONY: clean
clean:
	make -C /lib/modules/$(shell uname -r)/build clean M=$(PWD)

obj-m += test.o
