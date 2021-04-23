classdef Acquisition
    
    properties
        header (1, 1) mrd.AcquisitionHeader
        data single
        trajectory single
    end
    
    methods
        function self = Acquisition(header, data, trajectory)
            arguments
                header (1, 1) mrd.AcquisitionHeader
                data single
                trajectory single = []
            end
            
            self.header = header;
            self.data = data;
            self.trajectory = trajectory;
        end
    end
end

