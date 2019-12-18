# 默认动作

default :
	make img

# 镜像文件生成

ipl.bin : ipl.asm Makefile
	nask ipl.asm ipl.bin ipl.lst

zenos.img : ipl.bin Makefile
	edimg imgin:..\tolset\z_tools\fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 imgout:zenos.img

# 其他指令

asm :
	make -r ipl.bin

img :
	make -r zenos.img

run :
	make img
	copy zenos.img ..\tolset\z_tools\qemu\fdimage0.bin
	make -C ..\tolset\z_tools\qemu

install :
	make img
	imgtol.com w a: helloos.img

clean :
	-del ipl.bin
	-del ipl.lst

src_only :
	make clean
	-del zenos.img
