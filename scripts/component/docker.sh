
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
