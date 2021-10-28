% Modify <input> below to use this script to convert matlab formatted array
% to json formatted array. The matlab formatted array support 2 types of
% input: 1. number, e.g., 1 2 . 2. range, e.g., 5:10 5:2:9 .
input = '1,2,5:2:9';
input = '1:59';



vp = decode(input);
allOneString = sprintf('%.0f,' , vp);
allOneString = allOneString(1:end-1);
disp(['[',allOneString,']'])
function viewpoints = decode(input)
    viewpoints = [];
    cnt = 0;
    for chunk = split(input,',')'
        range = double(split(string(chunk),':'));
        if numel(range)==1
            cnt = cnt + 1;
            viewpoints(cnt) = range(1);
        elseif numel(range)==2
            for k = range(1):range(2)
                cnt = cnt + 1;
                viewpoints(cnt) = k;
            end
        elseif numel(range)==3
            for k = range(1):range(2):range(3)
                cnt = cnt + 1;
                viewpoints(cnt) = k;
            end
        else
            disp('Colon Error: More than 3 colons exists in one position.')
            return;
        end
    end
end