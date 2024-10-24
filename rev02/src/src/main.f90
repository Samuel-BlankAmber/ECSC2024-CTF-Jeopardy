subroutine panic(error)
   implicit none
   CHARACTER(len=64) :: error
   WRITE(*,*) error
   CALL exit(-1)
end

module turtle
contains
   subroutine get_color(color, outcolor)
      implicit none
      INTEGER(4) :: color, index
      INTEGER(4), DIMENSION(3) :: outcolor
      INTEGER(4), DIMENSION(3,41) :: color_data = reshape((/255,0,0, 0,255,0, 0,0,255, &
         255,255,0, 0,255,255, 255,0,255, 255,165,0, 128,0,128, 255,192,203, 165,42,42,&
         0,0,0, 255,255,255, 128,128,128, 173,216,230, 144,238,144, 139,0,0, 0,0,139,&
         0,100,0, 238,130,238, 255,215,0, 192,192,192, 230,230,250, 245,245,220,&
         64,224,208, 0,128,128, 75,0,130, 128,0,0, 128,128,0, 255,127,80, 220,20,60,&
         250,128,114, 221,160,221, 204,204,255, 152,255,152, 0,0,128, 127,255,0,&
         255,99,71, 240,230,140, 0,255,0, 135,206,235, 255,218,185/), (/3,41/))
      index=MOD(color, 41)
      outcolor(1) = color_data(1,index)
      outcolor(2) = color_data(2,index)
      outcolor(3) = color_data(3,index)
   end
   subroutine save_image(file, canvas)
      CHARACTER(len=64) :: file
      INTEGER(4), DIMENSION(100,100,3) :: canvas
      INTEGER(4) :: i, j
      open(9, file=TRIM(file)//".ppm", status='replace')
      write(9, "(A)") "P3"
      write(9, "(A)") "#"//file
      write(9, "(I4,I4)") 100, 100
      write(9, "(I4)") 255
      do i = 1, 100
         do j = 1, 100
            write(9, "(I4,I4,I4)") canvas(i,j,1), canvas(i,j,2), canvas(i,j,3)
         end do
      end do
   end

   subroutine get_circle_center(turtley, turtlex, endxi, endyi, extra, centerx, centery)
    implicit none
    INTEGER(4) :: endxi, endyi, extra
    REAL(4) :: turtley, turtlex, centerx, centery, endx, endy, radius, distance, coeff, simmetry
    endx = float(endxi)
    endy = float(endyi)
    radius = float(IAND(extra, Z'00FF'))
    simmetry = float(IAND(ISHFT(extra, -8), Z'000F'))
    if(simmetry/=0)then
        simmetry=-1.0
    else
        simmetry=1
    end if
    distance = SQRT((endx-turtlex)**2+(endy-turtley)**2)
    coeff = 0.5*SQRT((2*(2*(radius**2)/distance**2))-1)
    centerx = 0.5*(endx+turtlex)+coeff*simmetry*(endy-turtley)
    centery = 0.5*(endy+turtley)+coeff*simmetry*(turtlex-endx)
   end

   subroutine draw_circle(turtley, turtlex, color, endx, endy, canvas, extra)
      implicit none
      INTEGER(4) :: color, endx, endy, extra, i
      INTEGER(4), DIMENSION(3) :: truecolor
      REAL(4) :: turtley, turtlex, step, centerx, centery, direction, vx, vy, norm, theta, radius
      INTEGER(4), DIMENSION(100,100,3) :: canvas
      direction = float(IAND(ISHFT(extra, -12), Z'000F'))
      if(direction/=0)then
        direction = -1
      else
        direction=1
      end if
      radius = float(IAND(extra, Z'00FF'))
      call get_color(color, truecolor)
      call get_circle_center(turtley, turtlex, endx, endy, extra, centerx, centery)
      theta = ABS(ATAN2(endy - centery, endx - centerx) - ATAN2(turtley - centery, turtlex - centerx))
      step = CEILING(theta*radius)
      do i = 1, int(step, 4)
        canvas(FLOOR(turtley),FLOOR(turtlex),1) = truecolor(1)
        canvas(FLOOR(turtley),FLOOR(turtlex),2) = truecolor(2)
        canvas(FLOOR(turtley),FLOOR(turtlex),3) = truecolor(3)
        vx = centerx-turtlex
        vy = centery-turtley
        norm = SQRT(vx**2+vy**2)
        turtlex = turtlex+vy/norm*direction
        turtley = turtley-vx/norm*direction
        turtlex = MOD(turtlex, 100.0)
        turtley = MOD(turtley, 100.0)
      end do
    end

   subroutine draw_line(turtley, turtlex, color, endx, endy, canvas)
      implicit none
      INTEGER(4) :: color, endx, endy, i
      INTEGER(4), DIMENSION(3) :: truecolor
      REAL(4) :: turtley, turtlex, step, stepxsize, stepysize
      INTEGER(4), DIMENSION(100,100,3) :: canvas
      call get_color(color, truecolor)
      step = MAX(ABS(turtlex-endx), ABS(turtley-endy))
      stepxsize=endx-turtlex
      stepysize=endy-turtley
      do i = 1, int(step, 4)
         canvas(FLOOR(turtley),FLOOR(turtlex),1) = truecolor(1)
         canvas(FLOOR(turtley),FLOOR(turtlex),2) = truecolor(2)
         canvas(FLOOR(turtley),FLOOR(turtlex),3) = truecolor(3)
         turtley = turtley+(stepysize)/step
         turtlex = turtlex+(stepxsize)/step
         turtlex = MOD(turtlex, 100.0)
         turtley = MOD(turtley, 100.0)
      end do
      turtlex = NINT(turtlex)
      turtley = NINT(turtley)
   end
   subroutine draw(file, drawdata, size)
      implicit none
      CHARACTER(len=64) :: file
      INTEGER(8), allocatable :: drawdata(:)
      INTEGER(8) :: command
      INTEGER(4) :: size, i, type, color, endx, endy, params
      REAL(4) :: turtley, turtlex
      INTEGER(4), DIMENSION(100,100,3), SAVE :: canvas = 255
      turtley=1.0
      turtlex=1.0
      command=0
      do i=1,size
         command = drawdata(i)
         type = int(IAND(command, Z'00000000000000FF'), 4)
         color = int(IAND(ISHFT(command, -8), Z'00000000000000FF'), 4)
         endx = int(IAND(ISHFT(command, -16), Z'000000000000FFFF'), 4)
         endy = int(IAND(ISHFT(command, -32), Z'000000000000FFFF'), 4)
         params = int(IAND(ISHFT(command, -48), Z'000000000000FFFF'), 4)
         if(type==83)then
            call draw_line(turtley, turtlex, color, endx, endy, canvas)
         else if(type==75) then
            call draw_circle(turtley, turtlex, color, endx, endy, canvas, params)
         end if
      end do
      call save_image(file, canvas)
   end
end module turtle

subroutine read_file(file)
   use turtle
   implicit none
   CHARACTER(len=64) :: file
   INTEGER(4) :: file_size, int_amount, error, i
   INTEGER(8), allocatable :: filedata(:)
   inquire(file=file, size=file_size)
   if(file_size==-1)then
      call panic("Cannot read file"//REPEAT(' ',48))
   end if
   open(9, access='stream', file=file, status='old')
   int_amount = file_size/8
   allocate(filedata(int_amount), stat=error)
   if(error /= 0) then
      call panic("Cannot read file"//REPEAT(' ',48))
   end if
   do i=1,int_amount
      read(9) filedata(i)
   end do
   close(9)

   call draw(file, filedata, int_amount)

end

program main
   implicit none
   INTEGER :: i
   CHARACTER(len=64) :: arg
   i=0
   do
      call get_command_argument(i, arg)
      if(len_trim(arg)==0) exit
      i=i+1
      if(i==2)then
         exit
      end if
   end do
   if(i/=2) then
      write(*,*) "Usage ./printer <file>"
      call exit(-1)
   end if
   call read_file(arg)

end
