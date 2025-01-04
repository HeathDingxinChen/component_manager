

# 主菜单循环
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




# 主菜单循环
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


