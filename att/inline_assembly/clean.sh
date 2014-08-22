#!/bin/bash

for i in $(ls *.c)
do
    elf_file=${i%.c}
    if [ -f "$elf_file" ]
    then
        rm $elf_file
    fi
done

tmp_files=$(ls *~ 2>/dev/null)
if [ "$tmp_files" != "" ]
then
    rm *~
fi

obj_files=$(ls *.o 2>/dev/null)
if [ "$obj_files" != "" ]
then
    rm *.o
fi
