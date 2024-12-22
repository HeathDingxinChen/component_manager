#!/bin/bash


# 设置组件的版本和目录
JAVA_VERSION="11"
KAFKA_VERSION="3.6.0"
ZOOKEEPER_VERSION="3.8.1"
SCALA_VERSION="2.13"
INSTALL_DIR="/usr/local"
KAFKA_DIR="$INSTALL_DIR/kafka"
ZOOKEEPER_DIR="$INSTALL_DIR/zookeeper"
JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"


# 打印菜单
function menu() {
    echo "=========================="
    echo "组件管理脚本"
    echo "=========================="
    echo "1. 安装\配置组件"
    echo "2. 配置环境"
    echo "3. 启动 Zookeeper 默认端口: 2182"
    echo "4. 启动 Kafka 默认端口: 9092"
    echo "5. 停止 Zookeeper"
    echo "6. 停止 Kafka"
    echo "7. 查看服务状态"
    echo "8. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-8]: "
}


function config_menu() {
    echo "=========================="
    echo "配置环境脚本"
    echo "=========================="
    echo "1. 关闭防火墙"
    echo "=========================="
    echo -n "请输入选项 [1-8]: "
}

function install_menu() {
    echo "=========================="
    echo "组件安装脚本"
    echo "=========================="
    echo "1. 安装Java Open JDK version: ${JAVA_VERSION}"
    echo "2. 卸载Java"
    echo "3. 安装Kafka version: ${KAFKA_VERSION}"
    echo "4. 卸载Kafka"
    echo "5. 安装Zookeeper version: ${ZOOKEEPER_VERSION}"
    echo "6. 卸载Zookeeper"
    echo "8. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-8]: "
}

# 安装jdk11
function install_jdk11() {
    echo "更新系统并安装必要依赖..."
    sudo apt update && sudo apt install -y openjdk-${JAVA_VERSION}-jdk wget tar

    if java -version &>/dev/null; then
        echo "OpenJDK ${JAVA_VERSION} 安装成功！"
    else
        echo "安装 OpenJDK ${JAVA_VERSION} 失败！"
    exit 1
    fi

    # 配置 JAVA_HOME 和 PATH 环境变量
    echo "正在配置 JAVA_HOME 和 PATH..."

    # 添加环境变量到 .bashrc 或 .bash_profile
    echo "export JAVA_HOME=${JAVA_HOME_PATH}" >> ~/.bashrc
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc


    # 验证配置
    echo "验证 Java 配置..."
    if [ -d "$JAVA_HOME_PATH" ] && java -version &>/dev/null; then
        echo "Java 配置成功！"
    else
        echo "Java 配置失败！"
        exit 1
    fi

    echo "完成！您可以使用 Java 命令了。"

    # 使修改生效
    source ~/.bashrc
}

function uninstall_jdk11() {
  echo "开始卸载 OpenJDK ${JAVA_VERSION}..."

    # 卸载 JDK 包
    sudo apt remove --purge -y openjdk-${JAVA_VERSION}-jdk
    if [ $? -ne 0 ]; then
        echo "卸载 OpenJDK ${JAVA_VERSION} 失败！"
        exit 1
    fi

    # 删除环境变量配置
    echo "清理环境变量配置..."
    sed -i '/JAVA_HOME/d' ~/.bashrc
    sed -i '/java\/bin/d' ~/.bashrc

    # 刷新环境变量
    source ~/.bashrc

    # 检查卸载结果
    if java -version &>/dev/null; then
        echo "OpenJDK 卸载失败！"
        exit 1
    else
        echo "OpenJDK 卸载成功！"
    fi
}

function install_kafka() {
   echo "下载并安装 Kafka..."
    wget -q https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O kafka.tgz

    if [ $? -ne 0 ]; then
        echo "下载 Kafka 失败！"
        exit 1
    fi

    sudo mkdir -p $KAFKA_DIR
    sudo tar -xvzf kafka.tgz -C $KAFKA_DIR --strip-components=1

    if [ $? -ne 0 ]; then
        echo "解压 Kafka 失败！"
        exit 1
    fi

    rm kafka.tgz

    echo "配置 Kafka..."
    cat <<EOF | sudo tee $KAFKA_DIR/config/server.properties > /dev/null
broker.id=0
log.dirs=$KAFKA_DIR/logs
zookeeper.connect=localhost:2181
num.network.threads=3
num.io.threads=8
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connection.timeout.ms=6000
EOF

    if [ $? -eq 0 ]; then
        echo "Kafka 安装和配置完成！"
    else
        echo "Kafka 配置失败！"
        exit 1
    fi
}

# 卸载 Kafka
function uninstall_kafka() {
    echo "开始卸载 Kafka ${KAFKA_VERSION}..."

    # 停止 Kafka
    pkill -f "kafka-server-start"

    if [ $? -ne 0 ]; then
        echo "停止 Kafka 失败！"
        exit 1
    fi

    # 删除 Kafka 安装目录
    sudo rm -rf $KAFKA_DIR
    if [ $? -ne 0 ]; then
        echo "删除 Kafka 安装目录失败！"
        exit 1
    fi

    # 删除 Kafka 日志文件
    sudo rm -rf $KAFKA_DIR/logs
    if [ $? -ne 0 ]; then
        echo "删除 Kafka 日志文件失败！"
        exit 1
    fi

    # 删除 Kafka 配置文件
    sudo rm -rf $KAFKA_DIR/config
    if [ $? -ne 0 ]; then
        echo "删除 Kafka 配置文件失败！"
        exit 1
    fi

    echo "Kafka 卸载完成！"
}


function install_zookeep() {
   echo "下载并安装 Zookeeper..."

    # 设置 Zookeeper 版本


    # 下载 Zookeeper
    wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -O zookeeper.tgz

    if [ $? -ne 0 ]; then
        echo "下载 Zookeeper 失败！"
        exit 1
    fi

    # 解压 Zookeeper
    sudo mkdir -p $ZOOKEEPER_DIR
    sudo tar -xvzf zookeeper.tgz -C $ZOOKEEPER_DIR --strip-components=1

    if [ $? -ne 0 ]; then
        echo "解压 Zookeeper 失败！"
        exit 1
    fi

    # 删除安装包
    rm zookeeper.tgz

    # 配置 Zookeeper
    echo "配置 Zookeeper..."
    sudo mkdir -p $ZOOKEEPER_DIR/data
    cat <<EOF | sudo tee $ZOOKEEPER_DIR/conf/zoo.cfg > /dev/null
tickTime=2000
dataDir=$ZOOKEEPER_DIR/data
clientPort=2181
initLimit=5
syncLimit=2
EOF

    if [ $? -eq 0 ]; then
        echo "Zookeeper 安装和配置完成！"
    else
        echo "Zookeeper 配置失败！"
        exit 1
    fi
}

# 卸载 Zookeeper
function uninstall_zookeeper() {
    echo "卸载 Zookeeper..."

    # 停止 Zookeeper
    pkill -f "zookeeper-server-start"

    # 删除 Zookeeper 文件和目录
    sudo rm -rf $ZOOKEEPER_DIR

    if [ $? -eq 0 ]; then
        echo "Zookeeper 卸载完成！"
    else
        echo "卸载 Zookeeper 失败！"
        exit 1
    fi
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

# 停止 Kafka
function disable_firewall() {
    echo "停止 防火墙..."
    sudo ufw disable
    echo "防火墙 已停止！"
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

function install_menu_loop() {
    while true; do
        install_menu
        read -r install_choice
        case $install_choice in
        1) install_java ;;
        2) uninstall_jdk11 ;;
        3) install_kafka ;;
        4) uninstall_kafka ;;
        5) install_zookeep ;;
        6) uninstall_zookeeper ;;
        8) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


function config_menu_loop() {
    while true; do
        install_menu
        read -r config_choice
        case config_choice in
        1) disable_firewall ;;
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


# 主菜单循环
while true; do
    menu
    read -r choice
    case $choice in
    1) install_menu_loop ;;
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
