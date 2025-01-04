function main_menu() {
    echo "=========================="
    echo "组件管理脚本 By Heath"
    echo "version: v24458a8"
    echo "updateTime: 2025-01-05 01:06:25"
    echo "=========================="
    echo "1. 管理组件"
    echo "2. 配置环境"
    echo "3. 一键启动"
    echo "4. 环境变量"
    echo "8. 重载脚本"
    echo "9. 退出"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}


while true; do
    main_menu
    read -r main_menu_choice
    case $main_menu_choice in
    1) manager_menu_loop ;;
    2) config_menu_loop ;;
    3) bootup_menu_loop ;;
    4) check_env_loop ;;
    9) exit 0 ;;
    *) echo "无效选项，请重试！" ;;
    esac
done
