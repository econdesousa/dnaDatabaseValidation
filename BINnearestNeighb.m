%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

%% All BINs of species X include only X and are nearest neighboors?
function [grade , ind_exp] = BINnearestNeighb(allBINsOfThisSpecies,data,bin_ind,species_ind)
	% All BINs of species X include only X 
	ind_exp=cellfun(@(x) strcmp(x,allBINsOfThisSpecies{1}),data(:,bin_ind));
	for ii=2:numel(allBINsOfThisSpecies)
		ind_exp= ind_exp | cellfun(@(x) strcmp(x,allBINsOfThisSpecies{ii}),data(:,bin_ind));
	end
	if numel(unique(data(ind_exp,species_ind)))==1 %YES - All BINs of species X include only X 

		outMatrix=zeros(numel(allBINsOfThisSpecies),numel(allBINsOfThisSpecies));
		for ii=1:numel(allBINsOfThisSpecies)
			BINdata=parseBoldBINdata(allBINsOfThisSpecies{ii},0);
			ind=find(~cellfun(@isempty , strfind(allBINsOfThisSpecies,BINdata.nearestNeig)));
			if ~isempty(ind)
				outMatrix(ii,ind)=BINdata.dist;
				outMatrix(ind,ii)=BINdata.dist;
			end
			outMatrix(outMatrix>2)=0; % if BIN dist > 2 they are not considered here as nearest neighbors
		end
		if all(conncomp(graph(outMatrix))==1) %BINs are nearest neighboors
			grade='C';
		else %BINs aren't nearest neighboors
			grade='E2';
		end
	else %NO - All BINs of species X include other species than X
		grade='E2';
	end
end