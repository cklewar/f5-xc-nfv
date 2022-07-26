data "terraform_remote_state" "step1" {
  backend = "local"
  config  = {
    path = "${path.module}/../state/step1/${terraform.workspace}/terraform.tfstate"
  }
}