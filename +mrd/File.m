classdef File < handle & matlab.mixin.CustomDisplay
      
    properties (GetAccess=public, SetAccess=immutable)
        path string 
        mode string
    end

    properties (GetAccess=public, SetAccess=immutable, Transient, Hidden)
        fid
    end
        
    methods
        function self = File(path, mode)
            arguments
               path (1, 1) string {mustBeTextScalar, mustBeNonzeroLengthText}
               mode (1, 1) string {mustBeMember(mode, ["read-only", "read-write"])} = "read-only"
            end

            self.path = path;
            self.mode = mode;
            
            if ~exist(path, 'file')
                fid = H5F.create(path, 'H5F_ACC_EXCL', H5P.create('H5P_FILE_CREATE'), H5P.create('H5P_FILE_ACCESS'));
                H5F.close(fid);
            end

            self.fid = H5F.open(path, self.fileModes(mode), 'H5P_DEFAULT');
        end
        
        function delete(self)           
            H5F.close(self.fid);
        end        
        
        function varargout = subsref(self, S)
            switch S(1).type
                case '.'
                    % Accessing fields forwarded to builtin subsref
                    % implementation.
                    [varargout{1:nargout}] = builtin('subsref', self, S);
                case '()'
                    % Call read for each of the groups supplied.
                    [varargout{1:nargout}] = cellfun(@self.read, S.subs);
                case '{}'
                    exceptionId = "MATLAB:cellRefFromNonCell";
                    exceptionMessage = "Brace indexing is not supported for variables of this type.";
                    throwAsCaller(MException(exceptionId, exceptionMessage));
            end            
        end
    end            
    
    methods
        function dataset = read(self, groupname)
            arguments
                self
                groupname {mustBeTextScalar, mustBeNonzeroLengthText}                
            end
           
            if self.pathIsValidDataset(groupname)
                source = mrd.details.FileSource(self, groupname);
                
                dataset = mrd.Dataset( ...
                    mrd.serialization.xml.deserialize(source.getString("/xml")), ...
                    source.getAcquisitions("/data") ...
                );
            
                return
            end
            
            if self.pathIsValidImageset(groupname)
                dataset = mrd.details.FileImageset(mrd.details.FileSource(self, groupname));
                return
            end
            
            errorId = "mrd:File:groupContainsNoData";
            errorMessage = "File contains no valid MRD dataset at: " + groupname;
            throwAsCaller(MException(errorId, errorMessage));            
        end
        
        function write(self, groupname, dataset)
            arguments
                self
                groupname {mustBeTextScalar, mustBeNonzeroLengthText}
                dataset {mustBeA(dataset, "mrd.Dataset", "mrd.Imageset")}
            end
           
            disp("Write: " + groupname);            
            disp(dataset);            
        end
        
    end   

    methods
        function tf = isKey(self, key)
            arguments
                self
                key {mustBeText} 
            end
            tf = ismember(key, self.listValidGroups());            
        end
        
        function keySet = keys(self)
            arguments
                self
            end
            
            keySet = arrayfun(@convertStringsToChars, self.listValidGroups(), 'UniformOutput', false);
        end
        
        function valueSet = values(self, keySet)
            arguments
                self
                keySet
            end
            
            % TODO: Something. 
        end
    end
        
    methods (Access=private)

        function groups = listValidGroups(self)
            
            function [status, opdata] = iter_func(~, groupname, opdata)
                
                if self.pathIsValidDataset(groupname) || self.pathIsValidImageset(groupname)
                    opdata = [opdata, string(groupname)];
                end
                
                status = 0;
            end
            
            [error, groups] = H5O.visit_by_name(self.fid, '/', 'H5_INDEX_NAME', 'H5_ITER_NATIVE', @iter_func, [], 'H5P_DEFAULT');
            
            if error
                errorId = "mrd:File:groupsFromFile";
                errorMessage = "Failed getting groups from file: %s";
                throwAsCaller(MException(errorId, errorMessage, self.path));
            end            
        end
        

        function tf = pathIsValidDataset(self, path)
            
            tf = ...
                self.pathExists(path) && ...
                self.pathHasType(path, 'H5G_GROUP') && ...
                self.pathHasChild(path, "/xml") && ...
                self.pathHasType(path + "/xml", 'H5G_DATASET') && ...
                self.pathHasChild(path, "/data") && ...
                self.pathHasType(path + "/data", 'H5G_DATASET') && ...
               ~self.pathHasChild(path, "/header");
        end
        
        function tf = pathIsValidImageset(self, path)
            
            tf = ...
                self.pathExists(path) && ...
                self.pathHasType(path, 'H5G_GROUP') && ...
                self.pathHasChild(path, "/header") && ...
                self.pathHasType(path + "/header", 'H5G_DATASET') && ...
                self.pathHasChild(path, "/data") && ...
                self.pathHasType(path + "/data", 'H5G_DATASET') && ...
                self.pathHasChild(path, "/attributes") && ...
                self.pathHasType(path + "/attributes", 'H5G_DATASET') && ...
               ~self.pathHasChild(path, "/xml") && ...
               ~self.pathHasChild(path, "/waveforms");             
        end
        
        function tf = pathExists(self, path)
            tf = H5L.exists(self.fid, path, 'H5P_DEFAULT');            
        end
        
        function tf = pathHasType(self, path, type)

            obj_id = H5O.open(self.fid, path, 'H5P_DEFAULT');
            obj_info = H5O.get_info(obj_id);
            
            tf = obj_info.type == H5ML.get_constant_value(type);            
            
            H5O.close(obj_id);
        end
        
        function tf = pathHasChild(self, path, child)
            
            group_id = H5G.open(self.fid, path);
            group_info = H5G.get_info(group_id);

            function name = getName(index)

                obj_id = H5O.open_by_idx(self.fid, path, 'H5_INDEX_NAME', 'H5_ITER_NATIVE', index, 'H5P_DEFAULT');
                
                name = string(H5I.get_name(obj_id, 'TextEncoding', 'UTF-8'));

                H5O.close(obj_id);
            end
            
            tf = any(arrayfun(@(index) endsWith(getName(index), child), 0:group_info.nlinks-1)); 
            
            H5G.close(group_id);            
        end
    end
    
    methods (Access = protected)
        % These methods plug into the CustomDisplay mixin. They govern how
        % Files are displayed.
    end
    
    methods 
       
        
        
    end
    
    properties (GetAccess=private, Constant)
        fileModes = containers.Map({'read-only', 'read-write'}, {'H5F_ACC_RDONLY', 'H5F_ACC_RDWR'})
    end
end
