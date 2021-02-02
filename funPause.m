function funPause(object_handle, event, start_button, pause_button, reset_button,...
                        upload_button, save_button)
    
    global mode
    mode = 'Pause';
    
    set(start_button, 'BackGroundColor', 'g', 'Enable', 'on');
    set(object_handle, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off'); 
    set(reset_button, 'BackGroundColor', 'r', 'Enable', 'on');
    
    set(start_button, 'Visible', 'on', 'Enable', 'on');
    set(pause_button, 'Visible', 'on', 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    
    set(reset_button, 'Visible', 'on', 'BackGroundColor', 'r', 'Enable', 'on');
    set(save_button, 'BackGroundColor', 'y', 'Enable', 'on', 'Visible', 'on');
    
    set(upload_button, 'BackGroundColor', 'y', 'Enable', 'on', 'Visible', 'on');
    
    set(upload_button, 'BackGroundColor', 'y', 'Enable', 'on');
    set(save_button, 'BackGroundColor', 'y', 'Enable', 'on');
    
end