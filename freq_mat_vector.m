%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: freq_mat_vector
% File: freq_mat_vector.m
%
% Authors : Minchao Wu
% Date : 2018-09-30

% Description: to calculate changes in x y components of two vectors
%
% Input: x component of vector I
%        y component of vector I
%        x component of vector II
%        y component of vector II
%        range of x component
%        range of y component
%
% Output: bin count of the vector 
%         changes of x component in matrix
%         changes of y component in matrix
%
% Output format : bin count of the vector, changes of x component in matrix, changes of x component in matrix
%

function [ v_bc diffx_mat diffy_mat] = freq_mat_vector( x_v,y_v,x_inv,x_lim,y_inv,y_lim, x2_v, y2_v )

    clearvars diffx_mat diffy_mat freq_mat;

    % counts in each bin, and index of bin for each element
    [bc_x,ind_x]=histc(x_v(:),x_lim(1):x_inv:x_lim(2));
    [bc_y,ind_y]=histc(y_v(:),y_lim(1):y_inv:y_lim(2));

    s_x=(x_lim(2)-x_lim(1))/x_inv;s_y=(y_lim(2)-y_lim(1))/y_inv;
     
    freq_mat=zeros(s_x,s_y);
    diffx_mat=zeros(s_x,s_y);
    diffy_mat=zeros(s_x,s_y);

    x_v_diff = x2_v - x_v;
    y_v_diff = y2_v - y_v;

    for di=1:length(ind_y)

        % find the correspondent bin index for each element
        % when belong to this bin interval, +1

        if ind_x(di) > 0 && ind_y(di) > 0 

            if abs(x_v_diff(di)) > 0 || abs(y_v_diff(di)) > 0

                freq_mat(ind_x(di),ind_y(di))=freq_mat(ind_x(di),ind_y(di))+1;

                % for vector calculation
                diffx_mat(ind_x(di),ind_y(di))=diffx_mat(ind_x(di),ind_y(di))+x_v_diff(di);
                diffy_mat(ind_x(di),ind_y(di))=diffy_mat(ind_x(di),ind_y(di))+y_v_diff(di);

            end
        end
    end
    
    % take the average of each grid, (will be normalized outside this
    % function)
    freq_tmp=freq_mat;
    freq_tmp(freq_tmp<1)=1;
    diffx_mat=diffx_mat./freq_tmp;
    diffy_mat=diffy_mat./freq_tmp;
     
     % to mark each element with bin counts
     v_bc = nan(length(x_v),1);

     for i=1:length(x_v)
         if ind_x(i) > 0 && ind_y(i) > 0

            v_bc(i,1)=freq_mat(ind_x(i),ind_y(i));

         end
     end
     
end

