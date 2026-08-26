set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR C166)
set(CMAKE_BUILD_TYPE MinSizeRel CACHE STRING "Build type")

get_filename_component(SDK_ROOT ${CMAKE_CURRENT_LIST_DIR}/.. ABSOLUTE)
set(CMAKE_USER_MAKE_RULES_OVERRIDE ${SDK_ROOT}/cmake/modules/Tasking.cmake)

set(TASKING_ROOT "C:/Program Files (x86)/TASKING/dc166 v8.6" CACHE STRING "TASKING C166 Windows path")

if (CMAKE_HOST_WIN32)
	set(CMAKE_C_COMPILER ${TASKING_ROOT}/bin/cc166.exe)
	set(CMAKE_ASM_COMPILER ${TASKING_ROOT}/bin/cc166.exe)
	set(TASKING_IHEX ${TASKING_ROOT}/bin/ihex166.exe)
else()
	find_program(WINE wine REQUIRED)
	find_program(WINEPATH winepath REQUIRED)
	execute_process(COMMAND ${WINEPATH} -s ${TASKING_ROOT} OUTPUT_VARIABLE TASKING_WINE_ROOT
		OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
	string(REPLACE "\\" "/" TASKING_WINE_ROOT ${TASKING_WINE_ROOT})
	set(CMAKE_C_COMPILER ${WINE})
	set(CMAKE_C_COMPILER_ARG1 ${TASKING_WINE_ROOT}/bin/cc166.exe)
	set(CMAKE_ASM_COMPILER ${WINE})
	set(CMAKE_ASM_COMPILER_ARG1 ${TASKING_WINE_ROOT}/bin/cc166.exe)
	set(TASKING_IHEX ${WINE} ${TASKING_WINE_ROOT}/bin/ihex166.exe)
endif()

set(CMAKE_C_COMPILER_ID Tasking)
set(CMAKE_C_COMPILER_ID_RUN TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_ASM_COMPILER_ID Tasking)
set(CMAKE_ASM_COMPILER_ID_RUN TRUE)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_WORKS TRUE)

set(FF_PATH ${SDK_ROOT}/../fullflashes CACHE PATH "Fullflashes path")

function(define_patch target phone svn)
	set(target_dir ${CMAKE_CURRENT_SOURCE_DIR}/src/target)
	set(target_name ${phone}_${svn})
	set(fullflash ${FF_PATH}/${phone}sw${svn}.bin)

	set_property(TARGET ${target} PROPERTY SUFFIX .abs)
	target_sources(${target} PRIVATE ${target_dir}/${target_name}.asm)
	target_include_directories(${target} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
	target_compile_definitions(${target} PUBLIC ${target_name})
	target_compile_options(${target} PUBLIC
		$<$<COMPILE_LANGUAGE:C>:-RclFC=PATCH_BODY>
		$<$<COMPILE_LANGUAGE:C>:-RclPR=PATCH_BODY>
	)
	target_link_options(${target} PUBLIC
		-nolib
		-ieee
		-Wo@${target_dir}/${target_name}.src
		-Wl@${target_dir}/${target_name}.lnk
	)

	add_custom_command(TARGET ${target} POST_BUILD
		COMMAND ${TASKING_IHEX}
			-i32 -O ${target}.out -o ${target}.hex
		COMMAND elf2vkp --section-names --chunk-size 512 --base egold
			-f ${fullflash} -i ${target}.hex -o ${target}.vkp
	)

	message("Compiling patch ${target} for ${phone}v${svn}")
endfunction()
