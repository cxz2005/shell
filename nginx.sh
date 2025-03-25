#!/bin/bash

# 安装Nginx函数
install_nginx() {
    # 安装yum-utils工具
    yum install yum-utils -y
    
    # 创建Nginx的YUM源配置文件
    cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
    
    # 安装Nginx
    yum install nginx -y
    
    # 检查Nginx是否安装成功
    if ! command -v nginx &> /dev/null; then
        echo "Nginx安装失败"
        exit 1
    fi
    
    # 查看Nginx版本
    nginx -v
    
    # 启动Nginx服务
    systemctl start nginx
    
    # 设置Nginx开机自启
    systemctl enable nginx
    
    # 停止firewalld服务
    systemctl stop firewalld
    
    # 禁用firewalld开机自启
    systemctl disable firewalld
    
    # 设置SELinux为宽松模式
    setenforce 0
}
# 调用函数安装Nginx
install_nginx