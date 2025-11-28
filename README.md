# Terraform lab - GCP (tf_lab-1)

This repository is a simple Terraform project for Google Cloud Platform (GCP).
It contains a minimal configuration that creates:

- a Google VPC network
- a Google Cloud Storage (GCS) bucket

The repository also uses a GCS backend for storing Terraform state and includes
a `.gitlab-ci.yml` file that demonstrates how to run the Terraform lifecycle
from GitLab CI.

---

## Files

- `provider.tf` - Terraform backend and provider configuration (GCP provider
  pinned to `hashicorp/google` version `6.8.0`).
- `main.tf` - Two resources: `google_compute_network` and `google_storage_bucket`.
- `variables.tf` - All configurable variables with sensible defaults.
- `.gitlab-ci.yml` - GitLab CI pipeline with stages `tf_setup`, `tf_check`,
  `tf_execution`, and `tf_cleanup`.

---

## What this project creates

- Network: `google_compute_network.vpc_network` named by variable `vpc_name`.
- Storage: `google_storage_bucket.static` named by variable `bucket_name`.
* Note: The GCS backend (used by Terraform for state) is external and must
  be present before Terraform runs. The backend is configured to use the
  `ocp-on-gcp-476018-tfstate` bucket with prefix `tfstate/`.
  The GitLab CI pipeline includes a job that will attempt to create the
  backend bucket (if it doesn't exist) before `terraform init` runs.

---

## Requirements

- Terraform (recommended: pin a specific `required_version` — add `required_version`
  to `provider.tf` if needed)
- Google Cloud SDK (gcloud)
- A GCP service account JSON key with permissions to:
  - Manage storage (e.g., `roles/storage.admin`)
  - Manage networks (e.g., `roles/compute.networkAdmin`)
  - Access and update the backend bucket

---

## How to run locally

1) Configure credentials — either set `GOOGLE_APPLICATION_CREDENTIALS` or use
   the `gcloud` SDK to auth:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-sa.json"
# Or if you prefer gcloud's active credentials
# gcloud auth activate-service-account --key-file /path/to/your-sa.json
```

2) Initialize Terraform (backend bucket must already exist):

```bash
cd /path/to/tf_lab-1
terraform init -backend=true
```

3) Validate and plan:

```bash
terraform validate
terraform plan -out plan.tfplan
```

4) Apply (creates resources):

```bash
terraform apply plan.tfplan
```

5) Destroy (optional):

```bash
terraform destroy -auto-approve
```

---

## GitLab CI

The included `.gitlab-ci.yml` contains the following jobs:

- `initialize_backend` — runs `terraform init -backend=true`.
- `validate_syntax` — runs `terraform validate`.
- `create_plan` — runs `terraform plan` and stores `plan.tfplan` as an artifact.
- `deploy_infrastructure` — runs `terraform apply -auto-approve plan.tfplan`.
- `destroy_resources` — runs `terraform destroy -auto-approve` (manual action).

Important CI variables and runner requirements:

- `GCP_SA_KEY_FILE` — a GitLab CI variable that contains the contents of the
  service account JSON key (the pipeline writes this to `/tmp/gcp-sa-key.json`).
  Ensure this variable is marked as "masked" and "protected" in GitLab.
- The runner must have `gcloud` and `terraform` installed.

Security note: consider using Workload Identity or other short-lived credentials
instead of storing a long-lived JSON key in the CI variables.

---

## Recommendations / Best Practices

- GitLab pipeline: The CI will try to create the backend bucket if missing.
  Ensure the service account used by CI has `roles/storage.admin` (or
  equivalent) so it can create the bucket and set uniform access.
  If you prefer not to let the pipeline create the bucket, create it manually
  or enforce a policy that restricts who can create backend buckets.

- Add `required_version` to `terraform {}` in `provider.tf` to avoid version
  mismatches in CI and local environments (example: `required_version = "~> 1.3"`).

- Add outputs for commonly-used values (VPC `name`, bucket `url`, etc.) to make
  it easier for other modules or tooling to consume the created resources.

- Use least-privilege IAM roles and secure the service account key used by CI.
  Better: use Workload Identity or ephemeral credentials where possible.

- Consider creating a separate Terraform config or pipeline job to create the
  backend bucket if you intend to manage the backend bucket as part of CI.

---

## Example Variables Overrides (optional)

You can override the defaults using a Terraform `tfvars` file or environment
variables as documented in Terraform's docs. Example `terraform.tfvars`:

```hcl
project = "my-gcp-project-id"
region  = "europe-west9"
zone    = "europe-west9-a"
vpc_name = "my-custom-vpc"
bucket_name = "my-custom-bucket-12345"
```

---

## Helpful commands

```bash
# Show terraform version
terraform version

# Plan and see changes
terraform plan

# Show created resources after apply
terraform show
```

---

If you'd like, I can also:

- Add `outputs` for the created resources,
- Add `required_version` in `provider.tf`,
- Add a CI job to check and create the backend bucket (or a script to test
  whether the backend exists before `terraform init`).

If you want any of the above changes, let me know and I'll add them.
