function manager_docker_menu() {
    echo "=========================="
    echo "配置环境"
    echo "=========================="
    echo "1. 安装docker"
    echo "2. 卸载docker"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_docker_menu_loop() {
    while true; do
        manager_docker_menu
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


