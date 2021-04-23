classdef Dataset
    
    properties 
        header
        acquisitions (1, :) {mrd.validation.mustBeArrayOf(acquisitions, 'mrd.Acquisition')} = mrd.Acquisition.empty(1, 0);
        waveforms (1, :) {mrd.validation.mustBeArrayOf(waveforms, 'mrd.Waveform')} = mrd.Waveform.empty(1, 0);
    end
    
    methods 
        function self = Dataset(header, acquisitions, waveforms)
            arguments
                header
                acquisitions (1, :) {mrd.validation.mustBeArrayOf(acquisitions, 'mrd.Acquisition')} = mrd.Acquisition.empty(1, 0);
                waveforms (1, :) {mrd.validation.mustBeArrayOf(waveforms, 'mrd.Waveform')} = mrd.Waveform.empty(1, 0);
            end

            self.header = header;
            self.acquisitions = acquisitions;
            self.waveforms = waveforms;            
        end               
    end
end
