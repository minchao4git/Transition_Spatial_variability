%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: Variance_on_DSL
% File: Variance_on_DSL.m
%
% Authors : Minchao Wu
% Date : 2019-02-01

% Description: to derive spatial variability of each spatial point 
%              by year based on the calculated functional relationship
%
% Input: DSL
% Output: Spatial variability of AGB
% Output format : Spatial variability of AGB, year
%

% polyfit for each year
clearvars pf_esm_p_mty pv_esm_p_mty pf_esm_f_mty pv_esm_f_mty;
x_ninv=25;
x=1:25;
n=5;
for s=esm_chosen
    for yr=1:nyr_sim
        for n=1:5
            % Present-date
            tmp = res_std_lu_esm_p(1:x_ninv,2,yr,n,s);
	    % This determine the variance map!
            pf_esm_p_mty(:,yr,s)=polyfit(x(~isnan(tmp)),tmp(~isnan(tmp))',5); 
            pv_esm_p_mty(:,yr,s)=polyval(pf_esm_p_mty(:,yr,s),x);

            % Future
            tmp = res_std_lu_esm_f(1:x_ninv,2,yr,n,s);
	    % This determine the variance map!
            pf_esm_f_mty(:,yr,s)=polyfit(x(~isnan(tmp)),tmp(~isnan(tmp))',5);
            pv_esm_f_mty(:,yr,s)=polyval(pf_esm_f_mty(:,yr,s),x);
        end
    end
end

% Plot figures by model
figure('Position',[296   161   968   486]);
for s=esm_chosen
     for yr=1:1
         subplot(3,3,s);
         for i=5:5
             hold on;
             plot(1:26,squeeze(nanmean(res_std_lu_esm_p(1:26,2,yr,i,s),3)),'Color','b','LineWidth',2);
             plot(x,pv_esm_p_mty(:,yr,s),'color','b','LineWidth',2,'LineStyle','--');
             plot(1:26,squeeze(nanmean(res_std_lu_esm_f(1:26,2,yr,i,s),3)),'Color','r','LineWidth',2);
             plot(x,pv_esm_f_mty(:,yr,s),'color','r','LineWidth',2,'LineStyle','--');
             xlim([0 26]);
             ylim([0 5.5]);
         end
     end
end


%%
% polyfit for the average of the whole period
clearvars pf_esm_p pv_esm_p pf_esm_f pv_esm_f;
x_ninv=25;
x=1:25;
n=5;
for s=esm_chosen
    for n=1:5

        % Present-date
        tmp = nanmean(res_std_lu_esm_p(1:x_ninv,2,:,n,s),3);
	% This determine the variance map!
        pf_esm_p(:,s)=polyfit(x(~isnan(tmp)),tmp(~isnan(tmp))',5); 
        pv_esm_p(:,s)=polyval(pf_esm_p(:,s),x);

        % Future
        tmp = nanmean(res_std_lu_esm_f(1:x_ninv,2,:,n,s),3);
	% This determine the variance map!
        pf_esm_f(:,s)=polyfit(x(~isnan(tmp)),tmp(~isnan(tmp))',5); 
        pv_esm_f(:,s)=polyval(pf_esm_f(:,s),x);

    end
end

% Plot variability~DSL relationship by model
figure('Position',[296   161   968   486]);
for s=esm_chosen
    subplot(3,3,s);
    for i=5:5
        hold on;
        plot(1:26,squeeze(nanmean(res_std_lu_esm_p(1:26,2,:,i,s),3)),'Color','b','LineWidth',2);
        plot(x,pv_esm_p(:,s),'color','b','LineWidth',2,'LineStyle','--');
        plot(1:26,squeeze(nanmean(res_std_lu_esm_f(1:26,2,:,i,s),3)),'Color','r','LineWidth',2);
        plot(x,pv_esm_f(:,s),'color','r','LineWidth',2,'LineStyle','--');
        xlim([0 26]);
        ylim([0 5.5]);
    end
end

%% variability of each year
dsl_tmp=squeeze(y_c_esm_p);
for s=esm_chosen
    for yr=1:nyr_sim
        for i=1:size(dsl_tmp,1)

	    % Convert real DSL value to bin index
            var_arr_esm_p_mty(i,yr,s) = polyval(pf_esm_p_mty(:,yr,s),floor(dsl_tmp(i,yr,s,5)/0.5)+1);

        end
    end
end

dsl_tmp=squeeze((y_c_esm_f));
for s=esm_chosen
	for yr=1:nyr_sim
        for i=1:size(dsl_tmp,1)

	    % Convert real DSL value to bin index
            var_arr_esm_f_mty(i,yr,s) = polyval(pf_esm_f_mty(:,yr,s),floor(dsl_tmp(i,yr,s,5)/0.5)+1);

        end
    end
end

lw=1.5;
nbins=12;
x2=[2 2 5 2 1.5 3 3 2 2];
figure;
for s=esm_chosen
    subplot(3,3,s)
    
    a=nanmean(var_arr_esm_p_mty(:,:,s),2);
    b=nanmean(var_arr_esm_f_mty(:,:,s),2);

    hold on;
    histogram(a, nbins, 'EdgeColor','b','FaceAlpha', 0.2, 'DisplayStyle','stairs', 'Normalization','probability', 'LineWidth', lw);
    histogram(b, nbins, 'EdgeColor','r','FaceAlpha', 0.2, 'DisplayStyle','stairs', 'Normalization','probability', 'LineWidth', lw);
    xlim([0 x2(s)]);
end


