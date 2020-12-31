include {
  path = find_in_parent_folders()
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan", "destroy"]
    execute      = ["sops", "-d", "-i", "terraform.tfvars.json"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "destroy"]
    execute      = ["sops", "-e", "-i", "terraform.tfvars.json"]
    run_on_error = true
  }
}