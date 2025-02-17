## frp内网穿透

### 参考链接

> - [frp中文文档](https://gofrp.org/zh-cn/)
> - [GitHub frp Release](https://github.com/fatedier/frp/releases)

### 目标

使用有公网的服务器(ubuntu,做服务器端)访问内网的电脑(archlinux,做客户端)

1. 将 `frpc` 复制到内网服务所在的机器上。
2. 将 `frps` 复制到拥有公网 IP 地址的机器上，并将它们放在任意目录。

### 安装

client 上可直接从aur中安装frpc

```
paru -S frpc
```

server上需从[github仓库](https://github.com/fatedier/frp/releases)中下载合适的二进制包

### 运行

#### 客户端frpc

1. 修改frpc.toml文件(可以使用find命名寻找)，设置serverAddr为frps的公网IP地址

    ```
    # frpc.toml  
    serverAddr = "118.xx.xx.xx"  #服务器公网ip
    serverPort = 5000  #服务器frps.toml中的bindPort
    
    [[proxies]]  
    name = "ssh"  
    type = "tcp"  
    localIP = "127.0.0.1"  
    localPort = 22  
    remotePort = 2333 #最后想通过ssh连接的端口
    ```

2. 启动frpc

    ```
    sudo chmod +r frpc.toml #先添加权限
    sudo frpc -c ./frpc.toml
    ```

3. 设置后台启动与开机自启

   - systemctl建立链接

   ```
   systemctl enable frpc
   ```

   输出类似如下

   ```
   Created symlink /etc/systemd/system/multi-user.target.wants/frpc.service → /usr/lib/systemd/system/frpc.service.
   ```

     - 修改`/usr/lib/systemd/system/frpc.service.`

          ```
       cat /usr/lib/systemd/system/frpc.service    
       [Unit]
       Description=Frp Client Service
       After=network-online.target
       Wants=network-online.target
       
       [Service]
       Type=simple
       User=rani #注意这里原来是nobody, 会报错最好改成自己的用户名
       Restart=on-failure
       RestartSec=5s
       ExecStart=/usr/bin/frpc -c /etc/frp/frpc.toml
       ExecReload=/usr/bin/frpc reload -c /etc/frp/frpc.toml
       
       [Install]
       WantedBy=multi-user.target
          ```


     - 检查ssh是否开机,如果没有需要设置

       ```
       sudo systemctl enable sshd
       sudo systemctl restart sshd
       sudo systemctl status sshd
       ```

       出现绿色“**active (running)**”, ssh状态正常

     - 启动并检查frpc

       ```
       systemctl start frpc
       systemctl status frpc
       ```

       出现绿色“**active (running)**”, frpc状态正常

#### 服务器端frps

1. 修改server上的frps.toml文件来设置frp client连接的端口

   ```
   # frps.toml
   bindPort = 5000
   ```

2. server上启动frps

   ```
   sudo chmod +r frps.toml #先添加权限
   sudo ./frps -c ./frps.toml
   ```

3. 设置后台启动(服务器不用开机器自启)

   - 手动创建service文件

     ```
     sudo vim /etc/systemd/system/frps_rani.service # 由于服务器上默认名称frps.service这个名称已经被其他用户使用,因此使用了自定义名称
     ```

     添加如下内容

     ```
     [Unit]
     Description=frps (Rani Instance) # 可以更换,方便识别即可
     After=network.target
     
     [Service]
     Type=simple
     WorkingDirectory=/home/rani/rani_config/frp_0.61.1_linux_amd64/ #包含frps.toml与frps的文件夹
     ExecStart=/home/rani/rani_config/frp_0.61.1_linux_amd64/frps -c ./frps.toml # frps路径 -c ./frps.toml
     ExecStop=/bin/kill -TERM $MAINPID
     Restart=always
     RestartSec=10s
     
     [Install]
     WantedBy=multi-user.target
     ```

   - 加载服务

     ```
     sudo systemctl daemon-reload
     sudo systemctl enable frps_rani # 与frps_rani.service名称对应
     sudo systemctl start frps_rani # 与frps_rani.service名称对应
     sudo systemctl status frps_rani # 与frps_rani.service名称对应
     ```

     出现绿色“**active (running)**”, frps状态正常

4. 访问frpc

   ```
   ssh -oPort=2333 rani@127.0.0.1 # 端口即为frpc.toml中的remotePort 注意这里的地址必须是127.0.0.1, 不能写公网ip
   ```