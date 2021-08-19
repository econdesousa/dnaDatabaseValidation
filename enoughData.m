%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

%% step1 enough data?
function out = enoughData(out,data,species_ind,bin_ind,ii)
	data4species=data(strcmp(data(:,species_ind),out{ii,1}),[bin_ind species_ind]);
	%fprintf('%s\t%g\n',out{ii,1},size(data4species,1))
    if size(data4species,1)<=3
		out{ii,2}='D';
	end
end
