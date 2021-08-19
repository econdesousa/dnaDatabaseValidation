%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

%% Grade A or B?
function data=speciesCongruence(data,ind,institution_ind,extra_info_ind)
	%external congruence: grade A
	%internal congruence: grade B
	nInd=find(cellfun(@(x) strcmp(x,'NAN'),data(ind,institution_ind)));
	%data(ind(nInd),extra_info_ind)={'B'};
	ind1=setdiff(ind,ind(nInd)); %#ok<FNDSB>
	if length(unique(data(ind,institution_ind)))==1
		data(ind,extra_info_ind)={'B'};
    elseif numel(ind1)==1
        data(ind,extra_info_ind)={'B'};
    else
		data(ind,extra_info_ind)={'A'};
	end
end

