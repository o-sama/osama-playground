module "staging" {
  source = "./iam_config"
  
  env = "staging"
  resource_prefix = "dolphin"
  tags = {
    service = "dolphin"
    cost-center = "engineering"
  }
}

module "production" {
  source = "./iam_config"
  
  env = "production"
  resource_prefix = "dolphin"
  tags = {
    service = "dolphin"
    cost-center = "engineering"
  }
}