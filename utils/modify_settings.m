%{

    This script modifies default settings with a map

    input: default_settings      default settings
           exp_settings          settings to modify
           verbose               silent if true
%}

function instance_settings = modify_settings(egname, expname, testname, default_settings, test_settings, verbose)
    arguments
       egname string
       expname string
       testname string
       default_settings struct
       test_settings containers.Map
       verbose logical=true
    end
    instance_settings = default_settings;
    instance_settings.egname = egname;
    instance_settings.expname = expname;
    instance_settings.testname = testname;
    for name = keys(test_settings)
        instance_settings.(lower(string(name))) = test_settings(char(name));
    end
    if ~verbose
        disp(instance_settings);
    end
    
end
    