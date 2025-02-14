% | MIT License
% | 
% | Copyright (c) 2019 Sierra MacLeod
% | 
% | Permission is hereby granted, free of charge, to any person obtaining a copy
% | of this software and associated documentation files (the "Software"), to deal
% | in the Software without restriction, including without limitation the rights
% | to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% | copies of the Software, and to permit persons to whom the Software is
% | furnished to do so, subject to the following conditions:
% | 
% | The above copyright notice and this permission notice shall be included in all
% | copies or substantial portions of the Software.
% | 
% | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% | IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% | FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% | AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% | OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% | SOFTWARE.
% |===============================================================================
% |
% | Module: Compare
% |
% | Description:
% | Function `compare` takes two image mask cells
% | and returns an inner product calculation for
% | input comparison

function [scores] = compare(epsilon_lib_contours, vid_contours)
    scores = cellfun(@(input) max_index(diff(epsilon_lib_contours, input)), vid_contours, 'UniformOutput', false);
end

function [scores] = diff(epsilon_lib_contours, vid_contour)
    scores = cellfun(@(frame) frame.contour(:)'*vid_contour(:), epsilon_lib_contours, 'UniformOutput', false);
end

function [index] = max_index(a)
    [~, index] = max([a{:}]);  % comes in as cell, convert to array and max
end