function [lb,ub]=bounds_new_A(NS,NT,tSm,add_col)
% no slip larger than 10 m (default)
% tailored constraints for each degree of freedom
%F=2;   % degree of freedom (same as Mode)
%lb(F:NT:length(lb))=-3e2;
%ub(F:NT:length(ub))=3e2;
%F=3;   % degree of freedom (same as Mode)
%lb(F:NT:length(lb))=-1e1;
%ub(F:NT:length(ub))=1e1;

%lb=-1e2*ones(NT*sum(tSm),1);  %lower bound
%ub=1e2*ones(NT*sum(tSm),1);   %upper bound
%Con=[-1 -1 0];  % Calico/Rodman slip 
Con=[-1 0 0];  % Sign constraint; put 1 for positivity, -1 for
%Con=[0 0 -1];  % Sign constraint; put 1 for positivity, -1 for
%Con=[-1 0 -1];  % Sign constraint; put 1 for positivity, -1 for
              % negativity, 0 for no constraint
	      % [Strike Dip Normal]
% nz=find(Mode==1);
%for j=1:NT
% if Con(nz(j)) > 0
%  lb(j:NT:length(lb))=0;
%%  lb(j:NT:(NT*sum(tSm)-NT+j))=0;
% elseif Con(nz(j)) < 0
%  ub(j:NT:length(ub))=0;
% end  
%end  

Npatch = sum(tSm);
lb=-7e2*ones(NT*Npatch,1);  %lower bound in cm
ub= 7e2*ones(NT*Npatch,1);  %upper bound
lb(Npatch+1:2*Npatch) = -7e2;   % dominated by strike slip
ub(Npatch+1:2*Npatch) = 7e2;

% fault_id = slip_model(:,1);
% patch_layer = slip_model(:,3);
% Ny = max(patch_layer);      % the number of bottom layer

% % far field displacement should be zero
% far_fault = [1,5,6,7];  % id of fault segments to be constrained in far field
% for kk = 1:length(far_fault)
%     indx_far_fault = find(fault_id == far_fault(kk));
%     n_layer_this_fault = max(patch_layer(indx_far_fault));
%     patch_layer_fault = patch_layer(indx_far_fault);
%     count = 0;  
%     total_patch = length(find(fault_id < far_fault(kk)));
%     for jj = 1:n_layer_this_fault
%         if kk ~= 1
%             indx_patch_left = count+1;
%             lb(indx_patch_left+total_patch) = 0;         % strike component
%             lb(indx_patch_left+total_patch+Npatch) = 0;  % dip component
%             ub(indx_patch_left+total_patch) = 0;
%             ub(indx_patch_left+total_patch+Npatch) = 0;
%             sum_patch_this_layer = length(find(patch_layer_fault == jj));
%             count = count + sum_patch_this_layer;
%         else
%             sum_patch_this_layer = length(find(patch_layer_fault == jj));
%             count = count + sum_patch_this_layer;
%             indx_patch_right = count;
%             lb(indx_patch_right+total_patch) = 0;
%             lb(indx_patch_right+total_patch+Npatch) = 0;
%             ub(indx_patch_right+total_patch) = 0;
%             ub(indx_patch_right+total_patch+Npatch) = 0;
%         end
%     end
% end

% dip_id = 33;
% total_patch = length(find(fault_id < dip_id));
% lb(total_patch+1:total_patch+4) = 0;
% ub(total_patch+1:total_patch+4) = 0;
% lb(total_patch+1+Npatch:total_patch+4+Npatch) = 0;
% ub(total_patch+1+Npatch:total_patch+4+Npatch) = 0;

% % apply zero-boundary slip at the east branch
% ID = 3;
% patch_total_before = sum(tSm(1:ID));
% [~,nL] = smoo1_each_plane(slip_model);
% patch_this_ID = nL(ID,:)';
% % N_layer = 1;
% % top_patch = [];
% % for jj = 1:N_layer
% %      indx_this_layer = [1:patch_this_ID(jj)] + sum(patch_this_ID(1:jj-1));
% %      top_patch = [top_patch,indx_this_layer];
% % end

% indx_first_layer = 1:patch_this_ID(1);
% lb(patch_total_before+indx_first_layer) = 0;
% ub(patch_total_before+indx_first_layer) = 0;
% lb(patch_total_before+indx_first_layer+Npatch) = 0;
% ub(patch_total_before+indx_first_layer+Npatch) = 0;
% 
% indx_second_layer = sum(patch_this_ID(1:1)) + [1:patch_this_ID(2)];
% lb(patch_total_before+indx_second_layer) = -50;
% ub(patch_total_before+indx_second_layer) = 0;
% lb(patch_total_before+indx_second_layer+Npatch) = 0;
% ub(patch_total_before+indx_second_layer+Npatch) = 0;
% 
% indx_third_layer = sum(patch_this_ID(1:2)) + [1:patch_this_ID(3)];
% lb(patch_total_before+indx_third_layer) = -100;
% ub(patch_total_before+indx_third_layer) = 0;
% lb(patch_total_before+indx_third_layer+Npatch) = 0;
% ub(patch_total_before+indx_third_layer+Npatch) = 0;

% % zero bottom displacement
% indx_bottom = find(patch_layer == Ny);
% lb(indx_bottom) = 0;
% lb(indx_bottom+Npatch) = 0;
% ub(indx_bottom) = 0;
% ub(indx_bottom+Npatch) = 0;

% % redefine the bottom and add zero-slip boundary
% ID = 3;  N_layer = 5;
% [~,nL] = smoo1_each_plane(slip_model);
% patch_before_segments = sum(nL(1:ID-1,:),2);
% patch_before_layer = nL(ID,1:N_layer-1);
% patch_all_before = sum(patch_before_segments) + sum(patch_before_layer);
% indx_bottom_this_ID = patch_all_before+1:patch_all_before+2;
% lb(indx_bottom_this_ID) = 0;
% lb(indx_bottom_this_ID+Npatch) = 0;
% ub(indx_bottom_this_ID) = 0;
% ub(indx_bottom_this_ID+Npatch) = 0;

NS1=6;
% NS1=NS;

% for i=1:2
%  k1=sum(tSm(1:i))+1;
%  k2=sum(tSm(1:i+1));
%  for k=k1:k2
%   for j=1:NT
%    ind=(k-1)*NT+j;
%    if Con(nz(j)) > 0
%     lb(ind)=0;
%    elseif Con(nz(j)) < 0
%     ub(ind)=0;
%    end  
%   end  
%  end  
% end  

%Con=[1 1 0];  % Sign constraint; put 1 for positivity, -1 for
for i=1:NS1
 k1=sum(tSm(1:i))+1;
 k2=sum(tSm(1:i+1));
 for k=k1:k2
     if Con(1) > 0, lb(k) = 0; end
     if Con(2) > 0, lb(k+Npatch) = 0; end
     if Con(1) < 0, ub(k) = 0; end
     if Con(2) < 0, ub(k+Npatch) = 0; end
%   for j=1:NT
%    ind=(k-1)*NT+j;
%    if Con(nz(j)) > 0
%     lb(ind)=0;
%    elseif Con(nz(j)) < 0
%     ub(ind)=0;
%    end  
%   end  
 end  
end  

% lb(Npatch+1:end) = 0;
% ub(Npatch+1:end) = 0;
%return
   
Con=[1 0 0];  % Sign constraint; put 1 for positivity, -1 for
for i=NS1+1:NS1+2
 k1=sum(tSm(1:i))+1;
 k2=sum(tSm(1:i+1));
 for k=k1:k2
     if Con(1) > 0, lb(k) = 0; end
     if Con(2) > 0, lb(k+Npatch) = 0; end
     if Con(1) < 0, ub(k) = 0; end
     if Con(2) < 0, ub(k+Npatch) = 0; end     
%   for j=1:NT
%    ind=(k-1)*NT+j;
%    if Con(nz(j)) > 0
%     lb(ind)=0;
%    elseif Con(nz(j)) < 0
%     ub(ind)=0;
%    end  
%   end  
 end  
end  

Con=[-1 0 0];
for i=NS1+3:NS
 k1=sum(tSm(1:i))+1;
 k2=sum(tSm(1:i+1));
 for k=k1:k2
     if Con(1) > 0, lb(k) = 0; end
     if Con(2) > 0, lb(k+Npatch) = 0; end
     if Con(1) < 0, ub(k) = 0; end
     if Con(2) < 0, ub(k+Npatch) = 0; end
%   for j=1:NT
%    ind=(k-1)*NT+j;
%    if Con(nz(j)) > 0
%     lb(ind)=0;
%    elseif Con(nz(j)) < 0
%     ub(ind)=0;
%    end  
%   end  
 end  
end 

% local subsidence for smoothing patches
% ub(smooth_patch+Npatch) = 0;
% ub(76:77) = -300;
% ub(85:88) = -300;
% ub(399) = -300;
% ub(408) = -300;
% ub(411) = -300;
% ub(429) = -300;
% ub(432) = -300;

% no bounds on ramp coefficients:    
lb((NT*sum(tSm)+1):(NT*sum(tSm)+add_col),1)=-Inf;  
ub((NT*sum(tSm)+1):(NT*sum(tSm)+add_col),1)=Inf;   

end