# Setting up CloudBuild

1. Create a google project, let's call it github ( using kylin-poc for now until old projects are removed)

2. Fork the project [https://github.com/sleptonium/cicd-demo](https://github.com/sleptonium/cicd-demo) into your user space on github.

Settup  [cloudbuild](https://cloud.google.com/build/docs/automating-builds/github/build-repos-from-github?generation=1st-gen) in the google project.

Use the settings:
gcloud beta builds triggers create github \
    --repo-name=sleptonium/cicd-demo.git \
    --repo-owner=sleptonium \
    --branch-pattern=BRANCH_PATTERN \ # or --tag-pattern=TAG_PATTERN
    --build-config=BUILD_CONFIG_FILE \
    --region=REGION \
    --include-logs-with-status
