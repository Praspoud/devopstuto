# Define variables
NODE_ENV = offline
NODE_OPTIONS = --openssl-legacy-provider
NETLIFY_AUTH_TOKEN ?= $(shell echo $$NETLIFY_AUTH_TOKEN)
NETLIFY_SITE_ID ?= $(shell echo $$NETLIFY_SITE_ID)
BRANCH_NAME = $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_REF = $(shell git log -1 --pretty=%B)

# Default target
.PHONY: all
all: install build deploy

# Install dependencies
.PHONY: install
install:
	@echo "Installing dependencies..."
	curl -sL https://deb.nodesource.com/setup_16.x | bash -
	sudo apt-get install -y nodejs
	npm ci

# Build assets
.PHONY: build
build:
	@echo "Building assets..."
	NODE_OPTIONS=$(NODE_OPTIONS) CI=false npm run build

# Install Netlify CLI
.PHONY: install-netlify-cli
install-netlify-cli:
	@echo "Installing Netlify CLI..."
	npm install -g netlify-cli

# Deploy to Netlify
.PHONY: deploy
deploy: install-netlify-cli
	@echo "Deploying to Netlify..."
	netlify deploy --prod --dir=./public --message "Prod deploy $(BRANCH_NAME)" --site $(NETLIFY_SITE_ID)

# Clean up
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf node_modules

