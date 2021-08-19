%{
Eduardo Conde-Sousa
econdesousa@gmail.com

if you use this code please cite:
https://doi.org/10.1016/j.fsigss.2019.10.091



To run all the code to generate tables and figs in proceeding:

clear all,close all,clc
init
nTbl_init=nTbl
h = plotGraph(data, species_ind,bin_ind,extra_info_ind);
data(contains(data(:,extra_info_ind),'D'),:)=[];
data(contains(data(:,species_ind),'Canis lupus')&contains(data(:,bin_ind),'AAC5017'),:)=[];
data(:,end)=[];
reuse=true;
init
data(:,end)=[];
init
h1 = plotGraph(data, species_ind,bin_ind,extra_info_ind,1,7);
nTbl

%}



if ~exist('reuse','var')
   reuse=false;
end
if ~reuse
    [data,header] = loadData('Canidae_BIN.tsv');
end
%% main code

%% initialize vars
species_ind=find(cellfun(@(x) strcmp(x,'species_name'),header));
bin_ind=find(cellfun(@(x) strcmp(x,'bin_uri'),header));
institution_ind=find(cellfun(@(x) strcmp(x,'institution_storing'),header));
extra_info_ind=size(data,2)+1;%find(cellfun(@(x) strcmp(x,'extrainfo'),header));
data(:,end+1)=repmat({''},size(data,1),1);

data=data(~cellfun(@(x) strcmp(x,'NAN'),data(:,species_ind)),:);

species_names=unique(data(:,species_ind));
bin_names=unique(data(:,bin_ind));
out=cell(size(species_names,1),3);
out(:,1)=species_names;
clear species_names
out=out(randperm(size(out,1)),:);


for ii=1:size(out,1)
    out = enoughData(out,data,species_ind,bin_ind,ii);
    grade_D_species=out(cellfun(@(x) strcmp(x,'D'),out(:,2)),1);
	for iter=1:numel(grade_D_species)
		ind=find(cellfun(@(x) strcmp(x,grade_D_species{iter}),data(:,species_ind)));
		data(ind,extra_info_ind)={'D'};
	end
end


for ii=1:size(out,1)
    if ~strcmp(out{ii,2},'D')
		[out{ii,2}, tmp]=allSeqs1BIN(data,species_ind,out(:,1),bin_ind,ii);
		out{ii,3}=strjoin(tmp);
		clear tmp
	end

	
	if isnumeric(out{ii,2})
		if out{ii,2}==1 %if all specimens of species X correspond to 1 BIN
			if numel(regexp(out{ii,3},'\s'))>0 %just checkking
				error('more than one bin')
			end
			% BINSpeciesConcordance = true if BIN correspond to one species
            % BINSpeciesConcordance = false if BIN correspond to more than one species
            BINSpeciesConcordance = speciesPerBIN(data,out{ii,3},species_ind,bin_ind);
            
			if BINSpeciesConcordance % specimens of grade A or B
				ind=find(cellfun(@(x) strcmp(x,out{ii,1}),data(:,species_ind)));
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				% Will require revising these lines here to consider cases with
				% missing data regarding institution and/or authors
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				data=speciesCongruence(data,ind,institution_ind,extra_info_ind);
			else
				%Assign grade E to species
				ind=find(cellfun(@(x) strcmp(x,out{ii,1}),data(:,species_ind)));
				data(ind,extra_info_ind)={'E1'};
			end
		else
			allBINsOfThisSpecies=split(out{ii,3});
			[grade ,~] = BINnearestNeighb(allBINsOfThisSpecies,data,bin_ind, species_ind);
            ind=find(cellfun(@(x) strcmp(x,out{ii,1}),data(:,species_ind)));
			data(ind,extra_info_ind)={grade};
		end
    end
end


[~,ind]=sort(data(:,extra_info_ind));
tbl=tabulate(data(ind,extra_info_ind));
tbl=cell2table(tbl,'VariableNames',{'Grade' 'Count' 'Percent'});
tbl.Grade=categorical(tbl.Grade);
nTbl=tblMainGrades(tbl);
%{
G=graph(data(:,[species_ind])',data(:,[bin_ind])');
figure('Name',[num2str(round(tbl{end-1,3}+tbl{end,3},1)) '%' ])
plot(G)
box off
axis off
tightfig;
%}