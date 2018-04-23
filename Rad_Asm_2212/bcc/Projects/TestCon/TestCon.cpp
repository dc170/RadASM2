
#include <stdio.h>
#include "windows.h"
#include "TestCon.h"

int main(void)
{
static TCHAR szText[]=TEXT("HelloWin");

	printf("%s\n",szText);
	gets(szText);
	return 0;
}

