
function localprint(f,varargin)
% localprint - for flexible ouput writing (to buffer or file)

if isstruct(f)
	s=sprintf(varargin{:});
	if length(f.buffer)<f.n+length(s)
		f.buffer(end+length(s)+1000)=char(0);
	end
	n=f.n+length(s);
	f.buffer(f.n+1:n)=s;
	f.n=n;
	assignin('caller','f',f)
	% This is not so nice Matlab-code, but prevents adding
	%     f=localp.... everywhere.
else
	fprintf(f,varargin{:});
end
end