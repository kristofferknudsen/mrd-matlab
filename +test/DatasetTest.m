classdef DatasetTest < matlab.unittest.TestCase

    methods (Test)

        function testReadingDatasetFromFile(self)
            file = mrd.File("res/acquisitions.mrd");
            dataset = file("dataset");
            
            self.verifyInstanceOf(dataset, ?mrd.Dataset);
        end

        function testReadingImagesetFromFile(self)
            file = mrd.File("res/images.mrd");
            imageset = file("inverted/images_0");
            
            self.verifyInstanceOf(iamgeset, ?mrd.Imageset);
        end
    end
end

