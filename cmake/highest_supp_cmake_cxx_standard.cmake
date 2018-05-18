function(lines_to_list  out_list_var  str)
  # https://cmake.org/pipermail/cmake/2007-May/014222.html
  STRING(REGEX REPLACE ";"  "\\\\;" str "${str}")
  STRING(REGEX REPLACE "\n" ";"     str "${str}")
  #message("${str}")
  set(${out_list_var} "${str}" PARENT_SCOPE)
endfunction()




#Usage: list_of_supp_cmake_cxx_stds(li_cxx_stds)
#       message("${li_cxx_stds}")                    # will print e.g. 98;11;14;17
function(list_of_supp_cmake_cxx_stds out_list_var)
  # scan help output of: cmake --help-property CXX_STANDARD
  execute_process(COMMAND ${CMAKE_COMMAND} --help-property CXX_STANDARD
    OUTPUT_VARIABLE hlp_cxx_std
    ERROR_VARIABLE  hlp_cxx_std
    )

  lines_to_list(list_hlp_cxx_std "${hlp_cxx_std}")

  foreach(line IN LISTS list_hlp_cxx_std)
    set(fourteen 14)
    string(REGEX MATCHALL "(98|11|${fourteen})" out "${line}")
    if ("${out}" STREQUAL "98;11;${fourteen}")
      STRING(REGEX REPLACE ".*${fourteen}" "" remain "${line}")
      string(REGEX MATCHALL "[0-9]+" match_remain "${remain}")
      list(APPEND out ${match_remain})
      set(${out_list_var} "${out}" PARENT_SCOPE)
      break()
    endif()
  endforeach()
endfunction()




#Usage: highest_supp_cmake_cxx_standard(hightest_cxx_std)
#       message("${hightest_cxx_std}")                    # will print e.g. 17
function(highest_supp_cmake_cxx_standard out_var)
  list_of_supp_cmake_cxx_stds(lst_supp_cxx_stds) # extract line with 98, 11, 14, ...
  
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/try_compile.cpp
"int main() { return 0; }
")

  list(REVERSE lst_supp_cxx_stds)
  foreach(cxx_std IN LISTS lst_supp_cxx_stds)
    try_compile(CAN_COMPILE_WITH_THIS_CXX_STANDARD ${CMAKE_CURRENT_BINARY_DIR} SOURCES ${CMAKE_CURRENT_BINARY_DIR}/try_compile.cpp
      CXX_STANDARD ${cxx_std}
      CXX_STANDARD_REQUIRED ON
      CXX_EXTENSIONS OFF
      )
    
    if (CAN_COMPILE_WITH_THIS_CXX_STANDARD)
      set(${out_var} ${cxx_std} PARENT_SCOPE)
      break()
    endif()
  endforeach()
endfunction()
