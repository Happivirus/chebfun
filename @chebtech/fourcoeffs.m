function out = fourcoeffs(f, N)
%FOURCOEFFS   Fourier coefficients of a CHEBTECH.
%   C = FOURCOEFFS(F) returns the Fourier coefficients of F using
%   complex-exponential form.  Specifically, for N=length(F)
%    If N is odd
%       F(x) = C(1)*z^(N-1)/2 + C(2)*z^((N-1)/2-1) + ... + C((N+1)/2) + ... 
%                + C(N)*z^(-(N-1)/2)
%    If N is even
%       F(x) = C(1)*z^(N/2-1) + C(2)*z^(N/2-2) + ... + C(N/2) + ...
%                + C(N-1)*z^(-N/2-1) + 1/2*C(N)*(z^(N/2) + z^(-N/2))
%   where z = exp(1i*pi*x).
%
%   A = FOURCOEFFS(F, N) truncates or pads the vector C so that N coefficients
%   of the CHEBTECH F are returned.
%
%   If F is array-valued with M columns, then C is an MxN matrix.
%
% See also CHEBCOEFFS, LEGCOEFFS.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% TODO: Is there a fast transfrom from Fourier to Chebyshev?

if ( nargin == 1 )
    N = length(f);
end

% Trivial empty case:
if ( isempty(N) || N <= 0)
    out = [];
    return
end

% Allocate storage:
[~, numCols] = size(f);
out = zeros(N, numCols);

% Handle the possible non-symmetry in the modes.
if ( mod(N, 2) == 1 )
    modes = (N-1)/2:-1:-(N-1)/2;
else
    modes = N/2-1:-1:-N/2;
end

% Compute the coefficients via inner products:
coeffsIndex = 1;
for k = modes
    % Construct kth Fourier mode using f's CHEBTECH type.
    F = f.make(@(x) exp(-1i*pi*k*x));  
    out(coeffsIndex,:) = 0.5*sum(F.*f);
    coeffsIndex = coeffsIndex + 1;
end

end