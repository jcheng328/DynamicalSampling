%{

    This script gets examples from a local file.

    input: fpath      path to the json file
           verbose    silent if true
%}

function example_settings = get_example_settings(fpath, verbose)
    arguments
       fpath string
       verbose logical=true
    end
    %% Check if the file exists locally.
    fprintf("[%-6s %*c] %-20s\n","Runing",5," ",sprintf("Getting default settings from %s.",fpath));
    if isfile("./settings.json")
        % File exists.
        fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("File exists: '%s'", fpath));
    else
        % File doesn't exist.
        error("[%*c %-5s] %-20s\n",6," ","ERROR",sprintf("No such file or directory: '%s'", fpath));
       
    end
    
    %% check if the file is a JSON filecasdf
    if ~endsWith(fpath, ".json")
        error("[%*c %-5s] %-20s\n",6," ","ERROR",sprintf("Not a JSON file: '%s'", fpath)); 
    end
    
    %% read from file
    raw = fread(fopen("settings.json"), inf); % read all characters in a JSON file
    data = jsondecode(char(raw')); % jsonify the raw data
    main_parser = parse(data); % parse to an instance of Class container.Map
    
    % parse methods
    example_settings = parse(main_parser("Example_Settings"));
    egname_list = lst(parse(main_parser("Examples")));
    for egname = keys(example_settings)
        if ~any(strcmp(egname_list,egname))
            remove(example_settings, egname);
        end
    end
    
    %% print methods
    if ~verbose
        print_options(example_settings);
    end
end
    