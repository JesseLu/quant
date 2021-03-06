function y = sum_log( x, dim )

%SUM_LOG Internal CVX version.

cvx_expert_check( 'sum_log', x );
error( nargchk( 1, 2, nargin ) ); %#ok
if nargin == 2,
    y = size( x, dim ) * log( geo_mean( x, dim ) );
else
    y = length( x ) * log( geo_mean( x ) );
end

% Copyright 2005-2013 CVX Research, Inc.
% See the file COPYING.txt for full copyright information.
% The command 'cvx_where' will show where this file is located.
