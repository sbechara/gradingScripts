function [points, notes] = heunGrader()
% Function to evaluate student submitions

% Total number of points
points = 200;
notes = '';
tol = 1e-8;

% a test case
f = @(t, y) exp(-t) - y;
y_exact = @(t) t.*exp(-t);
y0 = 0.0;
tspan = [0, 2];

%% Check a single step, no ittion (explict euler)
h = tspan(2);
fprintf('First Test:\n')
try
    evalc('[t,y] = Heun(f, tspan, y0, h, 0.1, 1)');
catch
    try
        evalc('[t,y] = Heun(f, tspan, y0, h)');
        notes = [notes, 'Function does not run with specified inputs, -40.',  ' '];
        points = points - 40; % they will lose more in the first test
    catch
        notes = [notes, 'Function fails to run, -80.',  ' '];
        points = points - 80;
        return
    end
end

% check if vector transposed
[t, isMat] = vectTranposeCheck(t);
if isMat
    notes = [notes, 'Why is t a matrix?, -20.',  ' '];
    points = points - 20;
end
[y, isMat] = vectTranposeCheck(y);
if isMat
    notes = [notes, 'Why is y a matrix?, -20.',  ' '];
    points = points - 20;
end

% check output size
offset = 0;
if length(t) ~= 2
    notes = [notes, 'Wrong sized t, -10.',  ' '];
    points = points - 10;
    offset = -1;
elseif any(t ~= tspan)
    notes = [notes, 'Incorect t, -20.',  ' '];
    points = points - 20;
end

if length(y) ~= 2
    notes = [notes, 'Wrong sized y, -10.',  ' '];
    points = points - 10;
elseif y(1) ~= y0
    notes = [notes, 'First element of y should be initial condition, -20.',  ' '];
    points = points - 20;
end

% compare value for the single step
% this is either explicit euler or single heun depending on code
exactEE = y0 + f(tspan(1), y0)*h;
exactH = y0 + (f(tspan(1), y0) + f(tspan(2), exactEE))*h/2.0;
if abs(y(end) - exactH) < tol
    fprintf('  Heuns with no itation correct\n')
elseif abs(y(end) - exactEE) < tol
    notes = [notes, 'Heuns method with no iteration reverts to explicit euler, -5.',  ' '];
    points = points - 5;
elseif abs(y(end) - y_exact(t(end))) < abs(y(end) - exactH)
    notes = [notes, 'Heuns method does to many iterations, -5.',  ' '];
    points = points - 5;
else
    notes = [notes, 'Heuns with no iteration incorrect, -20.',  ' '];
    points = points - 20;
end

%% Test a problem
h = 0.2;
fprintf('Second Test:\n')
try
    evalc('[t,y] = Heun(f, tspan, y0, h)');
catch
    try
        evalc('[t,y] = Heun(f, tspan, y0, h, 0.01, 50)');
        notes = [notes, 'Function fails to run with defaults, -20.',  ' '];
        points = points - 20;
    catch
        notes = [notes, 'Function fails to run for full problem, -60.',  ' '];
        points = points - 60;
        return
    end
end

% check if vector transposed
t = vectTranposeCheck(t);
y = vectTranposeCheck(y);

% check output size
if length(t) ~= (tspan(2)-tspan(1))/h + 1 + offset
    notes = [notes, 'Wrong sized t, -10.',  ' '];
    points = points - 10;
elseif ((max(diff(t)) - min(diff(t))) > tol) && (abs(max(diff(t)) - h) < tol)
    notes = [notes, 't does not use spacing h, -20.',  ' '];
    points = points - 20;
end

if length(y) ~= length(t)
    notes = [notes, 'Inconsistent lenghts for  and y, -10.',  ' '];
    points = points - 10;
end

% compare value to exact
if norm(y_exact(t) - y) < 0.1
    fprintf('  Iterative Heuns apparently correct\n')
else
    notes = [notes, 'Iterative Heuns incorrect, -20.',  ' '];
    points = points - 20;
end

%% Test uneven spacing
h = 0.13;
fprintf('Third Test:\n')
try
    evalc('[t,y] = Heun(f, tspan, y0, h)');
catch
    try
        evalc('[t,y] = Heun(f, tspan, y0, h, 0.01, 50)');
    catch
        notes = [notes, 'Function fails to run when interval not evenly divisible, -20.',  ' '];
        points = points - 20;
        return
    end
end

% check if vector transposed
t = vectTranposeCheck(t);
y = vectTranposeCheck(y);

% check end point
if t(end) ~= tspan(2)
    notes = [notes, 't wrong when interval not evenly divisible by h, -10.',  ' '];
    points = points - 10;
end

if length(y) ~= length(t)
    notes = [notes, 'Inconsistent lengths t for and y, -10.',  ' '];
    points = points - 10;
end

% compare last value
if abs(y_exact(t(end)) - y(end)) < 0.1
    fprintf('  Iterative Heuns apparently correct for odd spacing\n')
else
    notes = [notes, 'Last point solved is wrong for uneven spacing, -10.',  ' '];
    points = points - 10;
end

%% check if a plot exists
g = groot;
if isempty(g.Children)
    notes = [notes, 'No plot generated, -10.',  ' '];
    points = points - 10;
else
    close all;
end


end

function [u, isMat] = vectTranposeCheck(u)
    % check if vector transposed, and fix
    s = size(u);
    isMat = false;
    if s(1) > 1 
        u = u';
        if s(2) > 1
            isMat = true;
        end
    end 
end