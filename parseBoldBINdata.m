%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

function [out, webPage ] = parseBoldBINdata(BIN,openWeb)
	
	tmpout=cell(2,1);
	webPage = ['http://v4.boldsystems.org/index.php/Public_BarcodeCluster?clusteruri=' BIN];
	if nargin ==2
		if openWeb
			web(webPage);
		end
	end
	flag =1;
	count=0;
	while flag
		try
			data=webread(webPage);
			flag=0;
			lf=sprintf('\n');	%#ok<SPRINTFN> % 010 =  LF: line feed
			cr=sprintf('\r');	% 013 =  CR: carriage return
			data=strrep(data,[cr,lf],lf);
			
			
			dist2nearestNeig=strfind(data,'Distance to Nearest Neighbor');
			nearestNeig=strfind(data,'Nearest BIN URI:');
			
			td=strfind(data,'<td>');td_end=strfind(data,'</td>');
			
			ind=sort([td(find(td>nearestNeig-5,2)),...
				td_end(find(td_end>nearestNeig,2))]);
			tmpout{1}=data(ind(1)+4:ind(2)-1);
			
			ind=sort([td(find(td>dist2nearestNeig,1)),...
				td_end(find(td_end>dist2nearestNeig,1))]);
			data_small=data(ind(1)+4:ind(2)-1);
			tmpout{2}=str2double(data_small(1:strfind(data_small,'%')-1));
			
		catch
			count=count+1;
			fprintf('couldn''t open %s\n\ttrying again\n',webPage)
			if count>10
				fprintf('couldn''t open %s\n\tquitting\n',webPage)
				tmpout{1}='';
				tmpout{2}=inf;
				flag=0;
			end
		end
	end

	out=cell2struct(tmpout,{'nearestNeig','dist'});
end
