function S = Oversampling(ArcSrt, L, k, o)
% Synthetic minority oversampling technique for regression (SMOTER)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Norihiro Kimoto

    % Initialize an artificial solution set S as an empty set
    S = [];
    
    for i = 1 : min(size(ArcSrt, 2), L)
        % Apply k-nearest neighbor
        RemArc    = ArcSrt;
        RemArc(i) = [];
        B         = knnsearch(RemArc.decs, ArcSrt(i).dec, 'K', k);
        
        for j = 1 : o
            % Select a base neighbor sample randomly
            BaseSamp = RemArc(B(randi(k)));

            % Generate a new sample
            NewDec   = ArcSrt(i).dec + rand() * (BaseSamp.dec - ArcSrt(i).dec);
            dis1     = pdist2(NewDec, ArcSrt(i).dec);
            dis2     = pdist2(NewDec, BaseSamp.dec);
            NewObj   = (dis2 * ArcSrt(i).obj + dis1 * BaseSamp.obj) / (dis1 + dis2);

            % Add a new sample to Snew
            S     = [S, SOLUTION(NewDec, NewObj, 0)];
        end
    end
end
