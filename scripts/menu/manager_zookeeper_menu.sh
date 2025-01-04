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