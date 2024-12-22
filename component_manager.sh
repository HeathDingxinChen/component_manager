#!/bin/bash

# 设置组件的版本和目录
JAVA_VERSION="11"
KAFKA_VERSION="3.6.0"
SCALA_VERSION="2.13"
INSTALL_DIR="/usr/local"
KAFKA_DIR="$INSTALL_DIR/kafka"
ZOOKEEPER_DIR="/tmp/zookeeper"

# 打印菜单
function menu() {
    echo "=========================="
    echo "组件管理脚本"
    echo "=========================="
    echo "1. 安装组件 (Java, Kafka, Zookeeper)"
    echo "2. 启动 Zookeeper"
    echo "3. 启动 Kafka"
    echo "4. 停止 Zookeeper"
    echo "5. 停止 Kafka"
    echo "6. 查看服务状态"
    echo "7. 卸载组件"
    echo "8. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-8]: "
}

# 安装组件
function install_components() {
    echo "更新系统并安装必要依赖..."
    sudo apt update && sudo apt install -y openjdk-${JAVA_VERSION}-jdk wget tar

    echo "下载并安装 Kafka..."
    wget -q https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O kafka.tgz
    sudo mkdir -p $KAFKA_DIR
    sudo tar -xvzf kafka.tgz -C $KAFKA_DIR --strip-components=1
    rm kafka.tgz

    echo "安装完成！"
}

# 启动 Zookeeper
function start_zookeeper() {
    echo "启动 Zookeeper..."
    mkdir -p $ZOOKEEPER_DIR
    nohup $KAFKA_DIR/bin/zookeeper-server-start.sh $KAFKA_DIR/config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &
    echo "Zookeeper 启动完成！"
}

# 启动 Kafka
function start_kafka() {
    echo "启动 Kafka..."
    nohup $KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties > /tmp/kafka.log 2>&1 &
    echo "Kafka 启动完成！"
}

# 停止 Zookeeper
function stop_zookeeper() {
    echo "停止 Zookeeper..."
    pkill -f "zookeeper-server-start"
    echo "Zookeeper 已停止！"
}

# 停止 Kafka
function stop_kafka() {
    echo "停止 Kafka..."
    pkill -f "kafka-server-start"
    echo "Kafka 已停止！"
}

# 查看服务状态
function status() {
    echo "检查服务状态..."
    if pgrep -f "zookeeper-server-start" >/dev/null; then
        echo "Zookeeper 正在运行"
    else
        echo "Zookeeper 未运行"
    fi
    if pgrep -f "kafka-server-start" >/dev/null; then
        echo "Kafka 正在运行"
    else
        echo "Kafka 未运行"
    fi
}

# 卸载组件
function uninstall_components() {
    echo "卸载组件..."
    sudo rm -rf $KAFKA_DIR $ZOOKEEPER_DIR
    echo "卸载完成！"
}

# 主菜单循环
while true; do
    menu
    read -r choice
    case $choice in
    1) install_components ;;
    2) start_zookeeper ;;
    3) start_kafka ;;
    4) stop_zookeeper ;;
    5) stop_kafka ;;
    6) status ;;
    7) uninstall_components ;;
    8) exit 0 ;;
    *) echo "无效选项，请重试！" ;;
    esac
done
