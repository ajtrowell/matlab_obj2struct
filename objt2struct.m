function output = convertClassesToStructs(input)

oldWarningState = warning;
% suppress only specific warnings, use:
warning('off', 'MATLAB:structOnObject');
warning('off', 'MATLAB:class:cannotUpdateObjArrayProp');
% Or supress all warnings
% warning('off', 'all');

try


    if isobject(input)
        % Convert object to struct
        output = struct(input);
        % Recursively convert any nested objects
        output = convertClassesToStructs(output);
    elseif isstruct(input)
        % Create a new struct to hold the converted data
        output = struct();
        fields = fieldnames(input);
        if ~isempty(input)  % Check if the struct is not empty
            for i = 1:numel(fields)
                % Recursively convert each field
                output.(fields{i}) = convertClassesToStructs(input.(fields{i}));
            end
        end % If the struct is empty, output will remain an empty struct
    elseif iscell(input)
        % Create a new cell array to hold the converted data
        output = cell(size(input));
        for i = 1:numel(input)
            % Recursively convert each cell
            output{i} = convertClassesToStructs(input{i});
        end
    else
        % For non-object types, return as-is
        output = input;
    end

catch ME
    % Restore the original warning state before rethrowing the error
    warning(oldWarningState);
    rethrow(ME);
end
% Restore the original warning state
warning(oldWarningState);

end
