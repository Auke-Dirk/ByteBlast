#!/usr/bin/env python3

import json
import os
import glob
import pprint
import subprocess
import sys
import re
from shutil import which


class Test:
	count = 0

	def __init__(self,prg):
		self.prg = prg

	def dut(self,filename):
		self.count += 1
		try:
			with open(filename) as f:
				data = json.load(f)				
				if "path" not in data:
					data["path"] = os.path.dirname(filename)
				
				compiled_resource = self.prg.compile(data)
				if compiled_resource["status"]:
					test_result = subprocess.run(compiled_resource["exec"], check=True, stdout=subprocess.PIPE, universal_newlines=True)

					expect = self.fetch_expect(data)
				
					if expect in test_result.stdout:
						self.handle_passed(filename)
					else:
						print("expect:")
						print(expect)
						print("got:")
						print(test_result.stdout)
						self.handle_failed(filename)
						
		except Exception as error:
			self.handle_error(filename)
			print("\t" + str(error))


	def fetch_expect(self,data):
		if "expect" in data:
			return data["expect"]
		if "expect-file" in data:
			p = os.path.join(data["path"],data["expect-file"])
			f = open(p)
			expect = f.read()
			f.close()
			return expect
	
	def handle_error(self,filename):
		print("[%d] [ERROR ] %s." % (self.count,filename))
	
	def handle_passed(self,filename):
		print("[%d] [PASSED] %s." % (self.count,filename))

	def handle_failed(self,filename):
		print("[%d] [FAILED] %s." % (self.count,filename))



class IVerilog:
	
	def __init__(self,include_paths):
		self.include_paths = include_paths
		self.prg = which("iverilog")
		if self.prg == None:
			raise ("Could not locate iverilog executable")		
		
	def info(self):
		return [ self.include_paths, self.prg]


	def compile(self,data):
		exec = os.path.join(data["path"],"byteblast.out")
		args = [self.prg,"-Wall","-g2012" ,"-o"+exec, "-y"+self.include_paths[0]]
	

		if "src" in data:
			args.append(os.path.join(data["path"],data["src"]))

		#print(args)
		return {"status" : subprocess.call(args) == 0, "exec": os.path.join(data["path"],"byteblast.out")}

		
		

def main():
	incl_paths = []
	if os.environ.get('BYTEBLAST_PATH') != None:
		incl_paths.append(os.environ.get('BYTEBLAST_PATH') + "/rtl")
	else:
		import pathlib
		cf = pathlib.Path(__file__).parent.resolve()
		rtl_folder = cf.parent / "rtl"
		if rtl_folder.exists():
			incl_paths.append(str(rtl_folder))

	#print(incl_paths)
	prog = IVerilog(incl_paths)
	test = Test(prog);
	path = os.getcwd()

	test_files = []

	for filename in glob.glob('./**/*.json',recursive=True):
		test_files.append(filename)

	if len(sys.argv) == 2:
		regex = re.compile(sys.argv[1])
		test_files = [i for i in test_files if regex.search(i)]		

	for filename in test_files:
		test.dut(os.path.abspath(filename))
 
  
if __name__== "__main__":
  main()
