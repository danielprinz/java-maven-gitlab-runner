# :palm_tree: java-maven-gitlab-runner

Uses Gitlab CI Runner from https://gitlab.com/gitlab-org/gitlab-runner/blob/master/dockerfiles/ubuntu/Dockerfile and
extend it with installed:
* Java 8
* Maven 3
* Docker Client

# :wrench: Setup
## Build
`docker build -t danielprinz.github.io/java-maven-gitlab-runner .`

## Run
```
docker run -d --name my-gitlab-runner --restart always \
 -v /srv/my-gitlab-runner/config:/etc/gitlab-runner \
 -v /var/run/docker.sock:/var/run/docker.sock \
 danielprinz.github.io/java-maven-gitlab-runner:latest
```

Note: `/srv/my-gitlab-runner/config/config.toml` file contains all gitlab runner specific settings and will be created on registration.
### Reference
https://docs.gitlab.com/runner/install/docker.html

### Register Gitlab Runner
This is needed for the runner to know the Gitlab instance.  
https://docs.gitlab.com/runner/register/index.html
