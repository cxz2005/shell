#!/bin/bash
install_docker(){
# 安装必要的工具
yum install -y yum-utils device-mapper-persistent-data lvm2 git

# 添加 Docker 的 yum 源
docker_yum_repo="http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
yum-config-manager --add-repo $docker_yum_repo

# 安装 Docker CE
yum install -y docker-ce

# 启动并启用 Docker 服务
systemctl start docker
systemctl enable docker

# 配置 Docker 镜像加速器
mirror_url="https://88a8bf279d4a486ba021cdfcb4abc36d.mirror.swr.myhuaweicloud.com"
cat > /etc/docker/daemon.json << EOF
{
    "registry-mirrors": ["$mirror_url"]
}
EOF

# 重启 Docker 以应用配置更改
systemctl restart docker

# 验证 Docker 版本
docker -v
}
install_docker