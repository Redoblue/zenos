TOOLPATH = ../tolset/z_tools/
MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = copy
DEL      = del

# �f�t�H���g����

default :
	$(MAKE) img

# �t�@�C�������K��

ipl.bin : ipl.asm Makefile
	$(NASK) ipl.asm ipl.bin ipl.lst

zenos.img : ipl.bin Makefile
	$(EDIMG)   imgin:../tolset/z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0   imgout:zenos.img

# �R�}���h

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) zenos.img

run :
	$(MAKE) img
	$(COPY) zenos.img ..\tolset\z_tools\qemu\fdimage0.bin
	$(MAKE) -C $(TOOLPATH)qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: zenos.img

clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst

src_only :
	$(MAKE) clean
	-$(DEL) zenos.img
