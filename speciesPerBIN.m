%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

%% All specimens of BIN cluster are labeled as a single species?
function output = speciesPerBIN(data,BINname,species_ind,bin_ind)
	count = numel(unique(data(cellfun(@(x) strcmp(x,BINname),data(:,bin_ind)),species_ind)));
	output = count==1;
end
