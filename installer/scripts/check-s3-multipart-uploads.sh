#!/bin/bash
# check_s3_multipart_uploads.sh
#
# Проверяет все S3 bucket'ы на наличие незавершенных multipart загрузок.
#
# ЗАЧЕМ: Прерванные multipart загрузки занимают место в хранилище,
#        но не отображаются в обычном листинге файлов.
#
# ИСПОЛЬЗОВАНИЕ:
#   ./check_s3_multipart_uploads.sh s3-config-file

S3CMD_CONFIG="${1:-~/.s3cfg}"

echo "Bucket                          | Multipart uploads"
echo "--------------------------------|------------------"

s3cmd -c "$S3CMD_CONFIG" ls |
  awk '{print $3}' |
  sed 's|s3://||' |
  sed 's|/||' |
  grep '^onprem' |
  while read bucket; do
    count=$(s3cmd -c "$S3CMD_CONFIG" multipart "s3://$bucket/" 2>/dev/null | grep -c "s3://")

    [ "$count" -gt 0 ] && printf "%-32s| %d\n" "$bucket" "$count"
  done
