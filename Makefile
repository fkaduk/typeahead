.PHONY: test check lint document style demo shell bash clean help

DOCKER_IMAGE := typeahead-test
DOCKER_RUN := docker run --rm -v "$$(pwd):/pkg" $(DOCKER_IMAGE)
SENTINEL := .docker-build

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

$(SENTINEL): Dockerfile DESCRIPTION ## Rebuild image when Dockerfile or deps change
	docker build -t $(DOCKER_IMAGE) .
	@touch $(SENTINEL)

test: $(SENTINEL) ## Run all tests in Docker
	$(DOCKER_RUN) R -e "setwd('/pkg'); devtools::install(); devtools::test()"

check: $(SENTINEL) ## Run R CMD check
	$(DOCKER_RUN) R -e "setwd('/pkg'); devtools::check()"

lint: $(SENTINEL) ## Run lintr on package
	$(DOCKER_RUN) R -e "setwd('/pkg'); lintr::lint_package()"

document: $(SENTINEL) ## Generate documentation with roxygen2
	$(DOCKER_RUN) R -e "setwd('/pkg'); devtools::document()"

style: $(SENTINEL) ## Format code with styler
	$(DOCKER_RUN) R -e "setwd('/pkg'); styler::style_pkg()"

demo: $(SENTINEL) ## Run the demo app in Docker
	docker run --rm -it -p 3838:3838 -v "$$(pwd):/pkg" $(DOCKER_IMAGE) R -e "setwd('/pkg'); devtools::install(); shiny::runApp('inst/examples', port = 3838, host = '0.0.0.0')"

shell: $(SENTINEL) ## Open R shell in Docker container
	docker run --rm -it -v "$$(pwd):/pkg" $(DOCKER_IMAGE) R

bash: $(SENTINEL) ## Open bash shell in Docker container
	docker run --rm -it -v "$$(pwd):/pkg" $(DOCKER_IMAGE) bash

clean: ## Remove Docker image and sentinel
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	@rm -f $(SENTINEL)
