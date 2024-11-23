clear; clc
E = 200000; d =25; A = ((d^2)*%pi)/4; EA=E*A; F = -1000; //Material: steel (MPA)
cd = 1000; //cube dimensions
node = [0,0,0;
        0,0,cd;
        cd,0,0;
        cd,0,cd;
        cd,cd,cd;
        0,cd,0;
        0,cd,cd];
