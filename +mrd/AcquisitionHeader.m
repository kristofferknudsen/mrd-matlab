classdef AcquisitionHeader
    
    properties
        version                 (1, 1) uint16;
        
        flags                   (1, 1) uint64;
        
        measurement_uid         (1, 1) uint32;
        scan_counter            (1, 1) uint32;
        
        acquisition_time_stamp  (1, 1) uint32;
        physiology_time_stamp   (1, 3) uint32;

        number_of_samples       (1, 1) uint16;
        available_channels      (1, 1) uint16;
        active_channels         (1, 1) uint16;
        
        channel_mask            (1, 16) uint64;
        
        discard_pre             (1, 1) uint16;
        discard_post            (1, 1) uint16;
        center_sample           (1, 1) uint16;
        encoding_space_ref      (1, 1) uint16;
        trajectory_dimensions   (1, 1) uint16;
        
        sample_time_us          (1, 1) single;
        
        position                (1, 3) single;
        read_dir                (1, 3) single;
        phase_dir               (1, 3) single;
        slice_dir               (1, 3) single;
        patient_table_position  (1, 3) single;
                
        kspace_encode_step_1    (1, 1) uint16;
        kspace_encode_step_2    (1, 1) uint16;        
        average                 (1, 1) uint16;
        slice                   (1, 1) uint16;
        contrast                (1, 1) uint16;
        phase                   (1, 1) uint16;
        repetition              (1, 1) uint16;
        set                     (1, 1) uint16;
        segment                 (1, 1) uint16;
        user                    (1, 8) uint16;
        
        user_int                (1, 8) int32;
        user_float              (1, 8) single;
    end

%     properties
%         version                 ;
%         
%         flags                   ;
%         
%         measurement_uid         ;
%         scan_counter            ;
%         
%         acquisition_time_stamp  ;
%         physiology_time_stamp   ;
% 
%         number_of_samples       ;
%         available_channels      ;
%         active_channels         ;
%         
%         channel_mask            ;
%         
%         discard_pre             ;
%         discard_post            ;
%         center_sample           ;
%         encoding_space_ref      ;
%         trajectory_dimensions   ;
%         
%         sample_time_us          ;
%         
%         position                ;
%         read_dir                ;
%         phase_dir               ;
%         slice_dir               ;
%         patient_table_position  ;
%                 
%         kspace_encode_step_1    ;
%         kspace_encode_step_2    ;        
%         average                 ;
%         slice                   ;
%         contrast                ;
%         phase                   ;
%         repetition              ;
%         set                     ;
%         segment                 ;
%         user                    ;
%         
%         user_int                ;
%         user_float              ;
%     end


    methods
        
        function self = update(self, source)
            for field = fieldnames(source)'
                self.(field{1}) = source.(field{1});
            end
        end
        
    end
    
    
    methods (Static)
       
        function header = fromStruct(s)
            header = mrd.AcquisitionHeader();
            header = header.update(s);            
        end
    end
end

