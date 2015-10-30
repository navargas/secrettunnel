FROM navargas/docker-client
ADD ./include/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum update -y && yum install nginx curl -y
ADD ./include/gen_nginx_conf /usr/bin/gen_nginx_conf
ADD ./include/default.conf /etc/nginx/conf.d/default.conf
ADD ./include/setup.sh /usr/bin/
ADD ./include/reset_connection /usr/bin/
CMD ["sh", "-c", "setup.sh && nginx -g \"daemon off;\""]
