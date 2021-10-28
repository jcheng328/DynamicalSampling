%{

    This script gets default settings from a local file.

    input: fpath      path to the json file
           verbose    silent if true
%}

function defaultsettings = get_default_settings(fpath, verbose)
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
    
    %% parse default settings
    defaultsettings = struct();
    % parse random noise settings
    noise_parser = parse(main_parser("Noise"));
    defaultsettings.noise_activated = noise_parser("activated");
    if noise_parser("Additive_Gaussian_Noise") & ~noise_parser("Multiplicative_Gaussian_Noise")
        defaultsettings.noise_type = "Additive";
    elseif ~noise_parser("Additive_Gaussian_Noise") & noise_parser("Multiplicative_Gaussian_Noise")
        defaultsettings.noise_type = "Multiplicative";        
    elseif ~noise_parser("Additive_Gaussian_Noise") & ~noise_parser("Multiplicative_Gaussian_Noise")
        error("[%*c %-5s] %-20s\n",6," ","ERROR",sprintf("Redundant default type of noise specified: '%s'", "Additive Gaussian noise and multiplicative Gaussian noise")); 
    else
        error("[%*c %-5s] %-20s\n",6," ","ERROR",sprintf("No default type of noise specified: '%s'", "Neither additive Gaussian noise nor multiplicative Gaussian noise")); 
    end
    defaultsettings.noise_snr = noise_parser("snr");
    defaultsettings.noise_stdv = noise_parser("stdv");
    
    % parse cadzow denoising related settings
    cadzow_parser = parse(main_parser("Cadzow_Denoise"));
    defaultsettings.cadzow_denoise_activated = cadzow_parser("activated");
    defaultsettings.cadzow_denoise_max_iter = cadzow_parser("max_iter");
    
    % parse other default settings
    defaultsettings.temporal_size = main_parser("Temporal_Size");
    defaultsettings.numerical_rank = main_parser("Numerical_Rank");
    defaultsettings.verbose = main_parser("verbose");
    defaultsettings.method_lst = lst(parse(main_parser("Method")));
    
    
    %% print default settings
    if ~verbose
        print_options(parser);
    end
    
end