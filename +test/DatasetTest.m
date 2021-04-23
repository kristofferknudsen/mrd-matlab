classdef DatasetTest < matlab.unittest.TestCase

    methods (Test)

        function testReadingDatasetFromFile(self)
            file = mrd.File("res/acquisitions.mrd");
            dataset = file("dataset");
            
            self.verifyInstanceOf(dataset, ?mrd.Dataset);
        end

        
        
    end
end

