.386
.model flat, stdcall
option casemap:none

include NTDriver.inc

.code

DriverEntry proc pDriverObject:PDRIVER_OBJECT,pusRegistryPath:PUNICODE_STRING

    ;your code goes here
    ret

DriverEntry endp

end DriverEntry
