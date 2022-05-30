FROM richarvey/nginx-php-fpm:2.1.2

RUN apk add --no-cache openjdk8

# 镜像源
RUN echo "https://mirrors.aliyun.com/alpine/v3.15/main/" > /etc/apk/repositories
# 时区
ARG TIMEZONE=Asia/Shanghai
RUN apk --no-cache add tzdata && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/TZ && echo "${TIMEZONE}" > /etc/timezone

# 扩展
RUN docker-php-ext-install -j$(nproc) bcmath gd opcache zip
# nginx配置文件
RUN rm -rf /etc/nginx/nginx.conf && rm -rf /etc/nginx/sites-available/default.conf && rm -rf /etc/nginx/sites-available/default-ssl.conf && rm -rf /etc/nginx/sites-enabled/default.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx-site.conf /etc/nginx/sites-available/default.conf
COPY conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# # 清理
RUN apk del tzdata
RUN rm -rf /tmp/* /var/cache/apk/*