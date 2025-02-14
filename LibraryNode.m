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
% | ==============================================================================
% |
% | Module: LibraryNode
% |
% | Description:
% | Defines a class for the contour library node

classdef LibraryNode
    properties
        contour,
        similars,
        iter_index,
        hash
    end
    methods
        function obj = LibraryNode (contour, variance)
            obj.contour = contour;
            obj.hash = contour.hash;
            obj.similars = zeros(1, (2 * variance + 1)^3);
            obj.iter_index = 1;
        end
        function obj = addSimilar (obj, index)
            obj.similars(obj.iter_index) = index;
            %fprintf('I just added a similar!!!!');
            obj.iter_index = obj.iter_index + 1;
            %fprintf('I just added to index!!!!');
        end
        function tf = eq(A, B)
            tf = A.contour == B.contour;
        end
        function tf = lt(A, B)
            tf = A.contour < B.contour;
        end
        function tf = gt(A, B)
            tf = A.contour > B.contour;
        end
    end
end