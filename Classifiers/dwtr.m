function dwtr = dwtr(data, L, filterh)
%  function dwtr = dwt(data, filterh, L);
%  Calculates the DWT of periodic data set
%  with scaling filter  filterh  and  L  scales.
%
%   Example of Use:
%   data = [1 0 -3 2 1 0 1 2]; filter = [sqrt(2)/2 sqrt(2)/2];
%   wt = DWTR(data, 3, filter)
%------------------------------------------------------------------

n = length(filterh);                %Length of wavelet filter
C = data;                           %Data \qut{live} in V_J
dwtr = [];                          %At the beginning dwtr empty
H  =  fliplr(filterh);              %Flip because of convolution
G  =  filterh;                      %Make quadrature mirror
G(1:2:n) = -G(1:2:n);               %    counterpart
for j = 1:L                         %Start cascade
    nn = length(C);                   %Length needed to
    C = [C(mod((-(n-1):-1),nn)+1) C]; % make periodic
    D = conv(C,G);                    %Convolve,
    D = D([n:2:(n+nn-2)]+1);          %  keep periodic, decimate
    C = conv(C,H);                    %Convolve,
    C = C([n:2:(n+nn-2)]+1);          %  keep periodic, decimate
    dwtr = [D,dwtr];                  %Add detail level to dwtr
end;                                %Back to cascade or end
dwtr = [C, dwtr];                   %Add the last \qut{smooth} part
end