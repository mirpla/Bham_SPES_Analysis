function [Loc1, mLoc] = CalcChanLoc(x1,x2) 

u   = (x2-x1)/norm(x2-x1);
distance   = ([-3,0:5:30])';
Loc1 = x1 + distance*u;
mLoc = x1 + -4.5*u;

% distance   = ([-2.5,0:5:30])';
% Loc2 = x1 + distance*u;

