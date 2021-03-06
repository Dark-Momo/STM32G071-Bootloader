/**
 ******************************************************************************
 * @file      LinkerScript.ld
 * @author    Auto-generated by STM32CubeIDE
 *  Abstract    : Linker script for NUCLEO-G071RB Board embedding STM32G071RBTx Device from stm32g0 series
 *                      128Kbytes FLASH
 *                      36Kbytes RAM
 *
 *            Set heap size, stack size and stack location according
 *            to application requirements.
 *
 *            Set memory bank area and size if external memory is used
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
 * All rights reserved.</center></h2>
 *
 * This software component is licensed by ST under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 ******************************************************************************
 */

/* Entry Point */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack */
_estack = ORIGIN(RAM) + LENGTH(RAM);	/* end of "RAM" Ram type memory */
/* Stack starts at the end of RAM and goes downwards, as oppsite to heap */

_Min_Heap_Size = 0x200 ;	/* required amount of heap  */
_Min_Stack_Size = 0x400 ;	/* required amount of stack */

/* Memories definition */
MEMORY
{
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 36K
  
  /* We divide 128K (0x20000) Flash into 2 regions, thus reduce Flash length. */
  /* 32K = 0x8000, 96K = 0x18000 */
  
  /* First 32K of Flash, where Bootloader is. */   
  FLASH       (rx)    : ORIGIN = 0x8000000,   LENGTH = 32K
  MY_MEMORY   (rx)    : ORIGIN = 0x8018000,   LENGTH = 32K
}
/* Flash with Read and Execute */

/* Sections */
SECTIONS
{
  /* The startup code into "FLASH" Rom type memory */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH
  
  /* Without NOLOAD, the binary file STM32G071-Bootloader.bin, from STM32G071-Bootloader.elf -> Right 
   * Click -> Show In -> System Explorer will be 390+MB, while with NOLOAD, only 11KB. 
   * WHY???
   */
  .myBufBlockRAM 0x20000100 (NOLOAD) : /* Start addrss, not the length, of this section. */
  {
    KEEP(*(.myBufSectionRAM))          /* Assign this section even if I do not use it. */
  } > RAM

  .myBufBlockFLASH 0x8001000 :         /* Start addrss, not the length, of this section. Why no NOLOAD here?*/
  {
    KEEP(*(.myBufSectionFLASH))        /* Assign this section even if I do not use it. */
  } > FLASH
  
  /* section defined in Video 2 */ 
  .mysection :
  {
    . = ALIGN(4);
    __mysection_start__ = .;
    *(.mysection*)              /* An alias of mysection */
    __mysection_end__   = .;    /* start and end is determined by real usage. */
  } > MY_MEMORY
  
  /* Check whether MY_MEMORY real usage exceeds its claimed size */
  ASSERT(LENGTH(MY_MEMORY) >= (__mysection_end__ - __mysection_start__), "MY_MEMORY LENGTH OVERFLOW!")
  
  /* The program code and other data into "FLASH" Rom type memory */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  /* Constant data into "FLASH" Rom type memory */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab   : {
    . = ALIGN(4);
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } >FLASH

  .ARM : {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } >FLASH

  .preinit_array     :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .init_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .fini_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* Used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* .data section below will appear in both of Build Analyzer -> Memory Details -> FLASH and RAM.
   * There, its sub-sections will have a Load Address which is in Flash, and a Run 
   * Address which is in RAM.
   * That is why it is Initialized data sections.
   */
  /* Initialized data sections into "RAM" Ram type memory */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.RamFunc)        /* .RamFunc sections */
    *(.RamFunc*)       /* .RamFunc* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */

  } >RAM AT> FLASH
  
  /* Uninitialized data section into "RAM" Ram type memory */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  /* User_heap_stack section, used to check that there is enough "RAM" Ram  type memory left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* Remove information from the compiler libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
