# 1. Workspace Setup & Navigation
# Create parent course directory and Module 1 subdirectory
# mkdir -p ~/iac-course/module-01
# Navigate to the Module ## directory. Open the directory in the VS Code explorer pane:
# cd ~/iac-course
# code . -r
# Navigate into specific assignment module:
cd ~/module-02
# Create the four core Terraform files for Module (add 'locals.tf' too).
touch providers.tf variables.tf main.tf outputs.tf
# 2. Authentication
# Log in to Azure using the device-code flow (for SSH environments; subscr-id in terraform.tfvars).
az login --tenant 6980af2f-acfc-4513-ac50-552bcfdb01a0 --use-device-code 


# 3. The Core Terraform Workflow
# Execute sequence below for every ASSIGNMENT lifecycle.

# Step 1: Initialize
# Downloads the required provider plugins (e.g., AzureRM) into working directory.
terraform init

# Step 2: Format
# Automatically rewrites Terraform configuration files to a canonical format and style.
terraform fmt

# Step 3: Validate
# Checks the configuration files for syntax errors and internal consistency.
terraform validate

# Step 4: Plan
# Calculates and displays the execution plan without applying the changes to Azure.
terraform plan

# Step 5: Apply
# Executes the API calls to Azure to provision the infrastructure. (Requires typing 'yes').
terraform apply --auto-approve


# 4. Inspecting the State
# Verify what Terraform has built and currently tracks.

# List all tracked resources:
terraform state list

# Show details of a specific resource in Terraform state (using name from main.tf):
terraform state show azurerm_resource_group.rg

# Verify the resource directly via Azure CLI (outside of Terraform):
az group show --name ss963-mod04-rg --output table


# 5. Cleanup
# Remove all resources to prevent costs and maintain a clean environment.

# Destroy infrastructure:
# Executes the API calls to delete all resources defined in the current directory's state file.
terraform destroy --auto-approve


# From Module 6 (backend konfigureres før Terraform har lest variabler, moduler eller state; 
# derfor må verdiene komme utenfra, via -backend-config.):
terraform init \
   -backend-config=backend.hcl \
   -backend-config="key=dev/network.tfstate" \
   -migrate-state
   (-reconfigure)
# Migrering fra lokal til remote state
Når backend-blokken legges til et prosjekt som allerede har lokal tfstate-fil, må Terraform få beskjed om at den eksisterende staten skal flyttes opp i backenden. (Etter migrering kan lokal terraform.tfstate slettes – sannheten ligger nå i Azure.)
# Terraform husker den forrige backend-konfigurasjonen i .terraform/. Uten -reconfigure flagget vil den enten klage eller tilby å migrere dev-staten over til f.eks. prod-nøkkelen (som vi ikke ønsker).
terraform apply -var-file="dev.tfvars"