#!/bin/bash

# 定义拆分的脚本文件列表
SCRIPTS=("scripts/test/configure_files.sh" "scripts/test/install_dependencies.sh")

# 创建一个新的整合脚本文件
OUTPUT_FILE="scripts/core/component_manager.sh"
> $OUTPUT_FILE  # 清空文件内容

# 合并所有脚本
for SCRIPT in "${SCRIPTS[@]}"; do
  # 追加每个脚本的内容到主脚本
  cat $SCRIPT >> $OUTPUT_FILE
  # 在脚本之间添加换行以分隔
  echo -e "\n" >> $OUTPUT_FILE
done

# 赋予执行权限
chmod +x $OUTPUT_FILE
