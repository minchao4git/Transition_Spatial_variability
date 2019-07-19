%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine name: dry_and_wet_ssn
% File: dry_and_wet_ssn.m
%
% Authors : Minchao Wu
% Date : 2018-10-01

% Description: to calculate dry season length
% Input: monthly precipitation for multiple years
% Output: dry season length for each year
% Output format : DSL, year

nyr_obs = prd_obs(2)-prd_obs(1)+1;
nyr_sim = prd_sim_p(2)-prd_sim_p(1)+1;
dssn_length_obs=nan(size(DATA_mm_guess,1), size(DATA_mm_guess,2),nyr_obs);
dssn_length_sim=nan(size(DATA_mm_guess,1), size(DATA_mm_guess,2),nyr_sim, 5); % 5, number of run

% precip. threshhold to define dry season
% According to Levine et al., 2015, 100 threshold is used.
dsl_th=[100 70 80 90 100 110 170];

d=1
% Obs.
dsl_tmp=nan(size(DATA_mm_guess,1), size(DATA_mm_guess,2),nyr_obs+yr_shift);

for y = 1:nyr_obs+yr_shift
    for i=1:size(DATA_mm_guess,1)
        for j=1:size(DATA_mm_guess,2)

            tmp = pr_cru_sa_am(i,j,:,y);

            if ~isnan(tmp)
                dsl_tmp(i,j,y) = 12-sum(tmp<dsl_th(d));
            end
        end
    end
end

for y = 1:nyr_obs
    dssn_length_obs(:,:,y) = nanmean(dsl_tmp(:,:,y:(y+yr_shift-1)),3);
end

% Sim.
for r=1:5
    for y=1:nyr_sim+yr_shift
        for m=1:12

            map_tmp = DATA_mm_guess(:,:,y, m,r,get_idx_guess(var_guess_mm,'prec1'));
            sim_prec(:,:,y,m,r) = map_tmp;

        end
    end
end

dsl_tmp=nan(size(DATA_mm_guess,1), size(DATA_mm_guess,2),nyr_obs+yr_shift);
for r=1:5
    for y=1:nyr_sim+yr_shift
        for i=1:size(DATA_mm_guess,1)
            for j=1:size(DATA_mm_guess,2)

                tmp=sim_prec(i,j,y, :,r);

                if ~isnan(tmp)
                    dsl_tmp(i,j, y, r) = 12-sum(tmp<dsl_th(d));
                end
            end
        end
    end
end

for r=1:5
    for y = 1:nyr_sim

        dssn_length_sim(:,:,y,r) = nanmean(dsl_tmp(:,:,y:(y+yr_shift-1),r),3);

    end
end

% ESMs
% Present-date
dssn_length_esm_p=nan(size(prec_esm_p,1), size(prec_esm_p,2), nyr_obs);
dssn_length_esm_f=nan(size(prec_esm_p,1), size(prec_esm_p,2), nyr_obs);
dsl_tmp=nan(size(prec_esm_p,1), size(prec_esm_p,2), nyr_obs+yr_shift, 9);

for r=esm_chosen
    for y=1:nyr_sim+yr_shift
        for i=1:size(prec_esm_p,1)
            for j=1:size(prec_esm_p,2)
                  tmp=prec_esm_p(i,j,:,y,r);

                if ~isnan(tmp)
                    dsl_tmp(i,j, y, r) = 12-sum(tmp<dsl_th(d));
                end
            end
        end
    end
end
for r=esm_chosen
    for y = 1:nyr_sim
        dssn_length_esm_p(:,:,y,r) = nanmean(dsl_tmp(:,:,y:(y+yr_shift-1),r),3);
    end
end

% Future
dsl_tmp=nan(size(prec_esm_p,1), size(prec_esm_p,2), nyr_obs+yr_shift, 9);

for r=esm_chosen
    for y=1:nyr_sim+yr_shift
        for i=1:size(prec_esm_f,1)
            for j=1:size(prec_esm_f,2)
                  tmp=prec_esm_f(i,j,:,y,r);

                if ~isnan(tmp)
                    dsl_tmp(i,j, y, r) = 12-sum(tmp<dsl_th(d));
                end
            end
        end
    end
end

for r=esm_chosen
    for y = 1:nyr_sim
        dssn_length_esm_f(:,:,y,r) = nanmean(dsl_tmp(:,:,y:(y+yr_shift-1),r),3);
    end
end
clearvars dsl_tmp;

% Calculate agreement among ESMs
esmm=squeeze(nanmean(nanmean(dssn_length_esm_f(:,:,:,esm_chosen),3),4)-nanmean(nanmean(dssn_length_esm_p(:,:,:,esm_chosen),3),4));
[s1 s2]=size(esmm);
cnt_esm=zeros(s1,s2);

figure;
for i=esm_chosen
    subplot(3,3,i);
    a=nanmean(dssn_length_esm_f(:,:,:,i),3)-nanmean(dssn_length_esm_p(:,:,:,i),3);
    imagesc(rot90(a));
    caxis([-2 2]);
    
    for m=1:s1
        for n=1:s2
            if (a(m,n) > 0 && esmm(m,n) > 0) || (a(m,n) < 0 && esmm(m,n) < 0)
                cnt_esm(m,n)=cnt_esm(m,n)+1;
            end
        end
    end
end

figure;imagesc(rot90(cnt_esm));

