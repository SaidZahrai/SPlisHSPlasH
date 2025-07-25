include(GetGitRevisionDescription)
get_git_head_revision(GIT_REFSPEC GIT_SHA1)
git_local_changes(GIT_LOCAL_CHANGES)
if (DL_OUTPUT)
	git_local_diff(GIT_LOCAL_DIFF)

	# Write the output to a file in the binary directory
	file(WRITE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/git_diff.txt "${GIT_LOCAL_DIFF}")
endif()
if (${GIT_LOCAL_CHANGES} STREQUAL "DIRTY")
	set(COMPILER_MESSAGE "#pragma WARNING(Local changes not committed.)")
endif()

file (STRINGS "../version.txt" SPLISHSPLASH_VERSION)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Version.h.in ${CMAKE_CURRENT_SOURCE_DIR}/Version.h @ONLY)




add_library(Utilities
	
	BinaryFileReaderWriter.h
	Counting.h
	FileSystem.h
	Logger.h
	OBJLoader.h
	PartioReaderWriter.cpp
	PartioReaderWriter.h
	PLYLoader.h
	StringTools.h	
	SystemInfo.h
	Timing.h
	Version.h
)

add_dependencies(Utilities partio zlib)
target_include_directories(Utilities PUBLIC ${TOPLEVEL_INCLUDE_DIR} ${EIGEN3_INCLUDE_DIR})
target_link_libraries(Utilities INTERFACE partio zlib MD5)
