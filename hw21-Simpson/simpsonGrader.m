function [points, notes] = simpsonGrader()
% Function to evaluate student submitions

% Total number of points
points = 200;
notes = '';
tol = 1e-8;

%% Check same size vectors
x = 1:8;
y = 1:7;
fprintf('First Test:\n')
try
    evalc('Simpson(x,y)');
    evalc('Simpson(y,x)');
    % if this did not throw an error it continues
    notes = [notes, 'No error check for same size data vectors, -10.',  ' '];
    points = points - 10;
catch
    fprintf('  Correct error check for same size data vectors.\n')
end

%% Check even data spacing
x = [1, 3, 3.7, 15];
y = [1, 2, 3, 4];
fprintf('Second Test:\n')
try
    evalc('Simpson(x, y)');
    % if this did not throw an error it continues
    notes = [notes, 'No error check for uniform data spacing, -10.',  ' '];
    points = points - 10;
catch
    fprintf('  Correct error check for uniform data spacing.\n')
end

%% Check trapazoid rule
x = [0, 1];
y = [0, 2];

% exact solution
Ie = trapz(x, y);

fprintf('Third Test:\n')
try
    lastwarn('');
    evalc('I = Simpson(x, y)');
    warnMsg = lastwarn;

    % check for trapz use warning
    if ~isempty(warnMsg)
        fprintf('  Correct warning for trapazoid rule.\n')
    else
        notes = [notes, 'No warning for trapazoid rule, -5.',  ' '];
        points = points - 5;
    end

    % check value
    if norm(Ie - I) < tol
        fprintf('  Correct trapazoid rule.\n')
    else
        notes = [notes, 'Incorrect trapazoid rule, expected value of ' num2str(Ie), ' but got ', num2str(I),  ' instead, -20. '];
        points = points - 20;
    end

catch
    notes = [notes, 'Trapazoid rule failed, -25.',  ' '];
    points = points - 25;
end
%% Check simpsons rule
x = [0, 0.5,  1];
y = [0, 1, 2];

% exact solution
Ie = trapz(x, y);

fprintf('Fourth Test:\n')
try
    lastwarn('');
    evalc('I = Simpson(x, y)');
    warnMsg = lastwarn;
    
    % check for warning
    if ~isempty(warnMsg)
        notes = [notes, 'False warning given, -10.',  ' '];
        points = points - 10;
    end

    % check value
    if norm(Ie - I) < tol
        fprintf('  Correct simpson 1/3 rule.\n')
    else
        notes = [notes, 'Incorrect simpson 1/3, expected value of ' num2str(Ie), ' but got ', num2str(I),  ' instead, -20. '];
        points = points - 20;
    end
    
catch
    notes = [notes, 'Simpson rule failed, -20.',  ' '];
    points = points - 20;
end

%% Check a real problem
x = 0:0.25:16.25; % choose a evenly divisible number spacing
y = exp(-x); % integral of this from 0 to inf is 1

% exact solution
Ie = 1.0;
% trap rule is an over estimate
Ia = trapz(x, y);

fprintf('Fifth Test:\n')
try
    lastwarn('');
    evalc('I = Simpson(x, y)');
    warnMsg = lastwarn;

    % check for warning
    if ~isempty(warnMsg)
        fprintf('  Correct warning for trapazoid rule.\n')
    else
        notes = [notes, 'No warning for trapazoid rule, -5.',  ' '];
        points = points - 5;
    end

    % check value from simpsons rule is more accurate than trapazoid rule
    if norm(Ie - I) < norm(Ia - I)
        fprintf('  Correct composite integration.\n')
    else
        notes = [notes, 'Incorrect composite integration, expected value less than ' num2str(Ia), ' but got ',  num2str(I), ' instead, -20. '];
        points = points - 20;
    end

catch
    notes = [notes, 'Composite integration failed, -25.',  ' '];
    points = points - 25;
end

end

