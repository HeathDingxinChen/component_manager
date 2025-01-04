
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




# 检查 Kafka 是否正常工作
function check_kafka() {
    kafka_status=$(netstat -tuln | grep ":$KAFKA_PORT" | wc -l)
    if [ "$kafka_status" -gt 0 ]; then
        echo "Kafka is running on port $KAFKA_PORT"
    else
        echo "Kafka is not running on port $KAFKA_PORT"
    fi
}

# 检查 Kafka 的可用性（通过 kafka-topics.sh）
function check_kafka_availability() {
    kafka_topics=$(./bin/kafka-topics.sh --list --bootstrap-server $KAFKA_HOST:$KAFKA_PORT 2>&1)
    if [[ $kafka_topics == *"Error"* ]]; then
        echo "Kafka is not working properly"
    else
        echo "Kafka is running properly, available topics:"
        echo "$kafka_topics"
    fi
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