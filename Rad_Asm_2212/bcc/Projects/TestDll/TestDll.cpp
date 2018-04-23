
#include "windows.h"
#include "TestDll.h"

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpReserved)
{
    // Perform actions based on the reason for calling.
    switch( fdwReason ) 
    { 
        case DLL_PROCESS_ATTACH:
         // Initialize once for each new process.
         // Return FALSE to fail DLL load.
			MessageBox(NULL,TEXT("DLL_PROCESS_ATTACH"),TEXT("TestDll"),MB_OK);
            break;

        case DLL_THREAD_ATTACH:
         // Do thread-specific initialization.
            break;

        case DLL_THREAD_DETACH:
         // Do thread-specific cleanup.
            break;

        case DLL_PROCESS_DETACH:
         // Perform any necessary cleanup.
			MessageBox(NULL,TEXT("DLL_PROCESS_DETACH"),TEXT("TestDll"),MB_OK);
            break;
    }
    return TRUE;  // Successful DLL_PROCESS_ATTACH.
}

BOOL _stdcall DllFun()
{
	MessageBox(NULL,TEXT("Test"),TEXT("TestDll"),MB_OK);
	return 0;
}
