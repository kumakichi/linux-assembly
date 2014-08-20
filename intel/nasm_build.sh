#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage: $0 asm_source_file [lc]"
    exit
fi

ASM_FILE=$1
SUFFIX=$(echo ${ASM_FILE##*\.})

if [[ "$SUFFIX" != "s" && "$SUFFIX" != "S" ]]
then
    echo "[$ASM_FILE]:suffix error,only support .s or .S"
    exit
fi

OUTFILE=${ASM_FILE%.${SUFFIX}}
OBJFILE=${OUTFILE}".o"
TMPFILE=${ASM_FILE}"~"
FORMAT="elf"

nasm -f $FORMAT $ASM_FILE -o $OBJFILE

if [[ $# -gt 1 && "$2" = "lc" ]]
then
    ld -o $OUTFILE $OBJFILE --dynamic-linker=/lib/ld-linux.so.2 -lc
else
    ld -o $OUTFILE $OBJFILE
fi

rm $OBJFILE
if [ -f $TMPFILE ]
then
    rm $TMPFILE
fi
