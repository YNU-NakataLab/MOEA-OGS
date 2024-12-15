classdef IBEAOGS < ALGORITHM
% <2024> <multi/many> <real/integer/label/binary/permutation>
% Indicator-based evolutionary algorithm
% kappa --- 0.05 --- Fitness scaling factor
% delta ---  0.2 --- Selection probability of artificial parent solutions 
% L     ---   30 --- Number of rare solutions 
% k     ---    3 --- The neighbor size of kNN

%------------------------------- Reference --------------------------------
% N. Kimoto, Y. Horaguchi, and M. Nakata, Oversampling-Guided Search for 
% Evolutionary Multiobjective Optimization, Proceedings of the IEEE 
% Congress on Evolutionary Computation, 2024.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Norihiro Kimoto

    methods
        function main(Algorithm,Problem)
            %% Parameter setting
            [kappa, delta, L, k] = Algorithm.ParameterSet(0.05, 0.2, 30, 3);

            %% Generate random population
            PopDec         = UniformPoint(Problem.N, Problem.D, 'Latin');
            Population     = Problem.Evaluation(repmat(Problem.upper - Problem.lower, Problem.N, 1) .* PopDec + repmat(Problem.lower, Problem.N, 1));
            Arc            = Population;

            %% Optimization
            while Algorithm.NotTerminated(Arc)
                MatingPool = TournamentSelection(2, Problem.N, -CalFitness(Population.objs, kappa));
                Offspring  = OversamplingGuidedSearch(Problem, Population(MatingPool), L, delta, k);
                Arc        = [Arc, Offspring];
                Population = EnvironmentalSelection([Population, Offspring], Problem.N, kappa);
            end
        end
    end
end