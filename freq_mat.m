%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: freq_mat
% File: freq_mat.m
%
% Authors : Minchao Wu
% Date : 2018-09-30

% Description: to calculate frequency for bins in two dimensions
%
% Input: x vector
%        y vector
%        x bin interval
%        y bin interval
%        range of x component
%        range of y component
%
% Output: 2-D matrix for bin frequency
%         1-D bin counts
%
% Output format : 2-D matrix, vector
%

function [ freq_mat v_bc] = freq_mat( x_v,y_v,x_inv,x_lim,y_inv,y_lim )

     % counts in each bin, and index of bin for each element
     [bc_x,ind_x]=histc(x_v,0:x_inv:x_lim);
     [bc_y,ind_y]=histc(y_v,0:y_inv:y_lim);
     
     s_x=x_lim/x_inv;s_y=y_lim/y_inv;
     freq_mat=zeros(s_x,s_y);

    for di=1:length(ind_y);
        
        % find the correspondent bin index for each element
        % when belong to this bin interval, +1

        if ind_x(di) > 0 && ind_y(di) > 0 
            freq_mat(ind_x(di),ind_y(di))=freq_mat(ind_x(di),ind_y(di))+1;
        end
    end
     
     % to mark each element with bin counts
     v_bc = nan(length(x_v),1);
     for i=1:length(x_v)
         if ind_x(i) > 0 && ind_y(i) > 0
             
            v_bc(i,1)=freq_mat(ind_x(i),ind_y(i));
            
         end
     end
end

