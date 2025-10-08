# Railway 部署指南 - 币安斗地主

## 快速部署步骤

### 1. 准备工作
- 注册 [Railway.app](https://railway.app) 账号（可用GitHub登录）
- 将代码推送到 GitHub 仓库

### 2. 创建 Railway 项目

#### 方式一：通过 Railway Dashboard（推荐）

1. 登录 Railway，点击 **"New Project"**
2. 选择 **"Deploy from GitHub repo"**
3. 选择你的 `doudizhu` 仓库
4. Railway 会自动检测 Python 项目并开始部署

#### 方式二：使用 Railway CLI

```bash
# 安装 Railway CLI
npm install -g @railway/cli

# 登录
railway login

# 初始化项目
railway init

# 部署
railway up
```

### 3. 添加 MySQL 数据库

1. 在 Railway 项目中点击 **"+ New"**
2. 选择 **"Database" → "MySQL"**
3. Railway 会自动创建 MySQL 实例并提供连接信息

### 4. 配置环境变量

在 Railway 项目的 **"Variables"** 标签页添加：

```bash
# 数据库连接（Railway会自动提供MYSQL_URL，需转换格式）
DATABASE_URI=mysql+aiomysql://用户名:密码@主机:端口/数据库名

# 或者使用 Railway 提供的变量（推荐）
DATABASE_URI=mysql+aiomysql://${{MYSQLUSER}}:${{MYSQLPASSWORD}}@${{MYSQLHOST}}:${{MYSQLPORT}}/${{MYSQLDATABASE}}

# 端口（Railway自动提供）
PORT=${{PORT}}

# 密钥（可选，用于安全加密）
SECRET_KEY=你的随机密钥字符串
```

### 5. 初始化数据库

Railway 部署后，需要手动初始化数据库表：

**方法一：使用 Railway Shell**
```bash
# 在 Railway Dashboard 中打开 Shell
railway shell

# 连接数据库并执行
mysql -h $MYSQLHOST -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE < schema.sql
```

**方法二：本地连接 Railway 数据库**
```bash
# 获取数据库连接信息
railway variables

# 本地执行
mysql -h [MYSQLHOST] -u [MYSQLUSER] -p[MYSQLPASSWORD] [MYSQLDATABASE] < schema.sql
```

### 6. 访问应用

部署成功后，Railway 会提供一个公网域名，例如：
```
https://你的项目名.up.railway.app
```

## 配置文件说明

项目已包含以下Railway配置文件：

- **railway.json** - Railway 项目配置
- **nixpacks.toml** - Nixpacks 构建配置（指定 Python 和 MySQL）
- **start.sh** - 启动脚本

## 注意事项

### 1. 免费额度
- Railway 提供 **$5 免费额度/月**
- 足够运行小型游戏应用

### 2. 机器人模式
- 游戏默认开启机器人对战（`allow_robot = True`）
- 无需多个真人玩家，单人即可游戏

### 3. 数据持久化
- Railway MySQL 数据会持久化保存
- 建议定期备份数据库

### 4. WebSocket 支持
- Railway 完全支持 WebSocket 连接
- 游戏实时通信功能正常

## 故障排查

### 部署失败
```bash
# 查看部署日志
railway logs
```

### 数据库连接失败
- 检查 `DATABASE_URI` 格式是否正确
- 确认数据库服务是否启动
- 验证数据库表是否已创建

### 端口问题
- Railway 会自动分配 `PORT` 环境变量
- 代码已配置读取环境变量：`PORT = int(os.getenv('PORT', 8080))`

## 本地测试 Railway 环境

```bash
# 安装依赖
pip install -r requirements.txt

# 设置环境变量
export DATABASE_URI="mysql+aiomysql://root:密码@localhost:3306/ddz"
export PORT=8080

# 运行
cd server && python3 app.py
```

## 更新部署

代码更新后，只需推送到 GitHub：

```bash
git add .
git commit -m "更新代码"
git push
```

Railway 会自动检测并重新部署。

## 自定义域名（可选）

1. 在 Railway 项目 **"Settings"** → **"Domains"**
2. 添加自定义域名
3. 配置 DNS CNAME 记录

---

## 支持

如有问题，参考：
- [Railway 文档](https://docs.railway.app)
- [项目 GitHub](https://github.com/mailgyc/doudizhu)
