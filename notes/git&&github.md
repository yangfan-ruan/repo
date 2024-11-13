> Learning Git Branching游戏: https://learngitbranching.js.org/?demo=&locale=zh_CN

# 基础命令

```bash
```



# 取消提交并移除超过100MB大文件

报错：

```bash
remote: error: Trace: a2b24628c745ae5f4dbb75f4acf008a72509ced934fea35184f1c9b012c43884
remote: error: See https://gh.io/lfs for more information.
remote: error: File books/C++20高级编程(第5版)(上下册） ([比]马克·格雷戈勒（Marc Gregoire）) (Z-Library).pdf is 142.29 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To github.com:yangfan-ruan/repo.git
 ! [remote rejected] main -> main (pre-receive hook declined)
```

报错提示提交的文件 `books/C++20高级编程(第5版)(上下册）` 大小超过 100 MB 的限制，因此提交被拒绝。可以按照以下步骤取消这次提交，并重新提交不包含大文件的更改。

### 1. **取消提交并移除大文件**
可以使用以下命令来取消最近一次提交：

```bash
git reset --soft HEAD~1
```

这个命令会将最近一次提交撤销，但保留工作目录的文件状态。撤销后，可以选择删除大文件。

### 2. **从暂存区移除大文件**
使用以下命令将大文件从 Git 的暂存区中移除，但不从工作目录删除文件：

```bash
git rm --cached "books/C++20高级编程(第5版)(上下册） ([比]马克·格雷戈勒（Marc Gregoire）) (Z-Library).pdf"
```

### 3. **重新提交**
在移除了大文件之后，可以重新提交修改：

```bash
git commit -m "Remove large PDF file from commit"
```

### 4. **重新推送**
现在可以将修改重新推送到远程仓库：

```bash
git push origin main --force
```

