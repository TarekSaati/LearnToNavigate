function [h_plot, h_button, NN_panel] = createSimulation(xlimit, ylimit, max_trials, ...
                                         max_steps, alpha, gamma, epsilon)
    %% ----- GUI for simulation
                                                                                    
    close all;
    figure('Position', [350, 60, 1050, 850]); 
    h_tab = uitabgroup; 
    
    %% ----- Tab : Neural Network
    global h_text
    tab = uitab(h_tab, 'title','Neural Network');

    NN_panel = uipanel(tab, 'title', 'Neural Network method');

    plot1 = axes('parent', NN_panel, 'XLim', xlimit, 'YLim', ylimit,'Box', 'on', ...
                'Position', [0.06, 0.57, 0.4, 0.4]);

    plot2 = axes('parent', NN_panel, 'Box', 'on', ...
                'Position', [0.56, 0.57, 0.4, 0.4]);

    plot3 = axes('parent', NN_panel, 'Box', 'on', ...
                'Position', [0.06, 0.075, 0.4, 0.4]);        

    info_string1 = sprintf('%s%14d%20s%15d%24s%10.2f', 'Trials:', 0, 'Actions:', 0, 'Total reward:', 0);
    info_string1 = sprintf('%s\n%s%15.3f%17s%16.3f%14s%15.3f', info_string1, 'Q1:', 0.00000, 'Q2:', 0.000, 'Q3:', 0.000);                
    info_string1 = sprintf('%s\n%s%9.3f%20s%14d%15s%15.6f', info_string1, 'Q_est:', 0.000, 'Crash:', 0, 'cost:', 0.000000);
    
    
    tekst_panel1 = uipanel(NN_panel, 'title', 'Current Information','Position', [0.54, 0.39, 0.42, 0.125]);
    
    text = uicontrol(tekst_panel1, 'Style', 'text', 'HorizontalAlignment', 'left', ... 
                        'FontSize', 11, 'FontName', 'Calibri', 'String', info_string1, 'Position', [40, 0, 500, 60]);
    

                    
    tekst_panel2 = uipanel(NN_panel, 'title', 'Params','Position', [0.54, 0.032, 0.2, 0.31]);

    
    info_string2 = sprintf('%s%15d\n\n%s%13d\n\n%s%24.4f\n\n%s%21.4f\n\n%s%21.5f',... 
                        'Maxtrials:', max_trials, 'Maxsteps:', max_steps,...
                        'alpha:', alpha, 'gamma:', gamma, 'Epsilon:', epsilon);

                    
    uicontrol(tekst_panel2, 'Style', 'text', 'HorizontalAlignment', 'left', ... 
                        'FontSize', 11, 'FontName', 'Calibri', 'String', info_string2, 'Position', [20, 0, 300, 215]);                


    start_button = uicontrol(NN_panel, 'Style', 'pushbutton', 'BackGroundColor', 'g', 'String', 'Start', 'Position', [800, 180, 90, 45]);
    
    pause_button = uicontrol(NN_panel, 'Style', 'pushbutton', 'BackGroundColor', [0.4,0.4,0.4],...
                                'Enable', 'off', 'String', 'Pause', 'Position', [920, 180, 90, 45]);
                            
    upload_button = uicontrol(NN_panel, 'Style', 'pushbutton', 'BackGroundColor', 'y',...
                                'Enable', 'on', 'String', 'Upload', 'Position', [800, 100, 90, 45]);
                            
    save_button = uicontrol(NN_panel, 'Style', 'pushbutton', 'BackGroundColor', [0.4,0.4,0.4],...
                                'Enable', 'off', 'String', 'Save', 'Position', [920, 100, 90, 45]);                        
                            
    reset_button = uicontrol(NN_panel, 'Style', 'pushbutton', 'BackGroundColor', [0.4,0.4,0.4],...
                                'Enable', 'off', 'String', 'Reset', 'Position', [855, 20, 100, 50]);
    
    %% ----- Callback functions
    
    set(start_button, 'callback', {@funStart, start_button, pause_button,... 
                                    reset_button, upload_button, save_button});
    
    set(pause_button, 'callback', {@funPause, start_button, pause_button, reset_button,...
                                    upload_button, save_button});
    
    
    set(reset_button, 'callback', {@funReset, start_button, pause_button, save_button});
    set(upload_button, 'callback', @funUpload);
    set(save_button, 'callback', @funSave);
    
    %% ----- Headers
    h_plot = [plot1, plot2, plot3]; 
    h_text = text;
    h_button = [start_button, pause_button, reset_button, upload_button, save_button];

end