#!/bin/bash


# 设置组件的版本和目录
JAVA_VERSION="11"
INSTALL_DIR="/usr/local"
KAFKA_DIR="$INSTALL_DIR/kafka"
ZOOKEEPER_DIR="$INSTALL_DIR/zookeeper"
JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
# 配置 Kafka 和 Zookeeper 的地址和端口
KAFKA_PORT="9092"
ZOOKEEPER_PORT="2181"

# 打印菜单




function bootup_menu() {
    echo "=========================="
    echo "一键启动"
    echo "=========================="
    echo "1. 启动Kafka & Zookeeper"
    echo "2. 关闭Kafka & Zookeeper"
    echo "3. 检查Kafka & Zookeeper"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function bootup_menu_loop() {
    while true; do
        bootup_menu
        read -r bootup_menu_choice
        case $bootup_menu_choice in
        1) bootup_kafka_and_zookeeper ;;
        2) stop_kafka_and_zookeeper ;;
        3) check_kafka_and_zookeeper_status ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


function bootup_kafka_and_zookeeper() {
    echo "启动 Zookeeper..."
    mkdir -p $ZOOKEEPER_DIR
    nohup $KAFKA_DIR/bin/zookeeper-server-start.sh $KAFKA_DIR/config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &
    echo "Zookeeper 启动完成！"

    echo "启动 Kafka..."
    nohup $KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties > /tmp/kafka.log 2>&1 &
    echo "Kafka 启动完成！"
}

function stop_kafka_and_zookeeper() {
    echo "停止 Zookeeper..."
    pkill -f "zookeeper-server-start"
    echo "Zookeeper 已停止！"

    echo "停止 Kafka..."
    pkill -f "kafka-server-start"
    echo "Kafka 已停止！"
}


function check_kafka_and_zookeeper_status() {
    check_kafka
    check_zookeeper
    check_kafka_availability
    check_zookeeper_availability
}

function check_env_menu() {
    echo "=========================="
    echo "环境变量"
    echo "=========================="
    echo "1. 展示系统信息"
    echo "2. 展示组件信息"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


function check_env_loop() {
    while true; do
        check_env_menu
        read -r check_env_menu_choice
        case $check_env_menu_choice in
        1) show_system_info ;;
        2) show_components_info ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}function config_menu() {
    echo "=========================="
    echo "配置环境"
    echo "=========================="
    echo "1. 关闭防火墙"
    echo "2. 更新apt&安装常用工具"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


function config_menu_loop() {
    while true; do
        config_menu
        read -r config_menu_choice
        case $config_menu_choice in
        1) disable_firewall ;;
        2) apt_update_and_install_util ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}

function main_menu() {
    echo "=========================="
    echo "组件管理脚本 By Heath"
    echo "version: v24458a8"
    echo "updateTime: 2025-01-05 01:06:25"
    echo "=========================="
    echo "1. 管理组件"
    echo "2. 配置环境"
    echo "3. 一键启动"
    echo "4. 环境变量"
    echo "8. 重载脚本"
    echo "9. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


while true; do
    main_menu
    read -r main_menu_choice
    case $main_menu_choice in
    1) manager_menu_loop ;;
    2) config_menu_loop ;;
    3) bootup_menu_loop ;;
    4) check_env_loop ;;
    9) exit 0 ;;
    *) echo "无效选项，请重试！" ;;
    esac
done
function manager_docker_menu() {
    echo "=========================="
    echo "配置环境"
    echo "=========================="
    echo "1. 安装docker"
    echo "2. 卸载docker"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_docker_menu_loop() {
    while true; do
        manager_docker_menu
        read -r manager_docker_menu_choice
        case $manager_docker_menu_choice in
        1) install_docker ;;
        2) uninstall_docker ;;
        3) check_docker_installed ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


function manager_jdk_menu() {
    echo "=========================="
    echo "管理JDK"
    echo "=========================="
    echo "1. 安装Java Open JDK version"
    echo "2. 卸载Java"
    echo "3. 检查Java安装状态"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_jdk_menu_loop() {
    while true; do
        manager_jdk_menu
        read -r manager_jdk_menu_choice
        case $manager_jdk_menu_choice in
        1) install_jdk11 ;;
        2) uninstall_jdk11 ;;
        3) check_jdk_installed ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}
function manager_kafka_menu() {
    echo "=========================="
    echo "管理Kafka"
    echo "=========================="
    echo "1. 安装Kafka"
    echo "2. 卸载Kafka"
    echo "3. 检查Kafka安装状态"
    echo "4. 注册Kafka服务"
    echo "5. 卸载Kafka服务"
    echo "6. 启动Kafka服务"
    echo "7. 停止Kafka服务"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_kafka_menu_loop() {
    while true; do
        manager_kafka_menu
        read -r manager_kafka_menu_loop
        case $manager_kafka_menu_loop in
        1) install_kafka ;;
        2) uninstall_kafka ;;
        3) check_kafka_installed ;;
        4) register_kafka_service ;;
        5) unregister_kafka_service ;;
        6) enable_kafka_service ;;
        7) disable_kafka_service ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}function manager_menu() {
    echo "=========================="
    echo "管理组件"
    echo "=========================="
    echo "1. 管理JDK"
    echo "2. 管理Kafka"
    echo "3. 管理Zookeeper"
    echo "4. 管理Docker"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_docker_menu_loop() {
    while true; do
        manager_menu
        read -r manager_docker_menu_choice
        case $manager_docker_menu_choice in
        1) install_docker ;;
        2) uninstall_docker ;;
        3) check_docker_installed ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}



function manager_zookeeper_menu() {
    echo "=========================="
    echo "管理Zookeeper"
    echo "=========================="
    echo "1. 安装Zookeeper"
    echo "2. 卸载Zookeeper"
    echo "3. 检查Zookeeper安装状态"
    echo "4. 注册Zookeeper服务"
    echo "5. 卸载Zookeeper服务"
    echo "6. 启动Zookeeper服务"
    echo "7. 停止Zookeeper服务"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


function manager_zookeeper_menu_loop() {
    while true; do
        manager_zookeeper_menu
        read -r manager_zookeeper_menu_choice
        case $manager_zookeeper_menu_choice in
        1) install_zookeeper ;;
        2) uninstall_zookeeper ;;
        3) check_zookeeper_installed ;;
        4) register_zookeeper_service ;;
        5) unregister_zookeeper_service ;;
        6) enable_zookeeper_service ;;
        7) disable_zookeeper_service ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}

