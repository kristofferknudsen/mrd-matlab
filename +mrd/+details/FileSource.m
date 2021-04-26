classdef FileSource
    
    properties (GetAccess=private, SetAccess=immutable)
        file
        base
    end
    
    methods
        function self = FileSource(file, base)           
            self.file = file;
            self.base = base;
        end
    end
    
    methods 
        function str = getString(self, key)

            id = H5D.open(self.file.fid, self.fullGroupName(key));
            type = H5D.get_type(id);
            
            raw = H5D.read(id, type, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

            if H5T.is_variable_str(type)
                str = raw{1};
            else
                str = raw';
            end
            
            H5T.close(type);
            H5D.close(id);
        end                
        
        function acquisitions = getAcquisitions(self, key, selection)
            
            dataset = H5D.open(self.file.fid, self.fullGroupName(key));
            space = H5D.get_space(dataset);
            [~, dims, ~] = H5S.get_simple_extent_dims(space);
            memory = H5S.create_simple(1, dims, []);

            if nargin == 2
                % No selection provided; grab all the things!
                selection.start = 0;
                selection.stride = [];
                selection.count = [];
                selection.block = dims;
            end
                        
            H5S.select_hyperslab( ...
                space, ...
                'H5S_SELECT_SET', ...
                selection.start, ...
                selection.stride, ...
                selection.count, ...
                selection.block ...
            );
        
            raw = H5D.read(dataset, mrd.serialization.hdf5.acquisition, memory, space, 'H5P_DEFAULT');

            acquisitions = prepareAcquisitions(raw);
            
            H5S.close(memory);
            H5S.close(space);
            H5D.close(dataset);
        end
        
        function n = countElements(self, key) 

            dataset = H5D.open(self.file.fid, self.fullGroupName(key));
            space = H5D.get_space(dataset);
            [~, dimensions, ~] = H5S.get_simple_extent_dims(space);
            
            n = dimensions(1);
            
            H5S.close(space);
            H5D.close(dataset);            
        end
    end
    
    methods (Access=private)
        
        function group = fullGroupName(self, group)
            group = self.base + group;            
        end
        
    end
end


function acquisitions = prepareAcquisitions(raw)

    profile on;

    count = numel(raw.head.version);

    function headers = splitHeaders(raw)
        
        headers = cell(count, 1);
        idx = raw.idx; raw = rmfield(raw, 'idx');
        
        function val = correct(val)
            if size(val, 2) == 1
                val = reshape(val, 1, count);
            end
        end

        raw = structfun(@correct, raw, 'UniformOutput', false);
        idx = structfun(@correct, idx, 'UniformOutput', false);
        
        function slice = takeSlice(raw, index)
            slice = structfun(@(val) val(:, index), raw, 'UniformOutput', false);        
        end
        
        for i = 1:count
            headers{i} = mrd.AcquisitionHeader();
            headers{i} = headers{i}.update(takeSlice(raw, i));
            headers{i} = headers{i}.update(takeSlice(idx, i));
        end
    end

    headers = splitHeaders(raw.head);

    for j = 1:count
        acquisitions(j) = prepareAcquisition(headers{j}, raw.data{j}, raw.traj{j});
    end
    
    
    profile off;
    profile viewer;
end

function acquisition = prepareAcquisition(header, data, traj)
    
    data = reshape( ...
        complex(data(1:2:end), data(2:2:end)), ...
        header.number_of_samples, ...
        header.active_channels ...
    );

    trajectory = reshape( ...
        traj, ...
        header.trajectory_dimensions, ...
        header.number_of_samples ...
    );

    acquisition = mrd.Acquisition(header, data, trajectory);
end





