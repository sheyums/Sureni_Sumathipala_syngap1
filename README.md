# Sureni_Sumathipala_syngap1
%%%% function ReadANDSave_SelectEthovisionDat(tcol,dcol)  
%%% THIS Matlab FUNCTION READS MULTI COLUMN, ';' DELIMITED DATA FILE OF TEXTS AND
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
