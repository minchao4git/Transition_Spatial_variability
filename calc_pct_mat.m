%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: calc_pct_mat
% File: calc_pct_mat.m
%
% Authors : Minchao Wu
% Date : 2018-10-01

% Description: to calculate percentile of y for each x bin
% Input: x
% Output: percentile of y (7 levels) for the defined number of bin of x
% Output format : pct, level

function [ pcts ] = calc_pct_mat( x_v,y_v,x_inv,x_lim,y_inv,y_lim, filter_thr)

    % counts in each bin, and index of bin for each element
    
    [bc_x,ind_x]=histc(x_v,x_lim(1):x_inv:x_lim(2));
    [bc_y,ind_y]=histc(y_v,y_lim(1):y_inv:y_lim(2));
    
    s_x=(x_lim(2)-x_lim(1))/x_inv;s_y=(y_lim(2)-y_lim(1))/y_inv;
    freq_mat=zeros(s_x,s_y);
    
    freq_mat_sum=zeros(s_x);
    
    pcts=nan(s_x, 7); % 7 pct class

    for di=1:length(ind_y)
        % find the correspondent bin index for each element
        % when belong to this bin interval, +1

        if ind_x(di) > 0 && ind_y(di) > 0 
            freq_mat(ind_x(di),ind_y(di))=freq_mat(ind_x(di),ind_y(di))+1;
            freq_mat_sum(ind_x(di)) = freq_mat_sum(ind_x(di)) + 1;
        end
    end
    
    for bi = 1:s_x

        if nansum(freq_mat(bi,:)) > filter_thr %(filter_thr set to 1 by default)
            
            tmp = y_v(ind_x==bi);

            new_sample = tmp;
            
            pcts(bi,1) = (nanmax(new_sample));
            pcts(bi,2) = (prctile(new_sample,90));
            pcts(bi,3) = (prctile(new_sample,70));
            pcts(bi,4) = (prctile(new_sample,50));
            pcts(bi,5) = (prctile(new_sample,30));
            pcts(bi,6) = (prctile(new_sample,10));
            pcts(bi,7) = (nanmin(new_sample));

        end
    end
end

