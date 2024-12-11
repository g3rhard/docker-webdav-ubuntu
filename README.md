# docker-webdav-ubuntu

> Docker image with Apache for WebDav with LDAP support (WIP)

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/g3rhard/docker-webdav-ubuntu/build.yml?branch=production&style=for-the-badge&logo=github&color=333333)](https://github.com/g3rhard/docker-webdav-ubuntu/actions/workflows/build.yml)
[![Docker Image Version](https://img.shields.io/docker/v/g3rhard/docker-webdav-ubuntu?style=for-the-badge&logo=docker&logoColor=white&color=333333)](https://hub.docker.com/r/g3rhard/docker-webdav-ubuntu)

## Usage example

```
docker run -d -p 8080:80 --name webdav \
  -e LDAP_URL="ldap://ldap-server.example.com/ou=users,dc=example,dc=com?uid?sub" \
  -e LDAP_BIND_DN="cn=admin,dc=example,dc=com" \
  -e LDAP_BIND_PASSWORD="ldap-password" \
  -e WEBDAV_USER="admin" \
  -e WEBDAV_PASSWORD="securepassword" \
  apache-webdav-ubuntu
```
