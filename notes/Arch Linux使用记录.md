# 系统时间与世界时间一致

```bash
sudo timedatectl set-ntp true
```

> 不用重启

# 微信添加中文输入支持

```bash
如果无法输入中文，则需要从菜单编辑器为其添加环境变量QT_IM_MODULE，比如：QT_IM_MODULE=fcitx（不是fcitx5）或QT_IM_MODULE=ibus。 如果高分辨率比例有问题，也可以从菜单编辑器中为其增加环境变量QT_AUTO_SCREEN_SCALE_FACTOR=1（自动缩放），或者设置指定的缩放比例QT_SCALE_FACTOR，比如QT_SCALE_FACTOR=1.5（两个变量不要同时设置）。 微信目前尚不支持从原生wayland启动，如果从菜单无法启动，从命令行启动出现'wechat' terminated by signal SIGSEGV (Address boundary error)错误的，需要添加环境变量'QT_QPA_PLATFORM=wayland;xcb'（注意必须有单引号）。从4.0.0.30-2起默认已经加了这个变量，但如果在更新到此版本之前，~/.local/share/applications/wechat.desktop已经存在了则需要你自己手动从菜单编辑器或直接编辑该文件添加一下。 如果系统没有菜单编辑器，也可以自行将/usr/share/applications/wechat.desktop复制为~/.local/share/applications/wechat.desktop（菜单编辑器其实修改的也是家目录下的这个文件），然后编辑Exec=所在行，比如设置输入法为fcitx、设置自动缩放并添加x11支持：Exec=env QT_IM_MODULE=fcitx QT_AUTO_SCREEN_SCALE_FACTOR=1 'QT_QPA_PLATFORM=wayland;xcb' /usr/bin/wechat %U。 对于多屏幕且屏幕分辨率不一致的，可以设置环境变量QT_AUTO_SCREEN_SCALE_FACTOR=1（自动缩放），也可以设置QT_SCREEN_SCALE_FACTORS手动指定不同屏幕不同的缩放比例，比如'QT_SCREEN_SCALE_FACTORS=1;1.5'（注意必须有单引号，且XXXX_SCALE_FACTOR的3个变量不要同时设置），表示第一块屏幕的显示比例是100%，第二块屏幕的显示比例是150%。 如果安装了中文字体仍然出现乱码，请自行按上述方式添加环境变量LANG=zh_CN.UTF-8。 添加或调整环境变量后需要退出微信并重新从菜单打开方可生效。
```

# Typora添加增强插件

> 官方仓库: https://github.com/obgnail/typora_plugin?tab=readme-ov-file (已star)

1. 下载[typora-plugin@v1.13.0.zip](https://github.com/obgnail/typora_plugin/releases/download/1.13.0/typora-plugin@v1.13.0.zip)并解压
2. 进入 Typora 安装路径，找到包含 `window.html` 的文件夹, 将解压内容移动到文件夹中并运行对应脚本文件

   ```bash
   cd /usr/share/typora/resources
   sudo mv /home/rani/Downloads/plugin ./ 
   cd plugin/bin
   sudo bash install_linux.sh
   ```

   出现 `plugin install successfully`即为成功

# github配置lfs

在 Arch Linux 上安装 `git-lfs`（Git Large File Storage）非常简单。以下是具体步骤：

### 1. 使用 `pacman` 安装 `git-lfs`

`git-lfs` 已经在 Arch Linux 的官方仓库中提供，可以直接通过 `pacman` 安装：

```bash
sudo pacman -S git-lfs
```

### 2. 初始化 `git-lfs`

安装完成后，需要在 Git 仓库中初始化 `git-lfs`：

```bash
git lfs install
```

这会为当前用户启用 `git-lfs`。

### 3. 配置 `git-lfs` 跟踪大文件

在 Git 仓库中，使用以下命令来指定需要跟踪的大文件类型。例如，跟踪所有 `.psd` 文件：

```bash
git lfs track "*.pdf"
```

这会在仓库中生成或更新一个 `.gitattributes` 文件，记录需要跟踪的文件类型。

> 注意:如果设置了 `git lfs track "*.pdf"`，**所有的 PDF 文件**（无论大小）都会被 Git LFS 跟踪并上传到 LFS 存储中，而不仅仅是大于某个大小的文件。
>
> 如果你希望只跟踪大于某个大小的文件，可以手动指定文件路径 `git lfs track "a.pdf"`或者使用脚本来排除小文件。
>
> ```bash
> find . -name "*.*" -size +100M | while read file; do
>   git lfs track "$file"
> done
> ```
>
> 在git add之前添加这个命令,实现对大文件的自动跟踪
>
> - 不会重复添加相同文件,哪怕搜索到.git中的文件,也不会将.git中的文件进行跟踪
> - 可以在 `.gitattributes`中查看结果

### 4. 检查 `git-lfs` 状态

你可以通过以下命令检查 `git-lfs` 的跟踪状态：

```bash
git lfs status
```

### 5. 提交更改

将 `.gitattributes` 文件和跟踪的大文件添加到 Git 仓库并提交：

```bash
git add .gitattributes
git add your_large_file.psd
git commit -m "Track large files with git-lfs"
git push origin main
```

### 6. 验证 `git-lfs` 是否正常工作

你可以通过以下命令查看 `git-lfs` 是否成功跟踪了大文件：

```bash
git lfs ls-files
```

修改DNS加快网页访问速度：

https://zhuanlan.zhihu.com/p/16358873098

```
sudo vim /etc/hosts

20.205.243.166 github.com
```

 3807  paru -S bind
 3808  nslookup github.com
 3809  nslookup github.global.ssl.fastly.net

### 7.阻止特定软件包更新

在 Arch Linux 中，可以通过 `pacman` 的配置或工具来阻止特定软件包的更新。以下是几种常用方法：

方法 1：使用 `IgnorePkg`（推荐）

编辑 `/etc/pacman.conf`，在 `[options]` 部分添加 `IgnorePkg` 指令：

```ini
[options]
IgnorePkg = 软件包名1 软件包名2
```

保存后，`pacman -Syu` 将跳过这些包的更新。

**注意**：
• 需要手动编辑配置文件，确保包名拼写正确。
• 适用于全局禁用更新（对所有用户生效）。

方法 2：使用 `--ignore` 参数（临时忽略）

在命令行中临时忽略某个包的更新：

```bash
sudo pacman -Syu --ignore 软件包名
```

**适用场景**：仅一次性地跳过更新。
