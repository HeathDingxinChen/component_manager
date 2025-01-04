function manager_kafka_menu() {
    echo "=========================="
    echo "管理Kafka"
    echo "=========================="
    echo "1. 安装Kafka"
    echo "2. 卸载Kafka"
    echo "3. 检查Kafka安装状态"
    echo "4. 注册Kafka服务"
    echo "5. 卸载Kafka服务"
    echo "6. 启动Kafka服务"
    echo "7. 停止Kafka服务"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function manager_kafka_menu_loop() {
    while true; do
        manager_kafka_menu
        read -r manager_kafka_menu_loop
        case $manager_kafka_menu_loop in
        1) install_kafka ;;
        2) uninstall_kafka ;;
        3) check_kafka_installed ;;
        4) register_kafka_service ;;
        5) unregister_kafka_service ;;
        6) enable_kafka_service ;;
        7) disable_kafka_service ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}