
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

# 检查 Zookeeper 是否正常工作
function check_zookeeper() {
    zookeeper_status=$(netstat -tuln | grep ":$ZOOKEEPER_PORT" | wc -l)
    if [ "$zookeeper_status" -gt 0 ]; then
        echo "Zookeeper is running on port $ZOOKEEPER_PORT"
    else
        echo "Zookeeper is not running on port $ZOOKEEPER_PORT"
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
