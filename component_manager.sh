#!/bin/bash


# 设置组件的版本和目录
JAVA_VERSION="11"
INSTALL_DIR="/usr/local"
KAFKA_DIR="$INSTALL_DIR/kafka"
ZOOKEEPER_DIR="$INSTALL_DIR/zookeeper"
JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"


# 打印菜单
function main_menu() {
    echo "=========================="
    echo "组件管理脚本 v1.0"
    echo "=========================="
    echo "1. 管理组件"
    echo "2. 配置环境"
    echo "3. 启动 Zookeeper 默认端口: 2182"
    echo "4. 启动 Kafka 默认端口: 9092"
    echo "5. 停止 Zookeeper"
    echo "6. 停止 Kafka"
    echo "7. 查看服务状态"
    echo "8. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


function config_menu() {
    echo "=========================="
    echo "配置环境脚本"
    echo "=========================="
    echo "1. 关闭防火墙"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_menu() {
    echo "=========================="
    echo "管理脚本"
    echo "=========================="
    echo "1. 管理JDK"
    echo "2. 管理Kafka"
    echo "3. 管理Zookeeper"
    echo "4. 管理Docker"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
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

function check_jdk_installed() {
    echo "检查 JDK 安装状态..."

    # 检查 java 是否存在
    if command -v java &>/dev/null; then
        echo "JDK 已安装：$(java -version 2>&1 | head -n 1)"
    else
        echo "JDK 未安装！"
        return 1
    fi

    # 检查 JAVA_HOME 环境变量
    if [ -d "$JAVA_HOME_PATH" ]; then
        echo "JAVA_HOME 配置正确：$JAVA_HOME_PATH"
    else
        echo "JAVA_HOME 配置错误或未设置！"
        return 1
    fi

    # 检查 java 命令是否能正确执行
    if java -version &>/dev/null; then
        echo "Java 配置成功！"
    else
        echo "Java 配置失败！"
        return 1
    fi

    echo "JDK 安装和配置正常！"
    return 0
}

function install_zookeep() {
    # 提示用户输入 Zookeeper 版本（默认 3.8.1）
    echo "请输入要安装的 Zookeeper 版本（例如 3.8.1，默认 3.8.1）："
    read ZOOKEEPER_VERSION
    ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION:-3.8.4}  # 如果没有输入，使用默认版本 3.8.1

    echo "安装 Zookeeper ${ZOOKEEPER_VERSION}..."

    # 下载 Zookeeper
    wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -O zookeeper.tgz

    if [ $? -ne 0 ]; then
        echo "下载 Zookeeper 失败！"
        echo "请到 https://downloads.apache.org/zookeeper/ 检查版本！"
        exit 1
    fi

    # 安装 Zookeeper
    sudo mkdir -p $ZOOKEEPER_DIR
    sudo tar -xvzf zookeeper.tgz -C $ZOOKEEPER_DIR --strip-components=1

    if [ $? -ne 0 ]; then
        echo "解压 Zookeeper 失败！"
        exit 1
    fi

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

function install_kafka() {
    local version="3.9.0" # 默认版本
    read -p "请输入 Kafka 版本（默认 ${version}）：" input_version
    version=${input_version:-$version}
    local kafka_url="https://downloads.apache.org/kafka/${version}/kafka_2.13-${version}.tgz"

    echo "下载并安装 Kafka ${version}..."
    wget -q "$kafka_url" -O kafka.tgz || { echo "下载失败，请到 https://downloads.apache.org/kafka 检查版本号！"; return 1; }

    sudo mkdir -p "$KAFKA_DIR"
    sudo tar -xvzf kafka.tgz -C "$KAFKA_DIR" --strip-components=1
    rm kafka.tgz

    # 配置 Kafka
    echo "配置 Kafka..."
    cat <<EOF | sudo tee "$KAFKA_DIR/config/server.properties" > /dev/null
log.dirs=$KAFKA_DIR/logs
broker.id=0
num.network.threads=3
num.io.threads=8
zookeeper.connect=localhost:2181
EOF

    echo "Kafka ${version} 安装完成！"
}

function install_zookeeper() {
    local version="3.8.4" # 默认版本
    read -p "请输入 Zookeeper 版本（默认 ${version}）：" input_version
    version=${input_version:-$version}
    local zookeeper_url="https://downloads.apache.org/zookeeper/zookeeper-${version}/apache-zookeeper-${version}-bin.tar.gz"

    echo "下载并安装 Zookeeper ${version}..."
    wget -q "$zookeeper_url" -O zookeeper.tgz || { echo "下载失败，请检查版本号！"; return 1; }

    sudo mkdir -p "$ZOOKEEPER_DIR"
    sudo tar -xvzf zookeeper.tgz -C "$ZOOKEEPER_DIR" --strip-components=1
    rm zookeeper.tgz

    # 配置 Zookeeper
    echo "配置 Zookeeper..."
    sudo mkdir -p "$ZOOKEEPER_DIR/data"
    cat <<EOF | sudo tee "$ZOOKEEPER_DIR/conf/zoo.cfg" > /dev/null
tickTime=2000
dataDir=$ZOOKEEPER_DIR/data
clientPort=2181
initLimit=5
syncLimit=2
EOF

    echo "Zookeeper ${version} 安装完成！"
}


# 卸载 Kafka
function uninstall_kafka() {
    echo "开始卸载 Kafka ..."

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


function install_zookeeper() {
   echo "下载并安装 Zookeeper..."

    # 设置 Zookeeper 版本


    # 下载 Zookeeper
    wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -O zookeeper.tgz

    if [ $? -ne 0 ]; then
        echo "下载 Zookeeper 失败！"
        echo "请到 https://downloads.apache.org/zookeeper/ 检查版本！"
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
function register_zookeeper_service() {
    echo "将 ZooKeeper 注册为系统服务并设置为开机自启..."

    # 创建 systemd 服务文件
    sudo bash -c 'cat << EOF > /etc/systemd/system/zookeeper.service
[Unit]
Description=Apache ZooKeeper server
Documentation=http://zookeeper.apache.org/
After=network.target

[Service]
Type=simple
User=root
ExecStart=$ZOOKEEPER_DIR/bin/zkServer.sh start-foreground
ExecStop=$ZOOKEEPER_DIR/bin/zkServer.sh stop
Restart=on-failure
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF'

    # 重新加载 systemd 配置
    sudo systemctl daemon-reload

    # 启动 ZooKeeper 服务并设置开机自启
    sudo systemctl start zookeeper
    sudo systemctl enable zookeeper

    # 检查服务状态
    if sudo systemctl is-active --quiet zookeeper; then
        echo "ZooKeeper 服务已启动并设置为开机自启！"
    else
        echo "ZooKeeper 服务启动失败！"
    fi
}

function unregister_zookeeper_service() {
    echo "卸载 ZooKeeper 服务..."

    # 停止 ZooKeeper 服务
    sudo systemctl stop zookeeper

    # 禁用 ZooKeeper 服务开机自启
    sudo systemctl disable zookeeper

    # 删除 ZooKeeper 服务文件
    sudo rm /etc/systemd/system/zookeeper.service

    # 重新加载 systemd 配置
    sudo systemctl daemon-reload

    echo "ZooKeeper 服务已成功卸载！"
}


function start_zookeeper_service() {
    echo "启动 ZooKeeper 服务..."
    sudo systemctl start zookeeper

    if sudo systemctl is-active --quiet zookeeper; then
        echo "ZooKeeper 服务已成功启动！"
    else
        echo "ZooKeeper 服务启动失败！"
    fi
}

function stop_zookeeper_service() {
    echo "停止 ZooKeeper 服务..."
    sudo systemctl stop zookeeper

    if sudo systemctl is-active --quiet zookeeper; then
        echo "ZooKeeper 服务未停止！"
    else
        echo "ZooKeeper 服务已成功停止！"
    fi
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

function check_kafka_installed() {
    echo "检查 Kafka 安装状态..."

    # 检查 Kafka 安装目录是否存在
    if [ -d "$KAFKA_DIR" ]; then
        echo "Kafka 安装目录已找到：$KAFKA_DIR"
    else
        echo "Kafka 未安装或安装目录不存在！"
        return 1
    fi

    # 检查 Kafka 配置文件是否存在
    if [ -f "$KAFKA_DIR/config/server.properties" ]; then
        echo "Kafka 配置文件已找到：$KAFKA_DIR/config/server.properties"
    else
        echo "Kafka 配置文件不存在！"
        return 1
    fi

    # 检查 Kafka 服务是否正在运行
    if pgrep -f "kafka-server-start" >/dev/null; then
        echo "Kafka 服务正在运行"
    else
        echo "Kafka 服务未运行"
        return 1
    fi

    echo "Kafka 安装和配置正常！"
    return 0
}


function check_zookeeper_installed() {
    echo "检查 Zookeeper 安装状态..."

    # 检查 Zookeeper 安装目录是否存在
    if [ -d "$ZOOKEEPER_DIR" ]; then
        echo "Zookeeper 安装目录已找到：$ZOOKEEPER_DIR"
    else
        echo "Zookeeper 未安装或安装目录不存在！"
        return 1
    fi

    # 检查 Zookeeper 配置文件是否存在
    if [ -f "$ZOOKEEPER_DIR/conf/zoo.cfg" ]; then
        echo "Zookeeper 配置文件已找到：$ZOOKEEPER_DIR/conf/zoo.cfg"
    else
        echo "Zookeeper 配置文件不存在！"
        return 1
    fi

    # 检查 Zookeeper 服务是否正在运行
    if pgrep -f "zookeeper-server-start" >/dev/null; then
        echo "Zookeeper 服务正在运行"
    else
        echo "Zookeeper 服务未运行"
        return 1
    fi

    echo "Zookeeper 安装和配置正常！"
    return 0
}

function install_docker() {
    echo "开始安装 Docker..."

    # 更新系统并安装 Docker
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # 添加 Docker 的官方 GPG 密钥
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # 添加 Docker 官方的稳定版源
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # 安装 Docker
    sudo apt update
    sudo apt install -y docker-ce

    # 验证 Docker 是否安装成功
    if docker --version &>/dev/null; then
        echo "Docker 安装成功！"
    else
        echo "Docker 安装失败！"
        exit 1
    fi

    # 启动并设置 Docker 开机启动
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker 安装完成并已启动！"
}

function register_kafka_service() {
    echo "将 Kafka 注册为服务并设置为开机自启..."

    # 创建 systemd 服务文件
    sudo bash -c 'cat << EOF > /etc/systemd/system/kafka.service
[Unit]
Description=Apache Kafka server
Documentation=http://kafka.apache.org/
After=network.target

[Service]
Type=simple
User=root
ExecStart=$KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties
ExecStop=$KAFKA_DIR/bin/kafka-server-stop.sh
Restart=on-failure
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF'

    # 重新加载 systemd 服务文件
    sudo systemctl daemon-reload

    # 启动 Kafka 服务
    sudo systemctl start kafka
    # 设置 Kafka 服务开机自启
    sudo systemctl enable kafka

    echo "Kafka 服务已成功注册并设置为开机自启！"
}

function unregister_kafka_service() {
    echo "卸载 Kafka 服务..."

    # 停止 Kafka 服务
    sudo systemctl stop kafka

    # 禁用 Kafka 服务开机自启
    sudo systemctl disable kafka

    # 删除 Kafka 服务文件
    sudo rm /etc/systemd/system/kafka.service

    # 重新加载 systemd 配置
    sudo systemctl daemon-reload

    echo "Kafka 服务已成功卸载！"
}


function enable_kafka_service() {
    echo "启动 Kafka 服务..."
    sudo systemctl start kafka
    echo "Kafka 服务已启动！"
}

function disable_kafka_service() {
    echo "停止 Kafka 服务..."
    # 停止 Kafka 服务
    sudo systemctl stop kafka
    echo "Kafka 服务已成功停止！"
}



function uninstall_docker() {
    echo "开始卸载 Docker..."

    # 停止 Docker 服务
    sudo systemctl stop docker

    # 卸载 Docker
    sudo apt remove --purge -y docker-ce docker-ce-cli containerd.io

    # 删除 Docker 相关的文件
    sudo rm -rf /var/lib/docker

    # 删除 Docker GPG 密钥和源
    sudo rm /etc/apt/keyrings/docker.asc
    sudo rm /etc/apt/sources.list.d/docker.list

    echo "Docker 卸载完成！"
}

function check_docker_installed() {
    echo "检查 Docker 安装状态..."

    # 检查 Docker 是否安装
    if ! command -v docker &>/dev/null; then
        echo "Docker 未安装！"
        return 1
    fi

    # 检查 Docker 服务是否在运行
    if sudo systemctl is-active --quiet docker; then
        echo "Docker 服务正在运行"
    else
        echo "Docker 服务未运行"
        return 1
    fi

    # 检查 Docker 版本
    docker_version=$(docker --version)
    echo "Docker 版本：$docker_version"

    echo "Docker 安装和服务状态正常！"
    return 0
}




function manager_menu_loop() {
    while true; do
        manager_menu
        read -r manager_menu_choice
        case $manager_menu_choice in
        1) manager_jdk_menu_loop ;;
        2) manager_kafka_menu_loop ;;
        3) manager_zookeeper_menu_loop ;;
        3) manager_docker_menu_loop ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
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

function manager_kafka_menu_loop() {
    while true; do
        manager_kafka_menu
        read -r manager_kafka_menu_loop
        case manager_kafka_menu_loop in
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

function manager_docker_menu_loop() {
    while true; do
        manager_menu
        read -r manager_zookeeper_menu_choice
        case $manager_zookeeper_menu_choice in
        1) install_zookeeper ;;
        2) uninstall_zookeeper ;;
        3) check_zookeeper_installed ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}



function config_menu_loop() {
    while true; do
        config_menu
        read -r config_choice
        case config_choice in
        1) disable_firewall ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


# 主菜单循环
while true; do
    main_menu
    read -r choice
    case $choice in
    1) manager_menu_loop ;;
    2) config_menu_loop ;;
    3) start_kafka ;;
    4) start_zookeeper ;;
    5) stop_zookeeper ;;
    6) stop_kafka ;;
    8) exit 0 ;;
    *) echo "无效选项，请重试！" ;;
    esac
done
