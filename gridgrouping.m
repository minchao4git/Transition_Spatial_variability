%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: gridgrouping
% File: gridgrouping.m
%
% Authors : Minchao Wu
% Date : 2018-10-01

% Description: to group values for matrix
% Input: matrix to be groupped
%        groupping scalar for x dimension
%        groupping scalar for y dimension
%
% Output: matrix after groupping
% Output format : matrix

function [ mat_out ] = gridgrouping( mat_in, x_scale, y_scale)

    % x_scale is only for the x dimension of the mat_in
    new_nx=size(mat_in,1)/x_scale;
    new_ny=size(mat_in,2)/y_scale;
    
    mat_out=zeros(new_nx,new_ny);
    mat_out_freq=zeros(new_nx,new_ny);
    
    for i=1:size(mat_in,1)
        for j=1:size(mat_in,2)
            
            new_i=ceil(i/x_scale);
            new_j=ceil(j/y_scale);
            
            if ~isnan(mat_in(i,j)) && abs(mat_in(i,j))>= 0
                
                mat_out_freq(new_i,new_j)=mat_out_freq(new_i,new_j)+1;
                mat_out(new_i,new_j) = mat_out(new_i,new_j)+mat_in(i,j);
                
            end
        end
    end
    
    mat_out=mat_out./mat_out_freq;
    
end
