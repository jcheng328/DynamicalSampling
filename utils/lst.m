
function name = lst(parser, complement)
%LST   Find fieldnames of true elements.
%   name = lst(parser) returns the fieldsnames of elementswhose value is
%   true (for boolean array) or 1 (for int array).
    arguments
       parser containers.Map
       complement logical=false
    end
    value_set = values(parser);
    key_set = keys(parser);
    if ~complement
        idx = find([value_set{:}]);
    else
        idx = find(~[value_set{:}]);
    end
    name = key_set(idx);
end