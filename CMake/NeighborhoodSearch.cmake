include(ExternalProject)

option(USE_GPU_NEIGHBORHOOD_SEARCH "Use GPU neighborhood search" OFF)

if(USE_GPU_NEIGHBORHOOD_SEARCH)

	message(STATUS "Use cuNSearch for neighborhood search")

	if(USE_DOUBLE_PRECISION)
		message("Use cuNSearch with single precision to get a better performance.")
	endif()

	enable_language(CUDA)
	find_package(CUDA 9.0 REQUIRED)
	## cuNSearch
	ExternalProject_Add(
	   Ext_NeighborhoodSearch
	   PREFIX "${CMAKE_SOURCE_DIR}/extern/cuNSearch"
	   GIT_REPOSITORY https://github.com/InteractiveComputerGraphics/cuNSearch.git
	   GIT_TAG "aba3da18cb4f45cd05d729465d1725891ffc33da"
	   INSTALL_DIR ${ExternalInstallDir}/NeighborhoodSearch
	   CMAKE_ARGS -DCMAKE_BUILD_TYPE=${EXT_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE} -DCMAKE_INSTALL_PREFIX:PATH=${ExternalInstallDir}/NeighborhoodSearch -DCUNSEARCH_USE_DOUBLE_PRECISION:BOOL=${USE_DOUBLE_PRECISION} -DBUILD_DEMO:BOOL=OFF
	   )

	set(NEIGHBORHOOD_ASSEMBLY_NAME cuNSearch)
	set(NEIGBORHOOD_SEARCH_LINK_DEPENDENCIES general ${CUDA_LIBRARIES})
	add_compile_options(-DGPU_NEIGHBORHOOD_SEARCH)

else(USE_GPU_NEIGHBORHOOD_SEARCH)

	## CompactNSearch
	ExternalProject_Add(
	   Ext_NeighborhoodSearch
	   PREFIX "${CMAKE_BINARY_DIR}/extern/CompactNSearch"
	   GIT_REPOSITORY https://github.com/SaidZahrai/CompactNSearch.git
	#    GIT_TAG "3f11ece16a419fc1cc5795d6aa87cb7fe6b86960"
	   GIT_TAG "e958d6d00d1d1f0940720e966e0c6df2eaff75c4"
	   INSTALL_DIR ${ExternalInstallDir}/NeighborhoodSearch
	   CMAKE_ARGS -DCMAKE_BUILD_TYPE=${EXT_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE} -DCMAKE_INSTALL_PREFIX:PATH=${ExternalInstallDir}/NeighborhoodSearch -DUSE_DOUBLE_PRECISION:BOOL=${USE_DOUBLE_PRECISION} -DBUILD_DEMO:BOOL=OFF
	)
	set(NEIGHBORHOOD_ASSEMBLY_NAME CompactNSearch)

endif(USE_GPU_NEIGHBORHOOD_SEARCH)

ExternalProject_Get_Property(
	Ext_NeighborhoodSearch
	INSTALL_DIR
)
set(NEIGHBORHOOD_SEARCH_LIBRARIES
	optimized ${INSTALL_DIR}/lib/${LIB_PREFIX}${NEIGHBORHOOD_ASSEMBLY_NAME}${LIB_SUFFIX}
	debug ${INSTALL_DIR}/lib/${LIB_PREFIX}${NEIGHBORHOOD_ASSEMBLY_NAME}_d${LIB_SUFFIX}
	${NEIGBORHOOD_SEARCH_LINK_DEPENDENCIES}
)
set(NEIGHBORHOOD_SEARCH_INCLUDE_DIR ${INSTALL_DIR}/include/)

unset(INSTALL_DIR)
