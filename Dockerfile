FROM navargas/docker-client
ADD ./nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum update -y && yum install nginx curl -y
ADD gen_nginx_conf /usr/bin/gen_nginx_conf
ADD ./default.conf /etc/nginx/conf.d/default.conf
ADD ./setup.sh /
CMD ["sh", "-c", "/setup.sh && nginx -g \"daemon off;\""]
