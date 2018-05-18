cmake_minimum_required(VERSION 3.2)

project(cmake_highest_cxx_standard)

if (NOT DEFINED CMAKE_CXX_STANDARD)
  include(cmake/highest_supp_cmake_cxx_standard.cmake)

  list_of_supp_cmake_cxx_stds(lst_supp_cxx_stds)
  message("# CXX standards supported by currently running cmake (found via command:  cmake --help-property CXX_STANDARD): ${lst_supp_cxx_stds}")
  
  highest_supp_cmake_cxx_standard(hightest_cxx_std)
  set(CMAKE_CXX_STANDARD ${hightest_cxx_std})
  message("# setting CMAKE_CXX_STANDARD to hightest supported by your compiler: ${hightest_cxx_std}")
endif()
