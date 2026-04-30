#!/bin/bash
# 在仓库根目录运行：bash tools/setup_example_symlinks.sh
set -e
cd "$(dirname "$0")/.."

SHARED="packages/_shared/example/lib"

for PKG in fluwx fluwx_no_pay; do
  LIB="packages/$PKG/example/lib"

  echo "▶ $PKG"

  # 删除旧 pages 目录（含 ln -sf 误建的 pages/pages 嵌套）
  rm -rf "$LIB/pages"
  # 删除旧 main.dart / utils.dart（已被 symlink 替代，但可能还存在实体文件）
  rm -f  "$LIB/main.dart" "$LIB/utils.dart"

  # 建立 symlink
  ln -sf "../../../../_shared/example/lib/pages"     "$LIB/pages"
  ln -sf "../../../../_shared/example/lib/utils.dart" "$LIB/utils.dart"
  ln -sf "../../../../_shared/example/lib/main.dart"  "$LIB/main.dart"

  echo "  ✅ symlink 完成"
  ls -la "$LIB/"
  echo ""
done

echo "🎉 所有 example symlink 建立完毕"
echo ""
echo "验证："
echo "  ls -la packages/fluwx/example/lib/"
echo "  ls -la packages/fluwx_no_pay/example/lib/"
