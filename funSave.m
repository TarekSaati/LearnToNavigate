function funSave(object_handle, event)

    global mode;
    
    mode = 'Save';
    set(object_handle, 'BackGroundColor', [0, 1, 1], 'Enable', 'off');
    
end