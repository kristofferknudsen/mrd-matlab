function type = acquisition()
    head = acquisitionHeader();
    traj = H5T.vlen_create(H5T.copy('H5T_NATIVE_FLOAT'));
    data = H5T.vlen_create(H5T.copy('H5T_NATIVE_FLOAT'));

    type = H5T.create ('H5T_COMPOUND', 376);
    H5T.insert(type, 'head', 0, head);
    H5T.insert(type, 'traj', 344, traj);
    H5T.insert(type, 'data', 360, data);
end

function header = acquisitionHeader()
    header = H5T.create('H5T_COMPOUND', 340);
    H5T.insert(header, 'version', 0, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'flags', 2, 'H5T_NATIVE_UINT64');
    H5T.insert(header, 'measurement_uid', 10, 'H5T_NATIVE_UINT32');
    H5T.insert(header, 'scan_counter', 14, 'H5T_NATIVE_UINT32');
    H5T.insert(header, 'acquisition_time_stamp', 18, 'H5T_NATIVE_UINT32');
    H5T.insert(header, 'physiology_time_stamp', 22, H5T.array_create('H5T_NATIVE_UINT32', [3]));
    H5T.insert(header, 'number_of_samples', 34, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'available_channels', 36, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'active_channels', 38, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'channel_mask', 40, H5T.array_create('H5T_NATIVE_UINT64', [16]));
    H5T.insert(header, 'discard_pre', 168, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'discard_post', 170, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'center_sample', 172, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'encoding_space_ref', 174, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'trajectory_dimensions', 176, 'H5T_NATIVE_UINT16');
    H5T.insert(header, 'sample_time_us', 178, 'H5T_NATIVE_FLOAT');
    H5T.insert(header, 'position', 182, H5T.array_create('H5T_NATIVE_FLOAT', [3]));
    H5T.insert(header, 'read_dir', 194, H5T.array_create('H5T_NATIVE_FLOAT', [3]));
    H5T.insert(header, 'phase_dir', 206, H5T.array_create('H5T_NATIVE_FLOAT', [3]));
    H5T.insert(header, 'slice_dir', 218, H5T.array_create('H5T_NATIVE_FLOAT', [3]));
    H5T.insert(header, 'patient_table_position', 230, H5T.array_create('H5T_NATIVE_FLOAT', [3]));
    
    H5T.insert(header, 'idx', 242, encodingCounters());
    
    H5T.insert(header, 'user_int', 276, H5T.array_create('H5T_NATIVE_INT32', [8]));
    H5T.insert(header, 'user_float', 308, H5T.array_create('H5T_NATIVE_FLOAT', [8]));    
end


function idx = encodingCounters()
    idx = H5T.create ('H5T_COMPOUND', 34);
    H5T.insert(idx, 'kspace_encode_step_1', 0, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'kspace_encode_step_2', 2, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'average', 4, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'slice', 6, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'contrast', 8, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'phase', 10, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'repetition', 12, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'set', 14, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'segment', 16, 'H5T_NATIVE_UINT16');
    H5T.insert(idx, 'user', 18, H5T.array_create('H5T_NATIVE_UINT16',[8]));
end