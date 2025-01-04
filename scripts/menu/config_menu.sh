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

