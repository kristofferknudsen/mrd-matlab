classdef Acquisition
    
    properties
        header (1, 1) mrd.headers.Acquisition
        data
        trajectory
    end
    
    methods
        function self = Acquisition(header, data, trajectory)
            arguments
                header (1, 1) mrd.headers.Acquisition
                data
                trajectory = []
            end
            
            self.header = header;
            self.data = data;
            self.trajectory = trajectory;
        end
    end
end

