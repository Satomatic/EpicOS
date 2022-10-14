# EpicOS v4.0

The 16-bit assembly Operating System 16 year old me wrote in college.

This project sat untouched for quite a few years before finding the source on an old Linux installation. I've been having fun working on it so except some updates every now and then.

The project is pretty pointless and serves as nothing but an assembly playground project for me.

<img src="https://i.imgur.com/nMY4KY2.png" width=500/>
Screenshot running in qemu

## Features
- Working filesystem ( bs:fs v1 )
- Basic commands for navigation
- Shell command line
- User login

### User login
Before the shell is started, the kernel will load the login program where you will be prompted to enter a username and password. This will be checked and load the shell.

**Default users**
```
root :: 123
krnsh :: 000
```

You can add new users to `/usr.txt` following the established format.
Currently the login is more of a detail thing as user permissions were never added into the filesystem, though I do have plans on changing this in the future.

### File system
EpicOS uses its own filesystem bs:fs (BullSh#t FileSystem)
The filesystem data starts at sector 16 where 4 sectors store the entities which consist of 40 bytes.
```
 0x0 - File type
 0x1 - File ID
 0x2 - Parent ID
 0x3 - Global flag
 0x4 - File name ( rest of the space )
```
 **File types**
 ```
 0x0 - Directory
 0x1 - Binary file
 0x2 - Kernel File
 0x3 - Text file
 ```
 
 Parent ID referrs to the entity ID the file belongs to which is usually a directory though is not limited as such.
 
 The global flag declares if the directory has to be checked or whether it can be accessed anywhere. For example, programs such as `ls` or `cd` are stored in the `/bin/` directory and are set as global
 
 The contents of the file is stored after the 4 sectors of entity data. This location can be found with the following:\
 `entity_data + (4 * 512) + (file_id * 512)`
 
 However, this means in bs:fs v1, files can only be 512 bytes large until I work on expanding and disk fragmenting more.
 
