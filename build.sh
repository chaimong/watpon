#!/usr/bin/env bash
# รวมทุกไฟล์เป็น HTML ไฟล์เดียว: dist/lma-course.html
cd "$(dirname "$0")" && mkdir -p dist
{
  printf '<!doctype html>\n<html lang="th">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  sed -n '1,/<!--\/head-->/p' index.html | grep -v '<!--/head-->'
  printf '</head>\n<body>\n'
  sed -n '/<!--\/head-->/,$p' index.html | tail -n +2 | perl -pe 'if (/^<script src="([^"]+)"><\/script>\s*$/) { local $/; open(my $f, "<", $1) or die "missing $1"; my $c = <$f>; $_ = "<script>\n/* ---- $1 ---- */\n$c\n</script>\n"; }'
  printf '</body>\n</html>\n'
} > dist/lma-course.html
mkdir -p apps-script && cp dist/lma-course.html apps-script/Index.html
echo "built dist/lma-course.html ($(wc -c < dist/lma-course.html) bytes)"
