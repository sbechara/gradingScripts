% A grading script
% locate this in the same directory as all studend homeworks
format compact
clc; clear all; close all;
    
% the test function name, change as appropriate
testFuncName = 'luFactor';
% directory to look in, change as appropriate
dir_loc = 'hw15';
% the file extension
f_ext = '.m';

testFuncFile = [testFuncName, f_ext];
% delete the file in case it already exists
delete(testFuncFile)

% output files
gradeFile = fopen([dir_loc,'Grades.dat'],'w');
fprintf(gradeFile, 'Name:\tGrade:\tNotes\n');
diary([dir_loc,'Output.dat'])

%loop all files
files = dir([dir_loc, '/*', f_ext]);
for file = files'
    notes = '';
    err_notes = '';
    score_mod = 1;
    score_adj = 0;
    nameData = strsplit(string(file.name), "_");
    % check if named correctly, half credit if wrong (canvas download changes file names)
    fprintf('\n---- Running test for student %s ----\n', nameData(1))
    fprintf('   submitted file named: %s\n', file.name)
    % check if late, give zero credit
    if contains(string(file.name) , "late")
       fprintf(' ** Submission is late! **\n')
       err_notes = [err_notes, 'Subbmited Late, 0 credit!', ' '];
       score_mod = 0.0;
    end
    
    % pull the file into a string to allow content checks
    fid = fopen([dir_loc, '/', file.name],'r');
    fstr = char(fread(fid).');
    fclose(fid);
    
    % check file name
    if ~contains(string(file.name) , string(testFuncName))
       fprintf(' ** File is named incorrect! **\n')
       err_notes = [err_notes, 'File name wrong, -50!', ' '];
       score_adj = -50;
       % try to rename the function, file will be renamed regardless
       fstr = regexprep(fstr, testFuncName, testFuncName, 'ignorecase');
       fid = fopen(testFuncFile,'w');
       fwrite(fid,fstr);
       fclose(fid);
    else % file is fine, so copy to working dir and rename
       copyfile([dir_loc, '/', file.name], testFuncFile)
    end
    % check for clc or close all
    if contains(string(fstr), "clc") || contains(string(fstr), "clear all") && ~contains(string(fstr), "%")
        err_notes = [err_notes, 'Never put "clc" or "clear all" in a function!', ' '];
    end
    % check use of certine function
    if contains(string(fstr), "lu(")
        err_notes = [err_notes, 'Suspected use of matlab lu function!', ' '];
    end

    % run a test script
    score = -1;
    try 
        [score, notes] = luGrader();
        % Print results
        fprintf('%s\n', notes);
        % make sure possitive grade
        if score < 0, score = 0; end
    catch
        fprintf(' ** Failed to run! **\n')
        err_notes = [err_notes, 'Failed to run!', ' '];
        score = 0;
    end

    fprintf(' -- Recived final grade of %f -- \n', score*score_mod+score_adj);
    fprintf(gradeFile, '%s\t%f\t%s\n', nameData(1), score*score_mod+score_adj, [err_notes, notes]);
    % delete the file
    delete(testFuncFile)
    % make sure no plots are created
    close all
end