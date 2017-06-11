FUNCTION_NAME = bad_default
LAMBDA_ROLE = arn:aws:iam::933124498034:role/service-role/lambda_basic_role

install: virtual
build: clean_package build_package_function copy_python remove_unused zip
deploy: lambda_delete lambda_create

virtual:
	@echo "--> Setup and activate virtualenv"
	if test ! -d "env"; then \
		conda install virtualenv; \
		virtualenv env; \
	fi
	@echo ""

clean_package:
	rm -rf ./package/$(FUNCTION_NAME)/*

build_package_function:
	mkdir -p ./package/$(FUNCTION_NAME)/lib
	cp -a ./app/$(FUNCTION_NAME)/. ./package/$(FUNCTION_NAME)/
	cp -a ./config/. ./package/$(FUNCTION_NAME)/config/

copy_python:
	if test -d env/lib; then \
		cp -a env/lib/python2.7/site-packages/. ./package/$(FUNCTION_NAME)/; \
	fi
	if test -d env/lib64; then \
		cp -a env/lib64/python2.7/site-packages/. ./package/$(FUNCTION_NAME)/; \
	fi

remove_unused:
	rm -rf ./package/$(FUNCTION_NAME)/wheel*
	rm -rf ./package/$(FUNCTION_NAME)/easy-install*
	rm -rf ./package/$(FUNCTION_NAME)/setuptools*

zip:
	cd ./package/$(FUNCTION_NAME) && zip -r ../$(FUNCTION_NAME).zip .

lambda_delete:
	aws lambda delete-function \
		--function-name $(FUNCTION_NAME)

lambda_create:
	aws lambda create-function \
		--function-name $(FUNCTION_NAME) \
		--zip-file fileb://./package/$(FUNCTION_NAME).zip \
		--role $(LAMBDA_ROLE) \
		--handler main.main \
		--runtime python2.7 \
		--timeout 15 \
		--memory-size 128
