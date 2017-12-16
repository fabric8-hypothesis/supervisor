# Dev - Setup and Verification

1. Install and start docker
   ```
    https://docs.docker.com/engine/installation/
   ```

   For CentOS

   ```
    https://docs.docker.com/engine/installation/linux/docker-ce/centos/
   ```
2. Install and start minishift
   ```
    https://docs.openshift.org/latest/minishift/getting-started/installing.html
   ```
   For Fedora and CentOS

   ```
    Note: Use https://fedoramagazine.org/run-openshift-locally-minishift/
   ```
3. Start oc cluster
   ```
   oc cluster up
   ```
4. Fork the repository to your github account
5. Clone your fork and cd into your clone
   ```
    git clone <fork_ssh_clone_url>
    cd supervisor
   ```
6. Create a oc project
   ```
    https://docs.openshift.com/enterprise/3.0/dev_guide/projects.html#create-a-project
   ```
7. Deploy the supervisor app
   ```
    /bin/bash openshift/deploy.sh
   ```

## Important Troubleshooting Links

1. To resetup minishift
   ```
    https://github.com/minishift/minishift/issues/701#issuecomment-292264901
   ```
2. If you are not able to run docker as non-root user, follow:
   ```
    https://github.com/moby/moby/issues/17645#issuecomment-153291483
   ```
3. The oc commands need to run as root so use sudo if current system user is sudo enabled.
4. If docker errors out "docker pull from insecure registry", follow:
   ```
   https://forums.docker.com/t/error-with-docker-pull-from-insecure-registry/31007
   ```