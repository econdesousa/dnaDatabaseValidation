%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

function h = plotGraph(data, species_ind,bin_ind,extra_info_ind,subp1,subp2)


    
    data(:,extra_info_ind)=strrep(data(:,extra_info_ind),'E1','E');
    data(:,extra_info_ind)=strrep(data(:,extra_info_ind),'E2','E');
    G=graph(data(:,[species_ind])',data(:,[bin_ind])');
    connectedComponents=conncomp(G);
    h=figure('Units','normalized','OuterPosition',[0 0 1 1]);
    if nargin<5
        subp1=4;
        subp2=4;
    end
    for i=1:(subp1*subp2)
        subplot(subp1,subp2,i)
        G1=G.subgraph(find(connectedComponents==i));
        h1=plot(G1);box off,axis off
        ind=find(~table2array(varfun(@(x) contains(x,'BOLD'),G1.Nodes)));
        highlight(h1,ind,'NodeFontAngle','italic');
        allSpecies=G1.Nodes.Name(~contains(G1.Nodes.Name,'BOLD:'));
        title(sprintf('%s: %s','Grades', strjoin(unique(data(contains(data(:,species_ind),allSpecies),extra_info_ind)),' / ')));
    end
end