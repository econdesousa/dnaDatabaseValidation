%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

%% All sequences of species X correspond to one BIN cluster?
function [output_1 ,output_2 ] = allSeqs1BIN(data,species_ind,species_names,bin_ind,ii)
	data4species=data(strcmp(data(:,species_ind),species_names{ii}),[bin_ind species_ind]);
	output_2 = unique(data4species(:,1));
	output_1 = size(unique(data4species(:,1)),1);
end