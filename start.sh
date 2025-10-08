#!/bin/bash

# 初始化数据库（如果需要）
if [ ! -z "$DATABASE_URL" ]; then
    echo "Database configuration detected"
fi

# 启动应用
cd server && python3 app.py
