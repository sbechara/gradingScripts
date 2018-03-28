function [points, notes] = luGrader()
% Function to evaluate student submitions

% Total number of points
points = 200;
notes = '';
tol = 1e-6;


%% a rectuangular matrix should throw an error
A = eye(4,7);
fprintf('First Test:\n')
try
    evalc('luFactor(A)');
    % if this did not throw an error it continues
    notes = [notes, 'No error check for square matricies, -20.',  ' '];
    points = points - 20;
catch
    fprintf('  Some form of error detection for non-square matrix.\n')
end


%% test with a 3x3 matrix
A = [2, -1, 3;
    1, 7, 4;
    -3, 1, -3];
% solve using matlab function
[Le, Ue, Pe] = lu(A);

% This looks bad but stops student output
try
    evalc('[L, U, P] = luFactor(A)');
catch
    try
        evalc('[L, U] = luFactor(A)');
    catch
        try
        evalc('[L] = luFactor(A)');
        catch
            notes = ['Function fails to run or has no output, -80.', ' '];
            points = points - 80;
            return
        end
        notes = [notes,'Pivot matrix missing.', ' '];
        P = eye(3);
    end
    notes = [notes,'U matrix missing.', ' '];
    U = eye(3);
end
passed = [0, 0, 0];

fprintf('Second Test: A 3x3 matrix\n')
% examine U
if ~istriu(U) 
    notes = [notes, 'U is not upper triangular, -20.',  ' '];
    points = points - 20;
elseif norm(Ue - U) > tol
    notes = [notes, 'U is incorrect, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct U\n')
    passed(1) = 1;
end
% examine L
if ~istril(L) 
    notes = [notes, 'L is not lower triangular, -20.',  ' '];
    points = points - 20;
elseif norm(Le - L) > tol
    notes = [notes, 'L is incorrect, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct L\n')
    passed(2) = 1;
end
% examine P
if norm(P) ~= 1
    notes = [notes, 'P is not a valid permutation, -20.',  ' '];
    points = points - 20;
elseif norm(Pe - P) > tol
    notes = [notes, 'P is incorrect, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct P\n')
    passed(3) = 1;
end
% double check U and L
if (norm(P*A - L*U) < tol) && ~(passed(1) && passed(2))
    notes = [notes, 'L*U=P*A is valid,', ' '];
    if(trace(L) ~= 3)
        notes = [notes, 'but not in standard form, +15 to compensate.', ' '];
        points = points + 15;
    elseif ~passed(3)
        notes = [notes, 'but not pivoted correctly, +20 to compensate.', ' '];
        points = points + 20;
    else
        notes = [notes, 'but factored wrong, +10 to compensate.', ' '];
        points = points + 10;
    end
end


%% test with a 7x7 matrix
% it's a tricky one, it is zero along the diagonal 
% so requires good pivoting
A = magic(7) - magic(7)';
% solve using matlab function
[Le, Ue, Pe] = lu(A);

try
    evalc('[L, U, P] = luFactor(A)');
catch
    notes = [notes, 'Factorization of hard matrix failed, -30.', ' '];
    points = points - 30;
    return
end
passed = [0, 0, 0];
fprintf('Third Test: A "hard" matrix\n')
% examine U
if norm(Ue-U) > tol
    notes = [notes, 'U is incorrect for hard matrix, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct U\n')
    passed(1) = 1;
end
% examine L
if norm(Le-L) > tol
    notes = [notes, 'L is incorrect for hard matrix, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct L\n')
    passed(2) = 1;
end
% examine P
if norm(Pe-P) > tol
    notes = [notes, 'P is incorrect for hard matrix, -10.', ' '];
    points = points - 10;
else
    fprintf('  Correct P\n')
    passed(3) = 1;
end
% double check U and L
if (norm(P*A - L*U) < tol) && ~(passed(1) && passed(2))
    notes = [notes, 'L*U=P*A is valid,', ' '];
    if(trace(L) ~= 7)
        notes = [notes, 'but not in standard form, +15 to compensate.', ' '];
        points = points + 15;
    elseif ~passed(3)
        notes = [notes, 'but not pivoted correctly, +20 to compensate.', ' '];
        points = points + 20;
    else
        notes = [notes, 'but factored differently, +10 to compensate.', ' '];
        points = points + 10;
    end
end

end