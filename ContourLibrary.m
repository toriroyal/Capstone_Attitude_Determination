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
% | Module: ContourLibrary
% |
% | Description:
% | Defines a class for the contour library structure

classdef ContourLibrary
    properties
        contours,
        x_max,
        y_max,
        z_max,
        y_steps,
        z_steps,
        step_size,
        variance
    end
    methods
        function obj = ContourLibrary(contours, x_max, y_max, z_max, step_size, variance)
            % Maximums exclusive like [0, x_max)
            % todo: make input an array
            
            % Convert cell to array, place into library nodes, sort
            obj.contours = quicksort(arrayfun(@(contour) LibraryNode(contour, variance), [contours{:}]));
            obj.x_max = x_max;
            obj.y_max = y_max;
            obj.z_max = z_max;
            obj.y_steps = y_max / step_size;
            obj.z_steps = z_max / step_size;
            obj.step_size = step_size;
            obj.variance = variance;
            
            if obj.y_steps == 0
                obj.y_steps = 1;
            end
            if obj.z_steps == 0
                obj.z_steps = 1;
            end
            
            % Calculate similars
            arrayfun(obj.findSimilars, obj.contours);
        end
        function findSimilars(node)
            % node : LibraryNode
            theta = node.contour.theta;
            psi = node.contour.psi;
            phi = node.contour.phi;
            half_range = obj.variance * obj.step_size;
            
            for x = theta - half_range : obj.step_size : theta + half_range
                x_norm = mod(x + obj.x_max, obj.x_max);
                
                for y = psi - half_range : obj.step_size : psi + half_range
                    y_norm = mod(y + obj.y_max, obj.y_max);
                    
                    for z = phi - half_range : obj.step_size : phi + half_range
                        z_norm = mod(z + obj.z_max, obj.z_max);
                        
                        node.addSimilar(obj.indexOf(x_norm, y_norm, z_norm));
                    end
                end
            end
        end
        function contour = getIndex(index)
            contour = obj.contours(index);
        end
        function index = indexOf(theta, psi, phi)
            % Formula: (x/(step size)*steps(y)*steps(z) + y/(step size)*steps(z) + z/(step size)) + 1
            % Assumes angles range [0, end)
            norm_theta = theta / obj.step_size;
            norm_psi = psi / obj.step_size;
            norm_phi = phi / obj.step_size;
            
            index = norm_theta * obj.y_steps * obj.z_steps + norm_psi * obj.z_steps + norm_phi + 1;
        end
        function bind(theta, psi, phi)
            if theta > obj.x_max - obj.step_size || theta < 0
                error('Theta out of bounds');
            end
            if psi > obj.y_max - obj.step_size || psi < 0
                error('Psi out of bounds');
            end
            if phi > obj.z_max - obj.step_size || phi < 0
                error('Phi out of bounds');
            end
        end
        function [contour, similars] = get(theta, psi, phi)
            obj.bind(theta, psi, phi);
            index = obj.indexOf(theta, psi, phi);
            found = obj.contours(index);
            contour = found.contour;
            similars = arrayfun(@(sim_index) obj.contours(sim_index), found.similars);
        end
    end
end
