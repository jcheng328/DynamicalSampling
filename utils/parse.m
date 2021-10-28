
function [parser] = parse(parser_field)
% parse input struct field.
    if ~isempty(fieldnames(parser_field))
        parser = containers.Map(fieldnames(parser_field), struct2cell(parser_field));
    else
        parser = containers.Map;
    end
end