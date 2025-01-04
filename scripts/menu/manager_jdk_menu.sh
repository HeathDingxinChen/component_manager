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
