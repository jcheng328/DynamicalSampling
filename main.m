%{
================================================================
        Dynamical Sampling for random synthetic system
================================================================
 
This scrips construct linear evolution system and recover the eigenvalues from the observations.

**************** Examples and explanations ****************
1) How to use the existed examples, e.g., <Toy_Example_1>.
Change the property of <Data_Mode> for <Toy_Example_1> to true, and others to false.

2) How to add new examples, e.g., <Toy_Example_3>
Add 

*Note:
Our algorithm reckons much on the numerical rank r.

----------------------------------------------------------------------------------
Copyright (c) 2021, Sui Tang, Jiahui Cheng
%}

clear all;
clc; close all; warning off; addpath(genpath("./utils")); addpath(genpath("./dataset"));


%% %%%%%%%%%%%%%%%%%%%%%%%% Default settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default options
opts.dst_fig = 'figures'; opts.dst_html = 'result'; opts.dst_dataset = 'dataset';
key = fieldnames(opts);
for k = 1 : numel(key)
    mkdir(sprintf("./%s",opts.(key{k})))
end
% rng('default');
sympref("MatrixWithSquareBrackets",'default');

%% %%%%%%%%%%%%%%%%%%%%%%%% Additional Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{ Flow chart:
 %                                                                  default settings
 %                                                                         |
 %                                                                         |
 % example_settings(1) ---|-- expsettings(1) ---|-- test_settings(1)-------+-------- instance_settings
 %                        |                     |-- test_settings(2)-------+-------- instance_settings                     
 %                        |                                            
 %                        |-- expsettings(2) ---|-- test_settings(1)-------+-------- instance_settings
 %                        |                     |-- test_settings(2)-------+-------- instance_settings
 %                        |                                   
 %                        |-- ...
 %
 % example_settings(2) ---|-- expsettings(1) ---|-- test_settings(1)-------+-------- instance_settings
 %                        |                     |-- test_settings(2)-------+-------- instance_settings
 %                        |-- ...
 %
 % example_settings(3) ---|-- expsettings(1) ---|-- test_settings(1)-------+-------- instance_settings
 %                        |                     |-- test_settings(2)-------+-------- instance_settings
 %                        |-- ...                     
 %
 % ...
%}

%{ Sample test settings looks like:
 % noise_activation
 % noise_type
 % noise_stdv
%  noise_snr
 % cadzow_denoise_activation
 % cadzow_denoise_max_iter
 % temporal_size
 % numberical_rank
 % verbose
 % method_lst
 % viewpoints
%}
% These settings are stored in JSON file, please modify the options in 
% JSON file instead of here.

%% Get default and example settings
settings_path = "./settings.json";
mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]); % This concatenate two structs IF AND ONLY IF there are no common fields (duplicate fields) in the 2 structures.
default_settings = mergestructs(opts, get_default_settings(settings_path));  % get a struct of default settings.
example_settings_map = get_example_settings(settings_path); % get a container.Map of examples and settings

%% run each example separately and save the figures and results.
for egname = keys(example_settings_map)
    fprintf("\n[%-6s %*c] %-20s\n","Runing",5," ",sprintf("Experiment %s:", string(egname)));
    % create directory for figures and htmls
    create_linear_system(egname, default_settings);
    exp_settings_map = parse(example_settings_map(string(egname))); % get a container.Map of experiments and settings
    if isKey(exp_settings_map, "viewpoints")
        viewpoints = exp_collections("viewpoints"); 
        % TODO: construct a data info loader.
    end
    
    % run each experiment.
    for expname = keys(exp_settings_map)
        test_settings = parse(exp_settings_map(string(expname)));
        % generate head
        latex_exp = latex_head(test_settings);
        for testname = keys(test_settings)
            % modify the default options.
            instance_settings = modify_settings(egname, expname, testname, default_settings, parse(test_settings(string(testname)))); % get a struct of test settings
            
            % simulate the partial observed system.
            [observ, spec, instance_settings] = get_linear_system(egname, instance_settings); % get a linear evolutional system with the test settings.
            
            % test errors of various methods.
            [speclst, instance_settings] = test_linear_system(observ, instance_settings); 

            % record the numerical result. 
            latex_test = evaluate_test(speclst, instance_settings); % get numerical result 
            
            % concatenate
            for k = 1: numel(latex_exp)
                latex_exp{k} = strcat(latex_exp{k},latex_test{k});
            end  
        end
        
        
        % print the overall result and its corresponding latex source code.
        disp(string(egname)+newline+string(expname)+newline+"*** Latex ***")
        for latex_block = latex_exp
            disp(string(latex_block));
        end
        
    end
    fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("Experiment %s", string(egname)));
end

%% safely return
disp(" Program exits with code 0"); % exit the main program.


