function Offspring = OversamplingGuidedSearch(Problem, Population, L, delta, k)
% Oversampling-guided search

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Norihiro Kimoto

    % Oversamoling for rare solutions
    PopSrt     = NDCDSort(Population);
    Artificial = Oversampling(PopSrt, L, k, 1);

    % Solution generation based on artificial solutions
    Parent1   = Population(1 : floor(end / 2));
    Parent2   = Population(floor(end / 2) + 1 : floor(end / 2) * 2);
    Replace   = rand(1, length(Parent2)) < delta;
    Parent2(Replace) = Artificial(randi(L, nnz(Replace), 1));
    Parent    = [Parent1, Parent2];
    Offspring = OperatorGA(Problem, Parent);
end
