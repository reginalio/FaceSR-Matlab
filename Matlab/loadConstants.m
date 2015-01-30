%CONSTANTS
PATCH_RATIO = 5; 
HRLR_RATIO = 4;

LR_SIZE = [15 15];
LR_PATCH_SIZE = LR_SIZE(1)/PATCH_RATIO;
LR_OVERLAP = 1;

HR_SIZE = LR_SIZE*HRLR_RATIO;
HR_PATCH_SIZE = HR_SIZE(1)/PATCH_RATIO;
HR_OVERLAP = LR_OVERLAP*HRLR_RATIO;

TAU = 0.04; % regularization parameter

save('constants.mat');


parameters.ratio = 4;
parameters.LRSize = [15, 15];
parameters.LRPatch = parameters.LRSize(1)/5;
parameters.LROverlap = 1;

parameters.HRSize = parameters.LRSize*parameters.ratio;
parameters.HRPatch = parameters.LRPatch*parameters.ratio;
parameters.HROverlap = parameters.LROverlap*parameters.ratio;
parameters.tau = 0.04; % regularization parameter

save('parameters.mat', 'parameters');
