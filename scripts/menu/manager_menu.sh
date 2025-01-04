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



