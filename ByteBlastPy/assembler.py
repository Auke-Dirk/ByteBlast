import os
import sys

class Assembler():
  
  line_count = 0
  labels = {}
  lines = []
  mnemonics = {}
  machine_code =bytearray()
  debug = False
  
  def __init__(self) -> None:
    print ("ByteBlast assembler")
 
  def parse(self,file):
      file1 = open(file, 'r')
      Lines = file1.readlines()
      
      for line in Lines:
        self.parse_line(line)

  def parse_line(self,line):
      elements = line.strip().split(":")
      
      islabel = len(elements) == 2
      elements = list(filter(None, elements))
      # print(elements)
      if islabel:
         self.labels[elements[0]] = self.line_count
      
      # now its just a lable
      if islabel and len(elements) == 1:
        pass
      else:
         self.lines.append(elements[-1].split())
         self.line_count = self.line_count + 1

  def to_bits(self,value, nr_of_bits):
    return ("{0:b}".format(value)).zfill(nr_of_bits)

  def resolve_lines(self):
    for index in range(len(self.lines)):
           
           if len(self.lines[index]) == 2:
              # replace the mnemonic
              mnemonic = self.lines[index][0]
              self.lines[index][0] = self.mnemonics[mnemonic]

              # get the labels codeline
              lbl = self.labels[self.lines[index][1]]
              # replace with binary representation
              self.lines[index][1] = self.to_bits(lbl,5)
              
           else:
              # is a constant value
              value = int(self.lines[index][0]) 
              self.lines[index][0] = self.to_bits(value,8)
  
  def create_machine_code(self):           
    for line in self.lines:
      if len(line) == 2:
        value = int(line[0] + line[1],2)
        #print(line[0] + line[1],value)
        self.machine_code.append(value)
      else:
         self.machine_code.append(int(line[0],2))
  
  def bit_string(self):
    for byte in self.machine_code:
       print(byte)    
    return "bam"      
       
if __name__== "__main__":
    a = Assembler()
    a.mnemonics['LO']  = '000'
    a.mnemonics['ADD'] = '001'
    a.mnemonics['STO'] = '010'
    a.mnemonics['SUB'] = '011'
    a.mnemonics['JNZA'] = '100'

    a.parse(sys.argv[1])
    a.resolve_lines()
    a.create_machine_code()
    print(a.machine_code)
    with open("byteblast.bin", "wb") as binary_file:
      binary_file.write(a.machine_code)