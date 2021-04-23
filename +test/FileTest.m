classdef FileTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testFileRequiresNonemptyPath(self)
            % File constructor requires single non-empty stringy path.
            
            self.assertError(@() mrd.File(''), 'MATLAB:validators:mustBeNonzeroLengthText');
            self.assertError(@() mrd.File(""), 'MATLAB:validators:mustBeNonzeroLengthText');

            self.assertError(@() mrd.File(["foo", "bar"]), 'MATLAB:validation:IncompatibleSize');
            self.assertError(@() mrd.File({'foo', 'bar'}), 'MATLAB:validation:IncompatibleSize');
        end

        function testFileCanOpenExistingFile(self)
            file = mrd.File("res/acquisitions.mrd");
            
            self.verifyInstanceOf(file, ?mrd.File);
            self.verifyEqual(file.mode, "read-only");
        end

        function testDatasetIsKeyInFile(self)
            
            file = mrd.File("res/acquisitions.mrd");
            
            self.verifyTrue(file.isKey('dataset'));
            self.verifyTrue(file.isKey("dataset"));
            
            self.verifyFalse(file.isKey('not-in-the-file'));
            self.verifyFalse(file.isKey('not-in-the-file'));
        end
        
        function testAppropriateKeysForFile(self)
           
            acquisitions = mrd.File("res/acquisitions.mrd");
            images = mrd.File("res/images.mrd");
            
            self.verifyEqual(acquisitions.keys(), {'dataset'});         
            self.verifyEqual(images.keys(), {'inverted/image_0', 'simple_recon/image_0'});
        end
    end    
end

