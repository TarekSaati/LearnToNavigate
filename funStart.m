function funStart(object_handle, event, start_button, pause_button,... 
                    reset_button, upload_button, save_button)
    
    global mode;
    mode = 'Start';
    
    set(object_handle, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    set(pause_button, 'BackGroundColor', 'b', 'Enable', 'on');
    set(reset_button, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');

    set(upload_button, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    set(save_button, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
     
    disp('Neural Network Start!');
    
end