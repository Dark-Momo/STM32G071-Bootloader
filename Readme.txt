1. Explanations to go2APP code
---------------------------------------------------------------------------------------------------------------------------- 
#define FLASH_APP_ADDR 0x8008000
...
    if (((*(uint32_t *)FLASH_APP_ADDR) & 0x2FFE0000) == 0x20000000)
	{
		printf("App Start \r\n");
		HAL_Delay(100);

		// Get data in second 32-bit in app section. First executable address.
		JumpAddress = *(uint32_t *)(FLASH_APP_ADDR + 4);
		Jump_To_Application = (pFunction)JumpAddress;

		// Initialize app's stack pointer
		__set_MSP(*(uint32_t *)FLASH_APP_ADDR);
		Jump_To_Application();
	}
----------------------------------------------------------------------------------------------------------------------------

In our case, 0x8008000 here is the first address of the flash section for user app.
-- (uint32_t *)FLASH_APP_ADDR is to change the numnber 0x8008000 to an address;
-- *(uint32_t *)FLASH_APP_ADDR is to read out the content at address of 0x8008000;

The content at address of FLASH_APP_ADDR, which is also at 0x8008000, is the stack address (top address) of user's app code.

Stack is in RAM, with start address of 0x20000000. STM MCUs most have RAM size below 128KB, which is 0x1ffff.
How to check whether an address is in the range of 0x20000000 - 0x2001ffff ?
If the address is above 0x2001ffff, it will have an 1 in the bits where 0x2FFE0000 is 1.

So, this sentence is trying to get the user code stack address, and check whether it is in RAM section.

FLASH_APP_ADDR + 4 stores the address of Reset_Handler, which should be the initial value for PC. 

Question : 
(1) Who determines the content in FLASH_APP_ADDR?



