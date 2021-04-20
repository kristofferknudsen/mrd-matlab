classdef FileTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testFileRequiresNonemptyPath(self)
            % File constructor requires single non-empty stringy path.
            
            self.assertError(@() mrd.File(0),  'MATLAB:validators:mustBeNonzeroLengthText');
            self.assertError(@() mrd.File(''), 'MATLAB:validators:mustBeNonzeroLengthText');
            self.assertError(@() mrd.File(""), 'MATLAB:validators:mustBeNonzeroLengthText');

            self.assertError(@() mrd.File(["foo", "bar"]), 'MATLAB:exist:firstInputString');
            self.assertError(@() mrd.File({'foo', 'bar'}), 'MATLAB:exist:firstInputString');
        end
        
        function testFile(self)
        
            
        end
    end    
end

