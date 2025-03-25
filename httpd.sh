#!/bin/bash

# 定义函数安装 HTTPD
install_httpd() {
    # 检查是否为 root 用户
    if [[ $EUID -ne 0 ]]; then
        echo "错误: 必须以 root 用户身份运行此脚本"
        exit 1
    fi

    # 检查系统是否支持 yum 或 dnf
    if command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
    else
        echo "错误: 此脚本仅支持使用 yum 或 dnf 的系统"
        exit 1
    fi

    # 关闭防火墙
    echo "关闭防火墙..."
    if ! systemctl stop firewalld; then
        echo "警告: 关闭防火墙失败，可能防火墙未运行或命令不适用"
    fi

    if ! systemctl disable firewalld; then
        echo "警告: 禁用防火墙开机自启失败，可能防火墙未安装或命令不适用"
    fi

    # 安装 HTTPD
    echo "正在安装 HTTPD..."
    if ! $PACKAGE_MANAGER install httpd -y; then
        echo "错误: 安装 HTTPD 失败"
        exit 1
    fi
    echo "HTTPD 安装成功"

    # 启动 HTTPD 服务
    echo "正在启动 HTTPD 服务..."
    if ! systemctl start httpd; then
        echo "错误: 启动 HTTPD 服务失败"
        exit 1
    fi

    # 设置 HTTPD 开机自启
    echo "设置 HTTPD 开机自启..."
    if ! systemctl enable httpd; then
        echo "警告: 设置 HTTPD 开机自启失败"
    fi

    # 检查 HTTPD 服务状态
    echo "检查 HTTPD 服务状态..."
    if systemctl is-active --quiet httpd; then
        echo "HTTPD 服务已成功启动并正在运行"
    else
        echo "错误: HTTPD 服务未运行"
        exit 1
    fi
}

# 调用函数安装 HTTPD
install_httpd