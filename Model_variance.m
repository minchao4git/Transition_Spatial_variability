%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: Model_variance
% File: Model_variance.m
%
% Authors : Minchao Wu
% Date : 2019-01-01

% Description: to explain spatial variability of each DSL bin
% Input: DSL, LU fraction
% Output: Spatial variability of AGB, level of regression, year and lu fraction class
% Output format : DSL, level, yr, lu
%

% Array definition
res_std_lu=nan(26,2,nyr_obs,5);
r2_mod_lu=nan(26,2,nyr_obs,5);

% y_obs_c contains only the Amazon region points
for yr=1:nyr_obs
    for n=1:5

        y = y_obs_c(:,yr,n);
        x = x_obs_wsl(:,yr,n);
        z1 = reshape(nanmean(lu_in_p_an(:,:,yr),3),[],1);

        z_mat = [z1];

        [res_std_lu(:,:,yr,n), r2_mod_lu(:,:,yr,n) ] = residual_check(x,y,x_inv,x_lim,y_inv,y_lim, z_mat);
    end
end

%% === Sim. ===
% Only explain DSL and LU (Sim.)
% fmt.: DSL, level, yr, lu, run
res_std_lu_sim=nan(26,2,nyr_sim,5,5);
r2_mod_lu_sim=nan(26,2,nyr_sim,5,5);

for r=1:5 % Simulation
    for yr=1:nyr_sim
        for n=1:5

	    y = y_c(:,yr,r,n);
	    y_nat = y_c_nat(:,yr,r,n);
	    x = x_wsl(:,yr,r,n);

	    % Landuse data, aligned with Obs data
            z1=reshape(nanmean(DATA_ma_guess(:,:,yr,1,2),3),[],1);
            z_mat = [z1];

            [res_std_lu_sim(:,:,yr,n,r), r2_mod_lu_sim(:,:,yr,n,r) ] = residual_check(x,y,x_inv,x_lim,y_inv,y_lim, z_mat);
            [res_std_lu_nat(:,:,yr,n,r), r2_mod_lu_nat(:,:,yr,n,r) ] = residual_check(x,y_nat,x_inv,x_lim,y_inv,y_lim, z_mat);
        end
    end
end

%% Only explain DSL and LU (ESMs)
% Present-date
res_std_lu_esm_p=nan(26,2,nyr_sim,5,9);
r2_mod_lu_esm_p=nan(26,2,nyr_sim,5,9);

for s = esm_chosen
    for yr=1:nyr_sim
        for n=1:5

            y = y_c_esm_p(:,yr,s,n);
            x = x_wsl_esm_p(:,yr,s,n);

            z1=reshape(lu_in_p_sim_an(:,:,yr),[],1);
            z_mat = [z1];

            [res_std_lu_esm_p(:,:,yr,n,s), r2_mod_lu_esm_p(:,:,yr,n,s) ] = residual_check1(x,y,x_inv,x_lim,y_inv,y_lim, z_mat);
        end
    end
end

% Future
res_std_lu_esm_f=nan(26,2,nyr_sim,5,9);
r2_mod_lu_esm_f=nan(26,2,nyr_sim,5,9);

for s = esm_chosen
    for yr=1:nyr_sim
        for n=1:5

            y = y_c_esm_f(:,yr,s,n);
            x = x_wsl_esm_f(:,yr,s,n);

            z1=reshape(lu_in_f_sim_an(:,:,yr),[],1);
            z_mat = [z1];

            [res_std_lu_esm_f(:,:,yr,n,s), r2_mod_lu_esm_f(:,:,yr,n,s) ] = residual_check1(x,y,x_inv,x_lim,y_inv,y_lim, z_mat);
        end
    end
end

