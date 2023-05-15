#!/bin/bash
# tree (bash version)
# list contents of directories in a tree-like format
# author: github.com/s0ubhik

ncol="\033[0m"
bold="\033[1m"
dim="\033[2m"
uline="\033[4m"
reverse="\033[7m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
purple="\033[35m"
cyan="\033[36m"
white="\033[37m"

mktree(){
  local oldcd=`pwd`
  cd $1 &> /dev/null
  if [ "$?" == "1" ]; then
    return
  fi
  IFS=$'\n'
  files=(`ls -1`)
  unset IFS

  local flen=${#files[@]}
  local c=0
  for file in "${files[@]}"; do
    c=$(($c + 1))

    if [ -d "$file" ]; then


      if [ "$c" != "$flen" ]; then
        echo -e "$2"├── "$bold$blue"$file"$ncol"
        mktree $file "${2}│   "
      else
        echo -e "$2"└── "$bold$blue"$file"$ncol"
        mktree $file "${2}    "
      fi
    else

      if [ -x "$file" ]; then # executables
        xfile=$bold$green$file$ncol

      elif [ -h "$file" ]; then # symbolic links
        xfile=$bold$cyan$file$ncol

      elif [ -p "$file" ]; then # pipes
        xfile=$bold$purple$file$ncol

      elif [ -b "$file" ]; then # block devices
        xfile=$bold$yellow$file$ncol

      elif [ -c "$file" ]; then # char devices
        xfile=$bold$yellow$file$ncol

      else
        xfile=$file
      fi

      if [ "$c" != "$flen" ]; then
        echo -e "$2"├── $xfile
      else 
        echo -e "$2"└── $xfile
      fi

    fi

  done
  cd $oldcd
}

if [ "$1" == "" ]; then
  path=.
else
  path=$1
fi

fullpath=`realpath $path`
echo -e $bold$blue${fullpath##*/}$ncol
mktree $path
echo
