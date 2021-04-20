function [dataset, file] = open(filename, groupname, mode)
    arguments
        filename (1, 1) string {mustBeNonzeroLengthText}
        groupname (1, 1) string {mustBeNonzeroLengthText}
        mode string {mustBeMember(mode, ["read-only", "read-write"])} = "read-only"
    end

    file = mrd.File(filename, mode);
    dataset = file(groupname);
end

