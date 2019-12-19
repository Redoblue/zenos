; haribote-ipl
; TAB=4

		CYLS	EQU 10			; 定义柱面数常量

		ORG		0x7c00			; 指明程序装载地址

; 标准FAT12格式软盘专用的代码 Stand FAT12 format floppy code

		JMP		entry
		DB		0x90
		DB		"ZENIPL  "		; 启动扇区名称（8字节）
		DW		512				; 每个扇区（sector）大小（必须512字节）
		DB		1				; 簇（cluster）大小（必须为1个扇区）
		DW		1				; FAT起始位置（一般为第一个扇区）
		DB		2				; FAT个数（必须为2）
		DW		224				; 根目录大小（一般为224项）
		DW		2880			; 该磁盘大小（必须为2880扇区1440*1024/512）
		DB		0xf0			; 磁盘类型（必须为0xf0）
		DW		9				; FAT的长度（必须为9扇区）
		DW		18				; 一个磁道（track）有几个扇区（必须为18）
		DW		2				; 磁头数（必须为2）
		DD		0				; 不使用分区，必须是0
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 意义不明（固定）
		DD		0xffffffff		; （可能是）卷标号码
		DB		"ZENOS      "	; 磁盘的名称（必须为11字节，不足填空格）
		DB		"FAT12   "		; 磁盘格式名称（必须为8字节，不足填空格）
		RESB	18				; 先空出18字节

; 程序主体

entry:
		MOV		AX, 0			; 初始化寄存器
		MOV		SS, AX
		MOV		SP, 0x7c00
		MOV		DS, AX

; 读磁盘

		MOV		AX, 0x0820
		MOV		ES, AX			; 段基址
		MOV		CH, 0			; 柱面0
		MOV		DH, 0			; 磁头0
		MOV		CL, 2			; 扇区2
readloop:
		MOV		SI, 0			; 记录失败次数的寄存器
retry:
		MOV		AH, 0x02		; AH=0x02 : 读入磁盘
		MOV		AL, 1			; 1个扇区
		MOV		BX, 0
		MOV		DL, 0x00		; A驱动器
		INT		0x13			; 调用磁盘BIOS
		JNC		next			; 没出错的话跳转next
		ADD		SI, 1			; 出错的话SI加1
		CMP		SI, 5			; 比较SI与5
		JAE		error			; SI >= 5时，跳转到error
		MOV		AH, 0x00		; 磁盘复位
		MOV		DL, 0x00		; A驱动器
		INT 	0x13			; 重置驱动器
		JMP		retry
next:
		MOV		AX, ES			; 把内存地址后移0x200
		ADD		AX, 0x0020
		MOV		ES, AX			; 因为没有ADD ES, 0x020指令，所以这里稍微绕个弯
		ADD		CL, 1			; 读下一扇区
		CMP		CL, 18			; 比较CL与18
		JBE		readloop		; 如果CL <= 18跳转至readloop
		MOV		CL, 1			; 扇区从1开始
		ADD 	DH, 1			; 读下一磁头
		CMP 	DH, 2			; 磁头和2比较
		JB		readloop		; 如果DH < 2，则跳转到readloop
		MOV		DH, 0
		ADD		CH, 1			; 读下一柱面
		CMP		CH, CYLS		; 读入的总的柱面数
		JB		readloop


; 读盘错误显示信息

fin:
		HLT						; 让CPU停止，等待指令
		JMP		fin				; 无限循环

error:
		MOV		SI, msg
putloop:
		MOV		AL, [SI]
		ADD		SI, 1			; 给SI加1
		CMP		AL, 0			; 如果要显示的字节为0，则结束
		JE		fin
		MOV		AH, 0x0e		; 显示一个文字
		MOV		BX, 15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; 换行两次
		DB		"load error"
		DB		0x0a			; 换行
		DB		0				; 这个地方的0会在putloop中被压入AL，用于结束显示

		RESB	0x7dfe-$		; 填写0x00直到0x001fe

		DB		0x55, 0xaa
