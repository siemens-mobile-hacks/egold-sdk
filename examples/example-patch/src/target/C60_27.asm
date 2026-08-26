$SEGMENTED
$CASE
$NOWARNING(120)

	NAME SYS_OPEN_HOOK

	EXTERN _sys_open_hook:FAR
	EXTERN _sys_open_first_call:FAR
	EXTERN _sys_open_resume:FAR

SYS_OPEN_ENTRY_HOOK SECTION CODE WORD PUBLIC 'CPROGRAM'

_sys_open_entry_hook PROC FAR
	JMPS SEG _sys_open_hook, SOF _sys_open_hook
_sys_open_entry_hook ENDP

SYS_OPEN_ENTRY_HOOK ENDS

PATCH_TRAMPOLINES SECTION CODE WORD PUBLIC 'PATCH_BODY'
	PUBLIC _original_sys_open

_original_sys_open PROC FAR
	CALLS SEG _sys_open_first_call, SOF _sys_open_first_call
	JMPS SEG _sys_open_resume, SOF _sys_open_resume
_original_sys_open ENDP

PATCH_TRAMPOLINES ENDS

	END
