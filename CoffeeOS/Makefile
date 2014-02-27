TOOLPATH = ../z_tools/
MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = copy
DEL      = del

default :
	$(MAKE) img

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

coffeeOS.sys : coffeeOS.nas Makefile
	$(NASK) coffeeOS.nas coffeeOS.sys coffeeOS.lst

coffeeOS.img : ipl.bin coffeeOS.sys Makefile
	$(EDIMG)   imgin:../z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:coffeeOS.sys to:@: \
		imgout:coffeeOS.img

img :
	$(MAKE) coffeeOS.img

run :
	$(MAKE) img
	$(COPY) coffeeOS.img ..\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ../z_tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: coffeeOS.img

clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst

src_only :
	$(MAKE) clean
	-$(DEL) coffeeOS.img