
! C+++
! C	PROGRAM		SHADOW3
! C
! C	PURPOSE		Run Shadow3 
! C
! C	INPUT		
! C
! C	OUTPUT		
! C
! C
! C---
PROGRAM  Shadow3
  use shadow_globaldefinitions
  use stringio
  use shadow_beamio
  use shadow_variables
  use shadow_kernel
  use shadow_synchrotron
  use shadow_pre_sync    ! undulator preprocessors
  use shadow_preprocessors       ! general preprocessors
  use shadow_postprocessors      ! general postprocessors
!  use urgent_cdf       ! undulator preprocessor by Urgent

  implicit none

  
  character(len=sklen)     ::  inCommand,inCommandLow,arg,mode
  integer(kind=ski)      :: numArg,indx,iErr,i_Device

 
inCommand = "" 
inCommandLow = "" 

! C
! C Look at the command line for user parameters.
! C
  numArg = COMMAND_ARGUMENT_COUNT()
  IF (numarg.NE.0) THEN
     indx = 1
     DO WHILE (indx .LE. numarg)
        !! Curiously get_command_argument is not recognised by g95 in 64bit
        !! Back to OLD way, which seems to work
        !! CALL get_command_argument (INDX, ARG)
        CALL GETARG (indx, arg)
        IF (arg (1:1) .NE. '-') THEN
          inCommand = arg
          inCommandLow = arg
          CALL FStrLoCase(inCommandLow)
        END IF
        ! this option (ascii output) has been eliminated in Shadow3 (srio)
        !  	    IF (ARG (1:2) .EQ. '-a' .OR. ARG (1:2) .EQ. '-A') THEN
        !  		IOFORM = 1
        !  		BGNFILE = 'begin.dat.ascii'
        indx = indx + 1
     END DO
  ELSE ! if no argument is entered, display banner
        print *,'                                                                           '
        print *,'                                                                           '
        print *,'                                                                           '
        print *,'  :::::::  :::    ::            :::    :::::::        :::::     :::  ::  ::'
        print *,' ::::::::  :::    ::           ::::    ::::::::      :::::::    :::  ::  ::'
        print *,':::        :::    ::          ::: :    :::   :::    :::    ::   :::  ::  ::'
        print *,':::        :::    ::         ::: ::    :::    ::    :::    ::   :::  ::  ::'
        print *,' :::::::   :::::::::        :::  ::    :::    ::    :::    ::   :::  ::  ::'
        print *,'  :::::::  :::::::::       :::   ::    :::    ::    :::    ::   :::  ::  ::'
        print *,'       ::  :::    ::      :::    ::    :::    ::    :::    ::   :::  ::  ::'
        print *,'      :::  :::    ::     :::     ::    :::   :::    :::   :::   ::: ::: :::'
        print *,'::::::::   :::    ::    :::      ::    ::::::::      :::::::     ::::::::: '
        print *,':::::::    :::    ::   :::       ::    :::::::        :::::       ::: :::  '
        print *,'                                                                           '
        print *,'                                                                           '
        print *,'                                                                           '
        print *,'SHADOW v3.0Beta                                                            '
        print *,'                                                                           '

  END IF 

! C
! C If the inCommand was not supplied in the command line, ask for it.
! C
!  IF (inCommand(1:1).EQ." ") THEN
!     inCommand  =  RString ('GO => Enter command: ')
!  ENDIF
  

!10 CONTINUE
DO   ! infinite loop starts

inCommandLow=inCommand
CALL FStrLoCase(inCommandLow)

SELECT CASE (inCommandLow)
  CASE ("make_id")
     !c
     !c	Specify Undulator
     !c
     WRITE(6,*) ' '
     WRITE(6,*) ' '
     WRITE(6,*) 'Type of Insertion Device.'
     WRITE(6,*) 'Enter: '
     WRITE(6,*) 'for wiggler   (large K)      [ 1 ]'
     WRITE(6,*) 'for undulator (small K)      [ 2 ]'
     I_DEVICE = IRINT ('Then ? ')
 
     CALL epath(i_Device)
     SELECT CASE (i_Device)
       CASE(1)  ! wiggler
          CALL nphoton
          CALL input_source1
          CALL RWNAME('start.00','W_SOUR',iErr)
          IF (iErr /= 0) THEN 
             print *,'Error writing file start.00'
             stop 'Aborted'
          END IF
       CASE(2)  ! undulator
          CALL Undul_Set
          CALL Undul_Phot
          CALL Undul_Cdf
          CALL input_source1
          CALL RWNAME('start.00','W_SOUR',iErr)
          IF (iErr /= 0) THEN 
             print *,'Error writing file start.00'
             stop 'Aborted'
          END IF
       CASE DEFAULT
         STOP 'ID not yet implemented'
     END SELECT
     print *,'------------------------------------------------------------------------------'
     print *,'GO make_id: '
     print *,'            all files created.'
     print *,'            make source by running: gen_source start.00'
     print *,'------------------------------------------------------------------------------'
     inCommand=""

  CASE ("trace")
     CALL shadow3trace
     inCommand=""
  CASE ("source")
     CALL shadow3source
     inCommand=""
  CASE ("focnew")
     CALL focnew
     inCommand=""
  CASE ("intens")
     CALL intens
     inCommand=""
  CASE ("recolor")
     CALL recolor
     inCommand=""
  CASE ("ffresnel")
     CALL ffresnel
     inCommand=""
  CASE ("plotxy")
     CALL plotxy
     inCommand=""
  CASE ("histo1")
     CALL histo1
     inCommand=""
  CASE ("translate")
     CALL translate
     inCommand=""
  CASE ("sysinfo")
     CALL sysinfo
     inCommand=""
  CASE ("mirinfo")
     CALL mirinfo
     inCommand=""
  CASE ("sourcinfo")
     CALL sourcinfo
     inCommand=""
  CASE ("bragg")
     CALL bragg
     inCommand=""
  CASE ("grade_mlayer")
     CALL grade_mlayer
     inCommand=""
  CASE ("pre_mlayer")
     CALL pre_mlayer
     inCommand=""
  CASE ("prerefl")
     CALL prerefl
     inCommand=""
  CASE ("presurface")
     CALL presurface
     inCommand=""
!  CASE ("cdf_z")
!     CALL cdf_z
!     inCommand=""
  CASE ("epath")
     i_device = 0
     CALL epath(i_Device)
     inCommand=""
  CASE ("nphoton")
     i_device = 0
     CALL nPhoton
     inCommand=""
  CASE ("undul_set")
     CALL undul_set
     inCommand=""
  CASE ("undul_phot")
     CALL undul_phot
     inCommand=""
  CASE ("undul_cdf")
     CALL undul_cdf
     inCommand=""
  CASE ("input_source")
     CALL input_source1
     CALL RWNAME('start.00','W_SOUR',iErr)
     IF (iErr /= 0) THEN 
             print *,'Error writing file start.00'
             stop 'GO Aborted'
     END IF
     inCommand=""

!  CASE ("srfunc")
!     CALL SrFunc
!     inCommand=""
!  CASE ("srcdf")
!     CALL SrCdf
!     inCommand=""
  CASE ("exit")
     !STOP "GO ended."
     EXIT
  CASE ("citation")
     print *,'                                                           '
     print *,' F. Cerrina and M. Sanchez del Rio                         '
     print *,' "Ray Tracing of X-Ray Optical Systems"                    '
     print *,' Ch. 35 in Handbook of Optics (volume  V, 3rd edition),    '
     print *,' edited by M. Bass, Mc Graw Hill, New York, 2009.          '
     print *,'                                                           '
     print *,' ISBN: 0071633138 / 9780071633130                          '
     print *,' http://www.mhprofessional.com/handbookofoptics/vol5.php   '
     print *,'                                                           '
     inCommand="" 
  CASE ("license")
     print *,'    SHADOW3  ray-tracing code for optics                                      '
     print *,'    Copyright (C) 2010  F.Cerrina, M.Sanchez del Rio, F. Jiang, N. Canestrari '
     print *,'                                                                              '
     print *,'    This program is free software: you can redistribute it and/or modify      '
     print *,'    it under the terms of the GNU General Public License as published by      '
     print *,'    the Free Software Foundation, either version 3 of the License, or         '
     print *,'    (at your option) any later version.                                       '
     print *,'                                                                              '
     print *,'    This program is distributed in the hope that it will be useful,           '
     print *,'    but WITHOUT ANY WARRANTY; without even the implied warranty of            '
     print *,'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             '
     print *,'    GNU General Public License for more details.                              '
     print *,'                                                                              '
     print *,'    You should have received a copy of the GNU General Public License         '
     print *,'    along with this program.  If not, see <http://www.gnu.org/licenses/>.     '
     print *,'                                                                              '
     inCommand="?"    
  CASE ("help")
     inCommand="?"
  CASE ("?")
     print *,' '
     print *,' '
     print *,'                            S H A D O W'
     print *,' '
     print *,' '
     print *,'Commands Available at this level: '
     print *,'  [MAIN]            : source trace'
     print *,'  [PRE-PROCESSORS]  : prerefl bragg presurface'
     print *,'                    : input_source pre_mlayer grade_mlayer'
     print *,'                    : make_id epath nphoton undul_set undul_phot undul_cdf' 
     print *,'  [POST-PROCESSORS] : histo1 plotxy translate '
     print *,'                    : sourcinfo mirinfo sysinfo'
     print *,'                    : focnew intens recolor ffresnel'
     print *,'  [OTHER]           : exit help ? license citation'
     print *,'  [OP SYSTEM ACCESS]: $<command>'
     print *,''
     print *,''
     inCommand=""
  CASE DEFAULT
     IF (inCommand(1:1) == "$") CALL SYSTEM( inCommand(2:sklen) )
     inCommand  =  RString ('shadow3> ')
END SELECT 

END DO ! infinite loop

print *,'Exit shadow3'

END PROGRAM Shadow3