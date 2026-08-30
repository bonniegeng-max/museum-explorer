#!/usr/bin/env bash
# museum-explorer 一键发布脚本（GitHub 推送）
# 用法:  ./publish.sh <你的GitHub个人访问令牌>
# 令牌生成: https://github.com/settings/tokens → Generate new token (classic) → 勾选 repo 权限
#          （Fine-grained 令牌需给仓库 Contents: Read and write 权限）
set -e
TOKEN="${1:?用法: ./publish.sh <GITHUB_TOKEN>}"
REPO="bonniegeng-max/museum-explorer"
cd "$(dirname "$0")"

# ---------- 1. GitHub 推送 ----------
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "https://oauth2:${TOKEN}@github.com/${REPO}.git"
else
  git remote add origin "https://oauth2:${TOKEN}@github.com/${REPO}.git"
fi

# 远程仓库是旧版 v1.0 历史，本地 v1.2.0 是完整重写（内容超集），因此 force 覆盖
echo "[INFO] 推送 v1.2.0 并覆盖远程旧历史..."
git push -u origin main --force
echo ""
echo "[OK] GitHub 推送完成: https://github.com/${REPO}"
echo "     对应 commit: $(git rev-parse --short HEAD)（与 ClawHub release 标注的源 commit 一致）"

# ---------- 2. ClawHub 状态 ----------
echo ""
echo "[INFO] ClawHub: v1.2.0 已于 2026-08-30 提交发布（含安全扫描）。"
echo "       查看: https://clawhub.ai/bonniegeng-max/museum-explorer"
echo "       今后更新版本（需 clawhub CLI）: clawhub skill publish . --slug museum-explorer --owner bonniegeng-max --version x.y.z"
