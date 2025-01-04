function check_env_menu() {
    echo "=========================="
    echo "环境变量"
    echo "=========================="
    echo "1. 展示系统信息"
    echo "2. 展示组件信息"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


function check_env_loop() {
    while true; do
        check_env_menu
        read -r check_env_menu_choice
        case $check_env_menu_choice in
        1) show_system_info ;;
        2) show_components_info ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}