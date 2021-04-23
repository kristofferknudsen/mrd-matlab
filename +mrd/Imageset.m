classdef Imageset
    
    properties
        Images (1, :) {mustBeArrayOf(Images, 'mrd.Image')} = mrd.Image.empty(1, 0);
    end
    
    methods
        function self = Imageset(images)
            arguments
                images (1, :) {mustBeArrayOf(images, 'mrd.Image')} = mrd.Image.empty(1, 0)
            end
            
            self.Images = images;
        end
    end
end

