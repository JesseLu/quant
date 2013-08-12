function [] = setup_problem(varargin)

    percent_return = double(getfield(load('percent_return.mat'), 'percent_return'));
    if ~isempty(varargin) && length(varargin) == 2
        percent_return = percent_return(1:varargin{1}, 1:varargin{2});
    end
    save('data.mat', 'percent_return');
