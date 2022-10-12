import os

fileNodeCount = 0
entryData = []

root_folder = "root"
temp_folder = "fsbuild"

##
#  If temp folder does not exist, make it
#  or if it does exist, empty it
##
if not os.path.isdir(temp_folder):
	os.system(f"mkdir {temp_folder}")
else:
	os.system(f"rm -rf {temp_folder}/*")

##
#  Copy all files from root folder to temp folder
##
os.system(f"cp -r {root_folder}/* {temp_folder}")

def BuildFolder(folder):
	files = os.listdir(folder)
	for item in files:
		if ".asm" in item:
			os.system(f"nasm -f bin {folder}/{item} && rm {folder}/{item}")

		elif os.path.isdir(folder + item):
			BuildFolder(folder + item + "/")

def ScanDirectory (folder, cNodeID):
	files = os.listdir(folder)

	for item in files:
		global fileNodeCount
		fileNodeCount += 1

		isDir = os.path.isdir(folder + item)

		type = 0
		isgl = 0

		if isDir:
			type = 0

		elif ".txt" in item:
			type = 3

		else:
			type = 1
			isgl = 1

		##
		#  Make entry
		##
		entry = f"db {type}, {fileNodeCount}, {cNodeID}, {isgl}, "
		entry += f"'{item}', "

		os.system(f"dd if={folder}/{item} of=cdiso/boot.flp seek={str(20 + fileNodeCount)} count=1 conv=notrunc")

		padding = 40 - 4 - len(item)

		a = 0
		while a < padding:
			entry += "0, "
			a += 1

		entryData.append(entry)

		if isDir:
			ScanDirectory(folder + item + "/", fileNodeCount)

BuildFolder(temp_folder + "/")
ScanDirectory(temp_folder + "/", fileNodeCount)

disk = open("fsbuild/disk.asm", "w+")

##
#  Create root folder for disk
##
entry = "db 0, 0, 0, 0,"
for x in range(36):
	entry += "1,"
disk.write(entry + "\n")

##
#  Write entry data to be built
##
for x in entryData:
	disk.write(x + "\n")
disk.close()

os.system(f"nasm -f bin {temp_folder}/disk.asm -o ./{temp_folder}/disk_fs")
os.system(f"dd if={temp_folder}/disk_fs of=cdiso/boot.flp seek=16 count=4 conv=notrunc")