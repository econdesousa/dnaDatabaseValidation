%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}


function [data,header] = loadData(filename)

if nargin < 1
    outfolder='../../Data';
    if ~exist('taxa','var')
        taxa='Canidae';%'Felidae';%
    end
    filename=fullfile(outfolder,[taxa '_BIN.tsv']);
end

%% import data
%% needs to be revised later for c++ implementation
data=importTSV(filename);
header=data.Properties.VariableNames;

dataTmp=table2cell(data);
for ii=1:size(data,2)
	if iscategorical(data{:,ii})
		dataTmp(:,ii)=cellstr(data{:,ii});		
	end
end
data=dataTmp;

clear dataTmp ii