#!/usr/bin/env python3


import sys
import os
import argparse

root_folder = os.path.join(os.path.dirname(__file__), "..")
sys.path.append(root_folder)

from ByteBlastPy import assembler


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument("-v", "--Verbose", help = "Verbosity")
    parser.add_argument('-i',"--Input" , help= "input files (in order)", type=argparse.FileType('r'), nargs='+')
    parser.add_argument('-o',"--Output" , help= "output file (binary)", type=str)
    parser.add_argument('-b',"--Bits" , help= "dump the bits", type=str)
    parser.add_argument('-m',"--Mnemonic" , help= "Mnemonic file", type=argparse.FileType('r'), nargs='+')     

    args = parser.parse_args()

    assem = assembler.Assembler()    

    if args.Verbose:
        assem.debug = True
    
    for f in args.Input:
        for line in f:
            assem.parse_line(line)

    for f in args.Mnemonic:
        for line in f:
            mnemonic = line.split()
            assem.mnemonics[mnemonic[0]] = mnemonic[1]
    

    assem.resolve_lines()
    assem.create_machine_code()

    if args.Output:
        with open(args.Output, "wb") as binary_file:
            binary_file.write(assem.machine_code)
    else:
        print(assem.machine_code)
    
    if args.Bits:
        print("fuck me")
        print(assem.bit_string())