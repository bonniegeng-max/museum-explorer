#!/usr/bin/env bash
# museum-explorer 一键发布脚本（GitHub + ClawHub）
# 用法:  ./publish.sh <你的GitHub个人访问令牌>
# 令牌生成: https://github.com/settings/tokens → 勾选 repo 权限（Fine-grained 需 Contents: Read and write）
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
git push -u origin main
echo ""
echo "[OK] GitHub 推送完成: https://github.com/${REPO}"

# ---------- 2. ClawHub 发布 ----------
if command -v openclaw >/dev/null 2>&1; then
  echo "[INFO] 检测到 openclaw，尝试发布到 ClawHub..."
  openclaw skills publish || echo "[WARN] ClawHub 发布未完成，请先运行: openclaw auth login"
else
  echo "[WARN] 未安装 openclaw CLI，请先安装后运行:"
  echo "       npm install -g openclaw --registry=https://mirrors.tencent.com/npm/"
  echo "       openclaw auth login && openclaw skills publish"
fi
