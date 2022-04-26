names = fields';
values = num2cell(1:47);
args=[names;x];
structure = struct(args{:});


 structure = cell2struct(x,names,1);

 filedir = 'D:\Jasmine\EEG\IST\Electrode_regression\Fixed\';
filename = '_trialmatrix_EEG_regression_weighted_STV.mat';
part = 2;

%preallocate
load fieldnames.mat
x = cell(47,683);
x = cell(length(names,participants(part_i).trialmatrix_length));
trialmatrix_clean = cell2struct(x,names,1);