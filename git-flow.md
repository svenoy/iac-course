# ==========================================
# 1. Initial Git Configuration (ONE-TIME VM setup)
# ==========================================

# Set display name for local commit history.
# Concept: Associates your chosen identifier with your saved file changes.
git config --global user.name "svenoy"

# Set email for local commit history.
# Concept: Links your VM file changes to your GitHub account credentials.
git config --global user.email "stig.svenoy@vegvesen.no"


# ==========================================
# 2. Managing the Instructor's Repository (DONE)
# ==========================================

# Download the instructor's repository to a parallel folder.
# Concept: Executes a 'clone' to copy the remote files to your local VM.
git clone https://github.com/torivarm/iac-terraform.git ~/iac-terraform

# Update the instructor's repository.
# Concept: Executes a 'pull' to fetch any new assignment files the instructor adds later. 
# Assumption: You must navigate into the instructor's folder first.
cd ~/iac-terraform
git pull


# ==========================================
# 3. Initializing Your Personal Repository (ONE-TIME setup)
# ==========================================

# Initialize Git tracking in your primary course folder.
# Concept: Creates a hidden .git database to monitor file changes in this directory.
cd ~/iac-course
git init -b main

# Link the local folder to your remote GitHub repository.
# Concept: Establishes 'origin' as the web URL where your pushes will be sent.
git remote add origin https://github.com/svenoy/iac-course.git


# ==========================================
# 4. Standard Daily Workflow (Saving & Uploading)
# ==========================================

# Step 1: Copy a full assignment module from the instructor's repo.
# Concept: The -r flag recursively copies the directory and all its contents.
cp -r ~/iac-terraform/module-02 ~/iac-course/

# Step 2: Navigate to your workspace.
cd ~/iac-course

# Step 3: Stage the specific folder you are working on.
# Concept: Moves all files within 'module-02' into the staging area.
git add module-02/

# Step 4: Commit the changes locally.
# Concept: Creates a permanent local save point with a descriptive message.
git commit -m "Add module-02 assignment files"

# Step 5: Push to GitHub.
# Concept: Uploads your local commits to the remote 'main' branch on GitHub.
git push -u origin main


# ==========================================
# 5. File Backup Utility
# ==========================================

# Create a manual backup of a critical reference file outside the tracked repository.
# Concept: The 'cp' command copies the source file to a new destination, appending '.bak' as a standard naming convention for backups.
cp ~/iac-course/README.md ~/README.md.bak