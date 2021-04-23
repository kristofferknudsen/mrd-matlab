function mustBeArrayOf(input, type)
    if isa(input, type), return; end   
    if isprop(input, 'valueType') && input.valueType == meta.class.fromName(type), return; end
    
    exceptionId = 'mrd:validation:wrongArrayType';
    exceptionMessage = ['Must be array (or array-like object) of type: ', type];    
    throwAsCaller(MException(exceptionId, exceptionMessage));
end

