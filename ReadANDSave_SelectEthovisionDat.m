function ReadANDSave_SelectEthovisionDat(tcol,dcol)

%%% THIS FUNCTION READS MULTI COLUMN, ';' DELIMITED DATA FILE OF TEXTS AND
%%% NUMERIC VALUES. MISSING DISPLACEMENT DATA ADN CORRESPONDING TIME POINTS
%%% ARE REMOVED. MULTIPLE FILES CAN BE READ EACH TIME.
%%% TWO COLUMNS (DEFAULTS: COLUMNS 2 AND 8) ARE READ AND SAVED TO A .TXT
%%% FILE. THE OUTPUT FILES ARE IN A FOLDER CALLED "EthoVisionSelectData" 
%%% IN THE SAME PATH AS THE INPUT FILES. OUTPUT FILENAME HAS THE SAME 
%%% NAME AS THE INPUT FILE, WITH"_select" APPENDED.

% Call function as:
% ReadANDSave_SelectEthovisionDat(1,5)
% or ReadANDSave_SelectEthovisionDat.
% In the latter case, the 2nd and 8th columns from the input file are read
% and saved by default.

% Written for use in Sumathipala et al. (2023): hyperactivity in syngap1a
% and syngap1b zebrafish.

% sheyum. 2019.


if nargin<2 || ~isnumeric(dcol), dcol=8; end
if nargin<1 || ~isnumeric(tcol), tcol=2; end

%%%%***************** may require user input***************

n_strcols=12; %%%number of columns in the file
n_headlines=35;  %%%number of rows of file header.
cutoff=0.0;  %%% minimum displcement value that will be saved in file.
%%% smaller movements and corresponding time points excluded.
%%%%%%%*************************************************


frmt=repmat('%s ',1,n_strcols); %%%format of file. All strings.
%%% Make sure this format conforms to
%%% that of Ethovision file being read.

[f_name,p_name] = uigetfile({'*.TXT';'*.txt'},'Select files',...
    'Multiselect','on',' ');
nofiles=size(f_name,2);
%if a single file is loaded, adjust parameters
if (iscell(f_name)==0) && isempty(f_name)==0
    nofiles=1; f_name=cellstr(f_name);
end
disp(' ')
fprintf('    Total number of files:%g\n',nofiles)
fprintf('    Folder name:%s\n',p_name)
disp(' ')

%%%%% Make a folder within raw data folder to save output files
Outfilepath=fullfile(p_name, 'EthoVisionSelectData');

if ~exist(Outfilepath, 'dir')
    mkdir(Outfilepath);
end


%%% 'nofiles' is number of files read. 'f_name' is a cell that contains all
%%% input file names.

for fileloop=1:nofiles
    filename=fullfile(p_name,f_name{fileloop});
    disp(' ')
    fprintf('Reading data from %s \n',f_name{fileloop})
    fid=fopen(filename);
    C1=textscan(fid,frmt,'delimiter',';','headerlines',n_headlines);
    fclose(fid);

    %%% move to next input file if current file was empty %%%
    if isempty(C1)
        warning('Input file was empty or had incorrect format')
        continue
    end

    %%read in relevant columns from current file
    time=str2double(C1{1,tcol}(:,1)); %% time is in seconds
    displ=str2double(C1{1,dcol}(:,1));
    clear C1;

    %%% Check properties of time and displacement arrays%%%
    if sum(isnan(displ))==numel(displ)
        warning(' No valid displacement data in this file')
        continue
    end
    if sum(isnan(time))==numel(time)
        warning(' No valid time data in this file')
        continue
    end
    if numel(time)~=numel(displ)
        warning('Time and displacement columns have unequal sizes')
        continue
    end

    %%%get rid of NaNs, as there are instances where displacement info is
    %%%missing. Display a message for user.
    locs=find(isnan(displ));
    fprintf('%g out of a total %g rows, %g percent, are missing \n',...
        numel(locs),numel(time),numel(locs)/numel(time)*100)
    displ(locs)=[];
    time(locs)=[];

    %%% remove additional rows, those corresponding to movements smaller
    %%% than the set 'cutoff' value. Construct table with two columns.
    time=time(displ>cutoff);
    displ=displ(displ>cutoff);
    allselectdata=array2table([time, displ],...
        'VariableNames',{'Time (sec)', 'Displacemnt (mm)'});

    %%%save Table data to file. Output file name has "_select" appended to
    %%%input file name.
    indx=strfind(f_name{fileloop},'.txt');  %%%find/remove .txt in filename
    outputfilepath=fullfile(Outfilepath,f_name{fileloop}(1:indx-1));
    outputfilepath=[outputfilepath,'_select','.txt'];
    writetable(allselectdata,outputfilepath,'Delimiter','\t');

    disp (' ')
end


end

