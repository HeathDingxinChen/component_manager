
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

