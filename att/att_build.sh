#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 asm_source_file"
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

as -o $OBJFILE $ASM_FILE
ld -o $OUTFILE $OBJFILE
rm $OBJFILE
if [ -f $TMPFILE ]
then
    rm $TMPFILE
fi
