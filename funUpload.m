function funUpload(object_handle, event)

    global mode;
    
    mode = 'Upload';
    
    set(object_handle, 'BackGroundColor', [0.4,0.4,0.4], 'Enable', 'off');
    
end