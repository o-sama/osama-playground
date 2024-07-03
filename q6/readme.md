You should be able to run `terraform init` and `terraform plan` as the current configuration is, but it will fail on reading the STS caller identity since I've set it up to skip credentials validation and more for the sake of this test.

If you would like to run it properly, please remove the following from `providers.tf` and `iam_config/providers.tf`:
```
skip_credentials_validation = true
skip_requesting_account_id  = true
skip_metadata_api_check     = true
access_key                  = "mock_access_key"
secret_key                  = "mock_secret_key"
```