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
    google = {
      source  = "hashicorp/google"
      version = "3.82.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
  }
}



variable "netlify_token" {}
variable "github_token" {}
locals {
  domain         = "www.tristanschrader.com"
  google_project = "sandbox-293422"
  bucket_name    = "sandbox_main_bucket"
  bucket_objects = try(
    jsondecode(base64decode(data.external.get_bucket_objects.result.base64)),
    []
  )
}



provider "netlify" {
  token = var.netlify_token
}

provider "github" {
  token = var.github_token
  owner = "schradert"
}

provider "google" {
  project = local.google_project
}



data "external" "get_bucket_objects" {
  program = [
    "bash", "${path.module}/tfscript.sh", "get_portfolio_objects"
  ]
}



data "google_iam_policy" "portfolio_admin" {
  binding {
    role = "roles/iam.serviceAccountUser"
    members = [
      "user:schrader.tristan@gmail.com"
    ]
  }
}

data "google_storage_bucket_object" "public_static" {
  for_each = toset(local.bucket_objects)
  name     = each.key
  bucket   = local.bucket_name
}

resource "null_resource" "generate_imgresizer_source" {
  provisioner "local-exec" {
    command = "bash tfscript.sh generate_imgresizer"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "google_storage_bucket_object" "imgresizer_code" {
  name       = "portfolio/functions/imgresizer.zip"
  bucket     = local.bucket_name
  source     = "imgresizer.zip"
  depends_on = [null_resource.generate_imgresizer_source]
}



resource "google_project_iam_member" "portfolio_admin" {
  project = local.google_project
  member  = "serviceAccount:${google_service_account.portfolio_manager.email}"
  role    = "roles/storage.admin"
}

resource "google_service_account" "portfolio_manager" {
  account_id   = "portfolio-manager"
  display_name = "00agent"
}

resource "google_service_account_iam_policy" "portfolio_manager_policy" {
  service_account_id = google_service_account.portfolio_manager.name
  policy_data        = data.google_iam_policy.portfolio_admin.policy_data
}

resource "google_service_account_key" "portfolio_manager_key" {
  service_account_id = google_service_account.portfolio_manager.name
}

data "google_service_account_key" "portfolio_manager_key" {
  name = google_service_account_key.portfolio_manager_key.name
}

resource "google_storage_object_acl" "public_static_acl" {
  for_each = toset(local.bucket_objects)
  bucket   = local.bucket_name
  object   = each.key

  role_entity = [
    "OWNER:user-schrader.tristan@gmail.com",
    "READER:allUsers"
  ]
}

resource "google_project_iam_custom_role" "public_viewer_role" {
  role_id     = "publicViewer"
  title       = "Custom Public Viewership Role"
  description = "Intended for using Objects.list JSON API endpoint"
  permissions = ["storage.objects.list", "storage.objects.getIamPolicy"]
}

resource "google_storage_bucket_iam_member" "public_viewer" {
  bucket = local.bucket_name
  member = "allUsers"
  role   = google_project_iam_custom_role.public_viewer_role.name
}

resource "google_cloudfunctions_function" "imgresizer" {
  name                  = "imgresizer"
  description           = "Resizes images on upload to Cloud Storage to fit normal dimensions needed"
  region                = "us-west2"
  runtime               = "nodejs14"
  available_memory_mb   = 128
  entry_point           = "portfolioImageResizer"
  source_archive_bucket = local.bucket_name
  source_archive_object = google_storage_bucket_object.imgresizer_code.name

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = local.bucket_name
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  cloud_function = google_cloudfunctions_function.imgresizer.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.portfolio_manager.email}"
  region         = "us-west2"
}


resource "github_repository" "repo" {
  name = "me"
}

resource "netlify_deploy_key" "key" {}

resource "netlify_site" "site" {
  name          = "tristanschrader"
  custom_domain = local.domain

  repo {
    command       = "yarn build"
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
  events     = ["delete", "push", "pull_request"]
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

output "cloud_storage_files" {
  value = local.bucket_objects
}

output "service_account_private_key" {
  value     = google_service_account_key.portfolio_manager_key.private_key
  sensitive = true
}
