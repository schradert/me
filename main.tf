terraform {
  required_providers {
    netlify = {
      source  = "Fantom-App/netlify"
      version = "0.7.10"
    }
    github = {
      source  = "integrations/github"
      version = "4.14.0"
    }
  }
}



variable "netlify_token" {}
variable "github_token" {}
locals {
  domain = "www.tristanschrader.com"
}



provider "netlify" {
  token = var.netlify_token
}

provider "github" {
  token = var.github_token
  owner = "schradert"
}



resource "github_repository" "repo" {
  name = "me"
}

resource "netlify_deploy_key" "key" {}

resource "netlify_site" "site" {
  name          = "tristanschrader"
  custom_domain = local.domain

  repo {
    command       = "npm run build"
    deploy_key_id = netlify_deploy_key.key.id
    dir           = "public"
    provider      = "github"
    repo_path     = github_repository.repo.full_name
    repo_branch   = "prod"
  }
}

resource "github_repository_deploy_key" "key" {
  title      = "netlify"
  repository = github_repository.repo.name
  key        = netlify_deploy_key.key.public_key
  read_only  = false
}

resource "github_repository_webhook" "prod" {
  repository = github_repository.repo.name
  events     = ["push"]
  configuration {
    url          = "https://api.netlify.com/hooks/github"
    content_type = "json"
  }
}



output "netlify" {
  value = netlify_site.site
}

output "push_webhook" {
  value     = github_repository_webhook.prod
  sensitive = true
}