classdef Dataset
    
    properties 
        Header
        Acquisitions (1, :) {mustBeArrayOf(Acquisitions, 'mrd.Acquisition')} = mrd.Acquisition.empty(1, 0);
        Waveforms (1, :) {mustBeArrayOf(Waveforms, 'mrd.Waveform')} = mrd.Waveform.empty(1, 0);
    end
    
    methods 
        function self = Dataset(header, acquisitions, waveforms)
            arguments
                header
                acquisitions (1, :) {mustBeArrayOf(acquisitions, 'mrd.Acquisition')} = mrd.Acquisition.empty(1, 0);
                waveforms (1, :) {mustBeArrayOf(waveforms, 'mrd.Waveform')} = mrd.Waveform.empty(1, 0);
            end

            self.Header = header;
            self.Acquisitions = acquisitions;
            self.Waveforms = waveforms;            
        end               
    end
end

