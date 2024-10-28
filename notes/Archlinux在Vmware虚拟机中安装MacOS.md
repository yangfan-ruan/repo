# Archlinux在Vmware虚拟机中安装MacOS

### 环境

> [Install Macos on Vmware on Arch Linux](https://blog.csdn.net/robin912/article/details/81225570?ops_request_misc=&request_id=&biz_id=102&utm_term=Arch%20Linux%E5%AE%89%E8%A3%85macos%E8%99%9A%E6%8B%9F%E6%9C%BA&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-81225570.142^v100^pc_search_result_base9&spm=1018.2226.3001.4187)

- macos 系统盘 [链接](https://pan.baidu.com/s/1eSGmiwq)　密码: 2zk6

### Vmware安装

> [Package Details: vmware-workstation 17.6.1-2](https://aur.archlinux.org/packages/vmware-workstation)

```bash
paru -S vmware-workstation
sudo pacman -S linux-headers  #  linux-headers for default kernel, linux-lts-headers for LTS kernel
sudo modprobe -a vmw_vmci vmmon # or reboot
sudo systemctl enable vmware-networks.service
sudo systemctl enable vmware-usbarbitrator.service
```

注意: 最好在bios中修改禁用安全引导(secure boot)

### MacOS安装

#### 先使vmware支持macos

> [Package Details: vmware-unlocker-bin 4.2.5-1](https://aur.archlinux.org/packages/vmware-unlocker-bin)

```bash
paru -S vmware-unlocker-bin
```

#### 再像在vmware中安装win10一样进行操作

大概率依次遇见如下报错

##### 报错1: `The CPU has been disabled by the guest operating system. Power off or reset the virtual machine.`

>  [vmware安装苹果虚拟机卡在苹果图标位置不动](https://blog.csdn.net/feinifi/article/details/125151747?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522C3B7DD8F-1D78-40CE-8561-16C3E9EB75A9%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=C3B7DD8F-1D78-40CE-8561-16C3E9EB75A9&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~top_positive~default-1-125151747-null-null.nonecase&utm_term=The%20CPU%20Has%20Been%20Disabled%20by%20the%20Guest%20Operating%20System&spm=1018.2226.3001.4450) (重点关注评论)
>
> [查找.vmx路径方法](https://www.partitionwizard.com/clone-disk/cpu-has-been-disabled-by-the-guest-operating-system.html)

amd添加如下内容:

```bash
smc.version = "0"
cpuid.0.eax = "0000:0000:0000:0000:0000:0000:0000:1011"
cpuid.0.ebx = "0111:0101:0110:1110:0110:0101:0100:0111"
cpuid.0.ecx = "0110:1100:0110:0101:0111:0100:0110:1110"
cpuid.0.edx = "0100:1001:0110:0101:0110:1110:0110:1001"
cpuid.1.eax = "0000:0000:0000:0001:0000:0110:0111:0001"
cpuid.1.ebx = "0000:0010:0000:0001:0000:1000:0000:0000"
cpuid.1.ecx = "1000:0010:1001:1000:0010:0010:0000:0011"
cpuid.1.edx = "0000:0111:1000:1011:1111:1011:1111:1111"
smbios.reflectHost = "TRUE"
hw.model = "MacBookPro14,3"
board-id = "Mac-551B86E5744E2388"
```

##### 报错2: 鼠标键盘无法使用

> [使用VMware 安装mac os系统 遇到鼠标键盘无法使用的问题](https://blog.csdn.net/zhoupian/article/details/122659135?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522829CBCBD-A2F6-4B96-90F8-5D21E9C840B8%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=829CBCBD-A2F6-4B96-90F8-5D21E9C840B8&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-122659135-null-null.nonecase&utm_term=vmware%E5%AE%89%E8%A3%85macos%E6%97%A0%E6%B3%95%E4%BD%BF%E7%94%A8%E9%BC%A0%E6%A0%87%E6%88%96%E9%94%AE%E7%9B%98&spm=1018.2226.3001.4450)

1. 先关闭虚拟机。

2. 在虚拟机的安装目录下找到xxx.vmx，用文本编辑器打开，在其中添加：

   ```bash
   keyboard.vusb.enable = "TRUE"
   mouse.vusb.enable = "TRUE"
   ```

3. 点击VMware Workstation菜单里的“虚拟机”->"设置"，进入“虚拟机设置”界面，选择“硬件”标签页的“USB控制器”，在左侧的界面里勾选“显示所有USB输入设备（S）”，并把顶部的“USB兼容性（C）”改为USB2.0。

4. 重启虚拟机，可能你的鼠标和键盘就可以用了！

##### 报错3: `there is not enough space on OS X Base System to install`

> [VMware: there is not enough space on OS X Base System to install](https://blog.csdn.net/jimmyleeee/article/details/105205723?ops_request_misc=&request_id=&biz_id=102&utm_term=vmware%E5%AE%89%E8%A3%85macos%E6%8A%A5%E9%94%99there%20is%20not%20en&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~sobaiduweb~default-0-105205723.nonecase&spm=1018.2226.3001.4450)

#### 最后安装成功后可自动联网

#### arch与macos添加共享文件夹

> [VMware安装macOS High Sierra 10.13苹果系统并设置共享文件夹详细教程（图文）](https://blog.csdn.net/qq_30386941/article/details/126457834?ops_request_misc=%257B%2522request%255Fid%2522%253A%25223BA2D8B6-2C1C-45B2-A98A-BECA11B03EEC%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=3BA2D8B6-2C1C-45B2-A98A-BECA11B03EEC&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-6-126457834-null-null.142^v100^pc_search_result_base9&utm_term=macos%E8%99%9A%E6%8B%9F%E6%9C%BA%E8%AE%BE%E7%BD%AE%E5%85%B1%E4%BA%AB%E6%96%87%E4%BB%B6%E5%A4%B9&spm=1018.2226.3001.4187)

- 与上述链接中操作相同,只需要把win10中的路径改成arch中文件路径
- 如果桌面有镜像需要先取消挂载再安装`vmare tools`




> https://sysin.org/blog/macOS-Sequoia/#1-ISO-%E6%A0%BC%E5%BC%8F%E8%BD%AF%E4%BB%B6%E5%8C%85-%E6%8E%A8%E8%8D%90-3