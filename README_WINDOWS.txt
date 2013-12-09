--------------------------------------------------------------
                SHADOW 3.0 COMPILATION UNDER WINDOWS
--------------------------------------------------------------

The compilation of shadow3 under windows can be done in different ways. One is to have a unix-line environment and use the Makefile. 

I have chosen a simplified way, via simple scripts : 
 
1) Requirements
   One Fortran compiler, e.g.: 
      -gfortran: I obtained it from: 
                  http://gcc.gnu.org/wiki/GFortranBinaries#Windows
http://users.humboldt.edu/finneyb/gfortran-windows-20130301.exe
      -g95: from http://ftp.g95.org/
   
   An implementation of "sed" (used in the script shadow_version.bat). 
   I used sed (4.07)  from http://www.pement.org/sed/ 

   2) The source files *.f90 (small "f") after running the C preprocessor. 
      In your Unix machine you can run "make preprocess" to create the pure f90 files after applying the C preprocessor. Do not forget to switch the Windows Flags in the Makefile
            
   3) copy all *.f90 (small "f") and *.bat files to your Windows machine, and run the compile_bat file. Copy also PRELIB* files to let shadow3 to autigenerate the optical library. 
   
      Run compile.bat 
      This bat file: 
       -calls shadow_version.bat that creates the file shadow_version.f90 with the local Windows info.
       -calls either compile_gfortran.bat or compile_g95.bat
       -cleans unused files
       
       As a result, it creates shadow3.exe

NOTE: This info concerns the creation of shadow3.exe. Other SHADOW examples, bindings etc. are not yet
implemented and tested under Windows, as most developers use Linux or MacOS platforms. 

srio@esrf.eu 2013-03-07
