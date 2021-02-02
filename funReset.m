function funReset(object_handle, event, start_button, pause_button, save_button)
    
    global mode
    mode = 'Reset';
    
    set(start_button, 'BackGroundColor', 'g', 'Enable', 'on');   
    set(pause_button, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    set(object_handle, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    
    set(save_button, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    
    
end