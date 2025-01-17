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




function config_menu() {
    echo "=========================="
    echo "配置环境"
    echo "=========================="
    echo "1. 关闭防火墙"
    echo "2. 更新apt&安装常用工具"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

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


function manager_menu() {
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
function show_components_info() {
  echo "Kafka 默认安装地址: $KAFKA_DIR"
  echo "Kafka 默认端口: $KAFKA_PORT"

  echo "Zookeeper 默认安装地址: $ZOOKEEPER_DIR"
  echo "Zookeeper 默认端口: $ZOOKEEPER_PORT"

  echo "JDK 默认安装地址: $JAVA_HOME_PATH"

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


function install_thefuck() {

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户运行该脚本。"
  exit 1
fi

# 定义需要安装的软件包
PACKAGES=("python3-dev" "python3-pip" "python3-setuptools")

# 检查并安装缺失的软件包
echo "检测并安装必要的软件包..."
for PACKAGE in "${PACKAGES[@]}"; do
  if dpkg -l | grep -q "^ii\s\+$PACKAGE"; then
    echo "$PACKAGE 已安装，跳过。"
  else
    echo "正在安装 $PACKAGE..."
    sudo apt install -y $PACKAGE
  fi
done

# 检查是否安装 pip3
if ! command -v pip3 &>/dev/null; then
  echo "pip3 未正确安装，请检查。"
  exit 1
fi

# 检查并安装 thefuck
echo "检测并安装 thefuck..."
if pip3 show thefuck &>/dev/null; then
  echo "thefuck 已安装，跳过。"
else
  echo "正在安装 thefuck..."
  pip3 install thefuck --user
fi

echo "所有软件已安装完成！"

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
clientPort=$ZOOKEEPER_PORT
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

    read -p "是否使用国内镜像源下载 Kafka？(y/n, 默认 y)：" use_mirror
    use_mirror=${use_mirror:-y}

    local kafka_url="https://downloads.apache.org/kafka/${version}/kafka_2.13-${version}.tgz"

    # 设置下载 URL
    if [[ "$use_mirror" == "y" || "$use_mirror" == "Y" ]]; then
        # 使用国内镜像源（例如阿里云）
        local kafka_url="https://mirrors.aliyun.com/apache/kafka/${version}/kafka_2.13-${version}.tgz"
    else
        # 使用官方下载地址
        local kafka_url="https://downloads.apache.org/kafka/${version}/kafka_2.13-${version}.tgz"
    fi

    echo "下载并安装 Kafka ${version}..."
    wget "$kafka_url" -O kafka.tgz || { echo "下载失败，请到 https://downloads.apache.org/kafka or https://mirrors.aliyun.com/apache/kafka 检查版本号！"; return 1; }

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
zookeeper.connect=localhost:$ZOOKEEPER_PORT
listeners=PLAINTEXT://0.0.0.0:$KAFKA_PORT
advertised.listeners=PLAINTEXT://localhost:$KAFKA_PORT
EOF

    echo "Kafka ${version} 安装完成！"
}

function install_zookeeper() {
    local version="3.9.3" # 默认版本
    read -p "请输入 Zookeeper 版本（默认 ${version}）：" input_version
    version=${input_version:-$version}

    read -p "是否使用国内镜像源下载 Zookeeper？(y/n, 默认 y )：" use_mirror
    use_mirror=${use_mirror:-y}


    # 设置下载 URL
    if [[ "$use_mirror" == "y" || "$use_mirror" == "Y" ]]; then
        # 使用国内镜像源（例如阿里云）
        local zookeeper_url="https://mirrors.aliyun.com/apache/zookeeper/zookeeper-${version}/apache-zookeeper-${version}-bin.tar.gz"
    else
        # 使用官方下载地址
        local zookeeper_url="https://downloads.apache.org/zookeeper/zookeeper-${version}/apache-zookeeper-${version}-bin.tar.gz"
    fi

    echo "下载并安装 Zookeeper ${version}..."
    wget "$zookeeper_url" -O zookeeper.tgz || { echo "下载失败，请到 https://mirrors.aliyun.com/zookeeper/zookeeper or https://downloads.apache.org/zookeeper/zookeeper 检查版本号！"; return 1; }

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

#!/bin/bash



# 检查 Kafka 是否正常工作
check_kafka() {
    kafka_status=$(netstat -tuln | grep ":$KAFKA_PORT" | wc -l)
    if [ "$kafka_status" -gt 0 ]; then
        echo "Kafka is running on port $KAFKA_PORT"
    else
        echo "Kafka is not running on port $KAFKA_PORT"
    fi
}

# 检查 Zookeeper 是否正常工作
check_zookeeper() {
    zookeeper_status=$(netstat -tuln | grep ":$ZOOKEEPER_PORT" | wc -l)
    if [ "$zookeeper_status" -gt 0 ]; then
        echo "Zookeeper is running on port $ZOOKEEPER_PORT"
    else
        echo "Zookeeper is not running on port $ZOOKEEPER_PORT"
    fi
}

# 检查 Kafka 的可用性（通过 kafka-topics.sh）
check_kafka_availability() {
    kafka_topics=$(./bin/kafka-topics.sh --list --bootstrap-server $KAFKA_HOST:$KAFKA_PORT 2>&1)
    if [[ $kafka_topics == *"Error"* ]]; then
        echo "Kafka is not working properly"
    else
        echo "Kafka is running properly, available topics:"
        echo "$kafka_topics"
    fi
}

# 检查 Zookeeper 的可用性（通过 zkCli.sh）
function check_zookeeper_availability() {
    zk_status=$(echo "stat" | ./bin/zkCli.sh -server $ZOOKEEPER_HOST:$ZOOKEEPER_PORT)
    if [[ $zk_status == *"Mode"* ]]; then
        echo "Zookeeper is running properly"
    else
        echo "Zookeeper is not running properly"
    fi
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

function check_kafka_and_zookeeper_status() {
    check_kafka
    check_zookeeper
    check_kafka_availability
    check_zookeeper_availability
}


function apt_update_and_install_util() {
    echo "更新apt..."
    sudo apt update
    echo "更新apt！"

    # 定义安装包名的数组
    local packages=("iptables" "net-tools" "curl" "wget" "vim" "telnet" "htop" "nmap")

    # 循环遍历每个包，检查是否已安装并询问用户是否安装
    for package in "${packages[@]}"; do
        # 检查包是否已安装
        if dpkg -l | grep -q "$package"; then
            echo "$package 已安装，跳过安装。"
        else
            # 询问用户是否安装
            read -p "是否安装 $package (默认不安装, 输入 y 安装): " install_package
            if [[ "$install_package" == "y" || "$install_package" == "Y" ]]; then
                echo "安装 $package..."
                sudo apt install "$package" -y
                echo "$package 安装完毕！"
            else
                echo "跳过安装 $package"
            fi
        fi
    done
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

#!/bin/bash

# 定义一个方法来展示环境信息
function show_system_info() {
    echo "=========== 系统环境信息 ==========="

    # 获取并显示主机名
    echo "主机名: $(hostname)"

    # 获取并显示当前用户名
    echo "当前用户名: $(whoami)"

    # 获取并显示 IP 地址（适用于 WSL）
    wsl_ip=$(hostname -I | awk '{print $1}')
    if [[ -z "$wsl_ip" ]]; then
        # 如果没有获取到有效的 IP 地址，返回 localhost
        wsl_ip="localhost"
    fi
    echo "本机 IP 地址: $wsl_ip"

    # 获取并显示操作系统信息
    echo "操作系统: $(uname -s)"
    echo "内核版本: $(uname -r)"

    # 获取并显示 CPU 信息
    echo "CPU 信息: $(lscpu | grep 'Model name')"

    # 获取并显示内存信息
    echo "内存信息: $(free -h)"

    # 获取并显示磁盘使用情况
    echo "磁盘使用情况:"
    df -h

    # 获取并显示当前时间
    echo "当前时间: $(date)"

    # 获取并显示网络连接状态
    echo "网络连接状态:"
    netstat -tuln
}




function manager_menu_loop() {
    while true; do
        manager_menu
        read -r manager_menu_choice
        case $manager_menu_choice in
        1) manager_jdk_menu_loop ;;
        2) manager_kafka_menu_loop ;;
        3) manager_zookeeper_menu_loop ;;
        4) manager_docker_menu_loop ;;
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
}


# 主菜单循环
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
