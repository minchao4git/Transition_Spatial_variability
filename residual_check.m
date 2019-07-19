%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: residual_check
% File: residual_check.m
%
% Authors : Minchao Wu
% Date : 2018-12-20

% Description: to derive residual of dependent variables after two levels of regression
%              for each defined bin by considering interaction of predictors
% Input: one depedent variable array , one array for first level predictor, one predictor matrix
% Output: Residuals of dependent variable and its R-Squared
% Output format : residual,R2
%

function [ res_std, r2_mod ] = residual_check(x_v,y_v,x_inv,x_lim,y_inv,y_lim, z_mat)

    % multiple z variables are supported
    nz = size(z_mat,2);
    tmp_id = ones(size(x_v,1),1);

    for n=1:nz
        tmp_id = tmp_id & cleanidx(z_mat(:,n));
    end

    cidx=find(cleanidx(y_v) & cleanidx(x_v) & tmp_id);
    
    x_vn = x_v(cidx);
    y_vn = y_v(cidx);
    z_matn = z_mat(cidx,:);
    
    % counts in each bin, and index of bin for each element
    [bc_x,ind_x]=histc(x_vn,x_lim(1):x_inv:x_lim(2));
    [bc_y,ind_y]=histc(y_vn,y_lim(1):y_inv:y_lim(2));

    s_x=(x_lim(2)-x_lim(1))/x_inv;
    res_std=nan(s_x,nz+1);
    r2_mod=nan(s_x,nz+1);

    for bi = 1:s_x

        clearvars mdl1;

	% Calculate regression for bin with reasonal number of data points
        if sum(ind_x==bi) > 10
            disp(sprintf(' === Processing bin %i ...',bi));
            y_s = y_vn(ind_x==bi);
            x_s = x_vn(ind_x==bi);
            z_s = z_matn(ind_x==bi,:);
            
            disp(sprintf(' >> MOD %i ...',1));

	    % 1. Linear regression model using stepwise approach
	    % 2. Calculate linear term for each predictor as well as their all possible 
            %    products of pairs
            mdl1=stepwiselm([x_s],y_s,'interactions');

            % Remove outliers
            tmp = mdl1.Residuals.Raw; res_std(bi,1) = std(tmp(tmp > prctile(tmp,2) & tmp<prctile(tmp,98)));
            r2_mod(bi, 1) = mdl1.Rsquared.Adjusted;
            
	    % Continuously add predictors for multiple regression
            for n=1:nz
                disp(sprintf(' >> MOD %i ...',n+1));

                mdln=stepwiselm([x_s z_s(:,1:n)],y_s,'interactions');
                
                tmp = mdln.Residuals.Raw; 
                res_std(bi,n+1) = std(tmp(tmp > prctile(tmp,2) & tmp<prctile(tmp,98)));
                r2_mod(bi, n+1) = mdln.Rsquared.Adjusted;
            end

        end
    end
    
end
