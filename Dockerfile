FROM centos:7
ADD ./nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum update -y && yum install nginx curl docker -y
ADD ./docker /usr/bin/docker
ADD gen_nginx_conf /usr/bin/gen_nginx_conf
ADD ./setup.sh /
CMD ["sh", "-c", "/setup.sh && nginx -g \"daemon off;\""]
