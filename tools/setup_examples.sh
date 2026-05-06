#!/bin/bash
# 在仓库根目录运行：bash tools/setup_examples.sh
# 依赖：flutter 命令已在 PATH 中
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "=========================================="
echo " fluwx monorepo — example 初始化脚本"
echo "=========================================="
echo ""

# ──────────────────────────────────────────────
# 1. 用 flutter create 生成两个 example 脚手架
# ──────────────────────────────────────────────
echo "▶ [1/4] 生成 example 脚手架..."

flutter create \
  --template=app \
  --project-name=fluwx_example \
  --org=com.jarvan \
  packages/fluwx/example

flutter create \
  --template=app \
  --project-name=fluwx_example \
  --org=com.jarvan \
  packages/fluwx_no_pay/example

echo "  ✅ 脚手架生成完毕"
echo ""

# ──────────────────────────────────────────────
# 2. 建立 lib/ 下的 symlink
#
# symlink 存放位置：packages/<pkg>/example/lib/
# 目标位置：       packages/_shared/example/lib/
#
# 从 packages/<pkg>/example/lib/ 出发，向上：
#   ..      → packages/<pkg>/example/
#   ../..   → packages/<pkg>/
#   ../../..→ packages/
#   ../../../_shared → packages/_shared   ✓
# ──────────────────────────────────────────────
echo "▶ [2/4] 建立 lib/ symlink..."

for PKG in fluwx fluwx_no_pay; do
  LIB="packages/$PKG/example/lib"

  # 删除 flutter create 生成的占位内容
  rm -rf "$LIB/main.dart" "$LIB/pages" "$LIB/utils.dart"

  # 正确的相对路径：3 级向上到 packages/，再进 _shared/example/lib/
  ln -sf "../../../_shared/example/lib/pages"      "$LIB/pages"
  ln -sf "../../../_shared/example/lib/main.dart"  "$LIB/main.dart"
  ln -sf "../../../_shared/example/lib/utils.dart" "$LIB/utils.dart"

  # 验证
  echo "  --- $PKG/example/lib ---"
  ls -la "$LIB/"
done
echo ""

# ──────────────────────────────────────────────
# 3. 写 fluwx_compat.dart（两包唯一不同的文件）
# ──────────────────────────────────────────────
echo "▶ [3/4] 写 fluwx_compat.dart..."

cat > packages/fluwx/example/lib/fluwx_compat.dart << 'EOF'
// fluwx 适配层 — 共享 example 代码通过此文件引入正确的包
export 'package:fluwx/fluwx.dart';
EOF

cat > packages/fluwx_no_pay/example/lib/fluwx_compat.dart << 'EOF'
// fluwx_no_pay 适配层 — 共享 example 代码通过此文件引入正确的包
export 'package:fluwx_no_pay/fluwx_no_pay.dart';
EOF

echo "  ✅ fluwx_compat.dart 写入完毕"
echo ""

# ──────────────────────────────────────────────
# 4. 更新 pubspec.yaml + images symlink
#
# images symlink 位置：packages/<pkg>/example/images
# 从 packages/<pkg>/example/ 出发：
#   ..      → packages/<pkg>/
#   ../..   → packages/
#   ../../_shared → packages/_shared   ✓
# ──────────────────────────────────────────────
echo "▶ [4/4] 更新 pubspec.yaml 并建立 images symlink..."

for PKG in fluwx fluwx_no_pay; do
  PUBSPEC="packages/$PKG/example/pubspec.yaml"

  # 用 Python 更新 pubspec.yaml
  python3 - "$PUBSPEC" "$PKG" << 'PYEOF'
import sys, re

pubspec_path = sys.argv[1]
pkg          = sys.argv[2]

content = open(pubspec_path).read()

# 替换 dependencies 块，加入插件 path 依赖
dep_block = (
    "dependencies:\n"
    "  flutter:\n"
    "    sdk: flutter\n"
    "  cupertino_icons: ^1.0.8\n"
    "\n"
    f"  {pkg}:\n"
    "    path: ../\n"
)
content = re.sub(
    r'dependencies:.*?(?=\ndev_dependencies:|\Z)',
    dep_block + '\n',
    content,
    flags=re.DOTALL,
)

# 在顶层追加 fluwx 配置（如果还没有）
cfg_key = f'{pkg}:'
if cfg_key not in content:
    cfg = (
        f"{cfg_key}\n"
        "  app_id: '123456'\n"
        "  debug_logging: true\n"
        "  ios:\n"
        "    universal_link: https://testdomain.com\n"
        "\n"
    )
    content = cfg + content

open(pubspec_path, 'w').write(content)
print(f"  ✅ {pubspec_path} 更新完毕")
PYEOF

  # images symlink（2 级向上到 packages/，再进 _shared/example/images）
  rm -rf "packages/$PKG/example/images"
  ln -sf "../../_shared/example/images" "packages/$PKG/example/images"
  echo "  ✅ $PKG/example/images symlink 完毕"
done

echo ""
echo "=========================================="
echo " 完成！验证 symlink："
echo ""
echo "  ls -la packages/fluwx/example/lib/"
echo "  ls -la packages/fluwx_no_pay/example/lib/"
echo "  ls packages/fluwx/example/lib/pages/"
echo ""
echo " 运行 example："
echo "  cd packages/fluwx/example && flutter pub get && flutter run"
echo "  cd packages/fluwx_no_pay/example && flutter pub get && flutter run"
echo "=========================================="
