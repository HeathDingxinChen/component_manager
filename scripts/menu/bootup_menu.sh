function bootup_menu() {
    echo "=========================="
    echo "一键启动"
    echo "=========================="
    echo "1. 启动Kafka & Zookeeper"
    echo "2. 关闭Kafka & Zookeeper"
    echo "3. 检查Kafka & Zookeeper"
    echo "9. 返回上一级菜单"
    echo "=========================="
    echo -n "请输入选项 [1-9]: "
}

function bootup_menu_loop() {
    while true; do
        bootup_menu
        read -r bootup_menu_choice
        case $bootup_menu_choice in
        1) bootup_kafka_and_zookeeper ;;
        2) stop_kafka_and_zookeeper ;;
        3) check_kafka_and_zookeeper_status ;;
        9) return ;;  # 返回主菜单
        *) echo "无效选项，请重试！" ;;
        esac
    done
}


function bootup_kafka_and_zookeeper() {
    echo "启动 Zookeeper..."
    mkdir -p $ZOOKEEPER_DIR
    nohup $KAFKA_DIR/bin/zookeeper-server-start.sh $KAFKA_DIR/config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &
    echo "Zookeeper 启动完成！"

    echo "启动 Kafka..."
    nohup $KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties > /tmp/kafka.log 2>&1 &
    echo "Kafka 启动完成！"
}

function stop_kafka_and_zookeeper() {
    echo "停止 Zookeeper..."
    pkill -f "zookeeper-server-start"
    echo "Zookeeper 已停止！"

    echo "停止 Kafka..."
    pkill -f "kafka-server-start"
    echo "Kafka 已停止！"
}


function check_kafka_and_zookeeper_status() {
    check_kafka
    check_zookeeper
    check_kafka_availability
    check_zookeeper_availability
}

