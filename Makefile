.PHONY: help update gc switch

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

update: ## Update flake inputs
	nix flake update

gc: ## Run garbage collection (keep last 5 generations, clean older than 7d)
	sudo nix-collect-garbage --delete-older-than 7d

switch: ## Rebuild and switch to new NixOS configuration
	sudo nixos-rebuild switch --flake .
