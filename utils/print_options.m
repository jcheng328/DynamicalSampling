
function [msg] = print_options(opt, print_msg)
%Print and save options

%It will print both current options and default values(if different).
%
    arguments
        opt containers.Map
        print_msg logical = true
    end
    msg = "";
    if print_msg
        msg = msg + sprintf('--------------------------------- Options -------------------------------\n');
    end
    for key = sort(opt.keys())
        comment = "";
        switch class(opt(char(key)))
        case 'double'
            if numel(opt(char(key))) == 1
                msg = msg + sprintf('%40s: %-30f %s\n', char(key), opt(char(key)), comment);
            else
                msg = msg + sprintf('%40s: %30s %s\n', char(key), print_mat(opt(char(key)), false), comment);
            end
        case 'logical'
            msg = msg + sprintf('%40s: %-30s %s\n', char(key), string(opt(char(key))), comment);
        case 'struct'
            msg = msg + sprintf('%40s: %-30s %s\n', char(key), "-------------", comment);
            msg = msg + print_options(parse(opt(char(key))), false);
        end
    end
    if print_msg
        msg = msg + sprintf('--------------------------------- End -----------------------------------\n');
    end
    if print_msg
        disp(msg);
    end
end