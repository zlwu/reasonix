# reasonix

通用 `Reasonix` 运行镜像仓库。

这个仓库只负责：

- 构建通用 `reasonix` 运行镜像
- 通过 GitHub Actions 推送到 `ghcr.io`
- 提供通用、脱敏的使用说明

这个仓库不负责：

- 存放任何真实 `stack.yml`
- 存放真实域名、节点约束、卷路径
- 存放 API Key、飞书密钥、配对状态

## 镜像内容

- 基础镜像：`node:24-bookworm-slim`
- 系统工具：`tini`、`bash`、`curl`、`git`、`python3`、`ripgrep`、`procps`
- `Reasonix`：通过 `npm install -g reasonix` 安装固定版本

默认镜像标签：

- `ghcr.io/<owner>/reasonix:main`
- `ghcr.io/<owner>/reasonix:sha-<shortsha>`
- `ghcr.io/<owner>/reasonix:<git-tag>`（发布 tag 时）

## 本地构建

```bash
docker build -t reasonix:local .
docker run --rm -it reasonix:local reasonix version
```

## 运行示例

只跑飞书 bot：

```bash
docker run --rm \
  -v "$PWD/home/.reasonix:/home/reasonix/.reasonix" \
  -v "$PWD/workspace:/workspace" \
  ghcr.io/<owner>/reasonix:main \
  reasonix bot start --channels feishu --dir /workspace
```

## 发布约定

- `main` 分支 push：构建并推送 `:main`
- 手工触发：构建并推送 `:main`
- 每周定时重建：吸收基础镜像和 Debian 安全更新
- Git tag：额外推送同名版本 tag

现网部署文件请放在私有运维仓库或目标节点的 `/opt/stacks/<app>/` 目录，不要放回这里。
