function extract --description "Expand or extract bundled & compressed files"
  set --local ext (echo $argv[1] | awk -F. '{print $NF}')
  switch $ext
    case tar  # non-compressed, just bundled
      echo tar -xvf $argv[1]
    case gz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        echo tar -zxvf $argv[1]
      else  # single gzip
        echo gunzip $argv[1]
      end
    case tgz  # same as tar.gz
      echo tar -zxvf $argv[1]
    case bz2  # tar compressed with bzip2
      echo tar -jxvf $argv[1]
    case rar
      echo unrar x $argv[1]
    case zip
      echo unzip $argv[1]
    case '*'
      echo "unknown extension"
  end
end
