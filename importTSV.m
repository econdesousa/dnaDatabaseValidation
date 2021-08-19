%{
Eduardo Conde-Sousa
econdesousa@gmail.com

https://doi.org/10.1016/j.fsigss.2019.10.091
%}

function data = importTSV(filename, startRow, endRow)
	%importTSV Import numeric data from a text file as a matrix.
	%   DATA = importTSV(FILENAME) Reads data from text file FILENAME for the
	%   default selection.
	%
	%   DATA = importTSV(FILENAME, STARTROW, ENDROW) Reads data from rows
	%   STARTROW through ENDROW of text file FILENAME.
	%
	% Example:
	%   data = importTSV('data.tsv', 2, 10);
	%
	%    See also TEXTSCAN.
	
	% Auto-generated by MATLAB on 2019/03/20 14:29:04
	
	%% Initialize variables.
	delimiter = '\t';
	if nargin<=2
		startRow = 2;
		endRow = inf;
	end
	
	%% Read columns of data as text:
	% For more information, see the TEXTSCAN documentation.
	formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
	
	%% Open the text file.
	fileID = fopen(filename,'r');
	
	%% Read columns of data according to the format.
	% This call is based on the structure of the file used to generate this
	% code. If an error occurs for a different file, try regenerating the code
	% from the Import Tool.
	dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
	for block=2:length(startRow)
		frewind(fileID);
		dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
		for col=1:length(dataArray)
			dataArray{col} = [dataArray{col};dataArrayBlock{col}];
		end
	end
	
	%% Close the text file.
	fclose(fileID);
	
	%% Convert the contents of columns containing numeric text to numbers.
	% Replace non-numeric text with NaN.
	raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
	for col=1:length(dataArray)-1
		raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
	end
	numericData = NaN(size(dataArray{1},1),size(dataArray,2));
	
	for col=[3,9,11,13,15,19,21,23,60,65,69]
		% Converts text in the input cell array to numbers. Replaced non-numeric
		% text with NaN.
		rawData = dataArray{col};
		for row=1:size(rawData, 1)
			% Create a regular expression to detect and remove non-numeric prefixes and
			% suffixes.
			regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
			try
				result = regexp(rawData(row), regexstr, 'names');
				numbers = result.numbers;
				
				% Detected commas in non-thousand locations.
				invalidThousandsSeparator = false;
				if numbers.contains(',')
					thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
					if isempty(regexp(numbers, thousandsRegExp, 'once'))
						numbers = NaN;
						invalidThousandsSeparator = true;
					end
				end
				% Convert numeric text to numbers.
				if ~invalidThousandsSeparator
					numbers = textscan(char(strrep(numbers, ',', '')), '%f');
					numericData(row, col) = numbers{1};
					raw{row, col} = numbers{1};
				end
			catch
				raw{row, col} = rawData{row};
			end
		end
	end
	
	
	%% Split data into numeric and string columns.
	rawNumericColumns = raw(:, [3,9,11,13,15,19,21,23,60,65,69]);
	rawStringColumns = string(raw(:, [1,2,4,5,6,7,8,10,12,14,16,17,18,20,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,61,62,63,64,66,67,68,70,71,72,73,74,75,76,77,78,79,80]));
	
	
	%% Replace non-numeric cells with NaN
	R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
	rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
	
	%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
	for catIdx = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,53,54,55,56,57,58,59,60,62,63,64,65,66,67,68,69]
		idx = (rawStringColumns(:, catIdx) == "<undefined>");
		rawStringColumns(idx, catIdx) = "";
	end
	
	%% Create output variable
	data = table;
	data.processid = categorical(rawStringColumns(:, 1));
	data.sampleid = categorical(rawStringColumns(:, 2));
	data.recordID = cell2mat(rawNumericColumns(:, 1));
	data.catalognum = categorical(rawStringColumns(:, 3));
	data.fieldnum = categorical(rawStringColumns(:, 4));
	data.institution_storing = categorical(rawStringColumns(:, 5));
	data.collection_code = categorical(rawStringColumns(:, 6));
	data.bin_uri = categorical(rawStringColumns(:, 7));
	data.phylum_taxID = cell2mat(rawNumericColumns(:, 2));
	data.phylum_name = categorical(rawStringColumns(:, 8));
	data.class_taxID = cell2mat(rawNumericColumns(:, 3));
	data.class_name = categorical(rawStringColumns(:, 9));
	data.order_taxID = cell2mat(rawNumericColumns(:, 4));
	data.order_name = categorical(rawStringColumns(:, 10));
	data.family_taxID = cell2mat(rawNumericColumns(:, 5));
	data.family_name = categorical(rawStringColumns(:, 11));
	data.subfamily_taxID = categorical(rawStringColumns(:, 12));
	data.subfamily_name = categorical(rawStringColumns(:, 13));
	data.genus_taxID = cell2mat(rawNumericColumns(:, 6));
	data.genus_name = categorical(rawStringColumns(:, 14));
	data.species_taxID = cell2mat(rawNumericColumns(:, 7));
	data.species_name = categorical(rawStringColumns(:, 15));
	data.subspecies_taxID = cell2mat(rawNumericColumns(:, 8));
	data.subspecies_name = categorical(rawStringColumns(:, 16));
	data.identification_provided_by = categorical(rawStringColumns(:, 17));
	data.identification_method = categorical(rawStringColumns(:, 18));
	data.identification_reference = categorical(rawStringColumns(:, 19));
	data.tax_note = categorical(rawStringColumns(:, 20));
	data.voucher_status = categorical(rawStringColumns(:, 21));
	data.tissue_type = categorical(rawStringColumns(:, 22));
	data.collection_event_id = categorical(rawStringColumns(:, 23));
	data.collectors = categorical(rawStringColumns(:, 24));
	data.collectiondate_start = categorical(rawStringColumns(:, 25));
	data.collectiondate_end = categorical(rawStringColumns(:, 26));
	data.collectiontime = categorical(rawStringColumns(:, 27));
	data.collection_note = categorical(rawStringColumns(:, 28));
	data.site_code = categorical(rawStringColumns(:, 29));
	data.sampling_protocol = categorical(rawStringColumns(:, 30));
	data.lifestage = categorical(rawStringColumns(:, 31));
	data.sex = categorical(rawStringColumns(:, 32));
	data.reproduction = categorical(rawStringColumns(:, 33));
	data.habitat = categorical(rawStringColumns(:, 34));
	data.associated_specimens = categorical(rawStringColumns(:, 35));
	data.associated_taxa = categorical(rawStringColumns(:, 36));
	data.extrainfo = categorical(rawStringColumns(:, 37));
	data.notes = categorical(rawStringColumns(:, 38));
	data.lat = categorical(rawStringColumns(:, 39));
	data.lon = categorical(rawStringColumns(:, 40));
	data.coord_source = categorical(rawStringColumns(:, 41));
	data.coord_accuracy = categorical(rawStringColumns(:, 42));
	data.elev = categorical(rawStringColumns(:, 43));
	data.depth = categorical(rawStringColumns(:, 44));
	data.elev_accuracy = categorical(rawStringColumns(:, 45));
	data.depth_accuracy = categorical(rawStringColumns(:, 46));
	data.country = categorical(rawStringColumns(:, 47));
	data.province_state = categorical(rawStringColumns(:, 48));
	data.region = categorical(rawStringColumns(:, 49));
	data.sector = categorical(rawStringColumns(:, 50));
	data.exactsite = categorical(rawStringColumns(:, 51));
	data.image_ids = cell2mat(rawNumericColumns(:, 9));
	data.image_urls = cellstr(rawStringColumns(:, 52));
	data.media_descriptors = categorical(rawStringColumns(:, 53));
	data.captions = categorical(rawStringColumns(:, 54));
	data.copyright_holders = categorical(rawStringColumns(:, 55));
	data.copyright_years = cell2mat(rawNumericColumns(:, 10));
	data.copyright_licenses = categorical(rawStringColumns(:, 56));
	data.copyright_institutions = categorical(rawStringColumns(:, 57));
	data.photographers = categorical(rawStringColumns(:, 58));
	data.sequenceID = cell2mat(rawNumericColumns(:, 11));
	data.markercode = categorical(rawStringColumns(:, 59));
	data.genbank_accession = categorical(rawStringColumns(:, 60));
	data.nucleotides = cellstr(rawStringColumns(:, 61));
	data.trace_ids = categorical(rawStringColumns(:, 62));
	data.trace_names = categorical(rawStringColumns(:, 63));
	data.trace_links = categorical(rawStringColumns(:, 64));
	data.run_dates = categorical(rawStringColumns(:, 65));
	data.sequencing_centers = categorical(rawStringColumns(:, 66));
	data.directions = categorical(rawStringColumns(:, 67));
	data.seq_primers = categorical(rawStringColumns(:, 68));
	data.marker_codes = categorical(rawStringColumns(:, 69));
	
	for ii=1:size(data,2)
		if iscategorical(data{:,ii}) && any(isundefined(data{:,ii}))
			data{:,ii}=addcats(data{:,ii},'NAN');
			data{:,ii}(isundefined(data{:,ii}))='NAN';
		end
	end
	