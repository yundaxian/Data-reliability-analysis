function y = SMOOTH( x, po, fl )
% This function applies a Savitzky-Golay FIR smoothing filter to the data in vector x. 
% If x is a matrix, sgolayfilt operates on each column. 
% The polynomial order, order, must be less than the frame length, framelen, and in turn framelen must be odd. 
% If order = framelen-1, the filter produces no smoothing..
polynomialOrder = po;
windowWidth = fl;
% Savitzky-Golay sliding polynomial filter
y = sgolayfilt(x, polynomialOrder, windowWidth);

