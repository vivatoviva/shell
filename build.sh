#！/bin/bash

# npm run build
# 保存登录服务器的用户名
read -p '请填写你登录服务器的用户名 ->: ' NAME
# 填写登录远程服务器的ip
read -p '请填写你登录服务器的远程ip ->: ' IP
# 远程地址
read -p '请填写你将静态资源放置地址 ->: ' ADDRESS

touch dist.tar

# 传文件至远程服务器
scp dist.tar $NAME@$IP:$ADDRESS;

echo $NAME
echo $IP
echo $ADDRESS
exit 0
