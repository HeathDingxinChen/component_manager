# 停止 Kafka
function disable_firewall() {
    echo "停止 防火墙..."
    sudo ufw disable
    echo "防火墙 已停止！"
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


