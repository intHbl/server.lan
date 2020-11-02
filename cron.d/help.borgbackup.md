#!/bin/bash



# 把执行脚本 放在 backup 的磁盘上, 然后执行, 如果没有挂在上,就不能执行.
# 或者 检测 mountpoint, 再执行.

export BORG_PASSPHRASE=<…>



repo_path=""
tag=`date +%Y%m%d_%H%M%S`

data_path=""
# borg create  <repo_path>:<tag>  </path/of/need/packup>
(
cd '...'
borg create  ${repo_path}::${tag}  ${data_path}


)


unset BORG_PASSPHRASE


###########################
#############
# 免重复输密码
export BORG_PASSPHRASE=<…>

# cmd here

unset BORG_PASSPHRASE


#
borg  init -e repokey     <repo_path>

# --stats
# -p  progress
##  :: 双冒号
## --exclude 
tag=`date +%Y%m%d_%H%M%S`
borg  create  --stats -p  <repo_path>::<tag>  </path/of/need/packup>  </path/of/need/packup…>

# 解压的到的路径,  都是`相对`当前的,所以一定要先cd好.
# 如果需要恢复到原来的位置:: 
	# 之前相对路径:: 在哪里create 就要cd到哪里 ,然后extract
	# 之前绝对路径:: `cd /`
# 注意是两个 冒号,   一个冒号 是个  `user@host:path` 用的
borg extract  -p <repo_path>::<tag>
borg  list  <repo_path>::<tag>

#####################


