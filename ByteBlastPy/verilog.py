import os
import subprocess

from shutil import which

class IVerilog:
	
	def __init__(self,include_paths):
		self.include_paths = include_paths
		self.prg = which("iverilog")
		if self.prg == None:
			raise ("Could not locate iverilog executable")		
		
	def info(self):
		return [self.include_paths, self.prg]


	def compile(self,data):
		exec = os.path.join(data["path"],"byteblast.out")
		args = [self.prg,"-Wall","-g2012" ,"-o"+exec, "-y"+self.include_paths[0]]
		print (args)

		if "src" in data:
			args.append(os.path.join(data["path"],data["src"]))

		return {"status" : subprocess.call(args) == 0, "exec": os.path.join(data["path"],"byteblast.out")}