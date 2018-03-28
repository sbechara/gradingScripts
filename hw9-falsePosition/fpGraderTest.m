function [points, notes] = fpGraderTest()
% Function to evaluate student submitions

% Total number of points
points = 200;
notes = '';

% symbolic
syms f(V);
% Use the VanDerWaals Equation
P = 6; % in atm
T = 323.15; % in K
n = 2; % in mol
R = 0.08206;
a = 3.59;
b = 0.0427;

% symbolic
f(V) = (P + ((n^2*a)/V^2))*(V-n*b)-(n*R*T);
% anonymous
fa = @(v) (P + ((n^2*a)./v.^2)).*(v-n*b)-(n*R*T);

% First test with default settings. Looks bad but stops student output
try % try symbolic
    evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9)');
catch % try anonymous
    notes = [notes, 'Symbolic function argument failed.', ' '];
    try
        evalc('[root,fx,ea,iter] = falsePosition(fa,8,9)');
    catch
        notes = [notes, 'Anonymous function argument failed.', ' '];
        try
            evalc('[root,fx,ea,iter] = falsePosition(fa,8,9,0.0001,3)');
            notes = [notes, 'Function defaults do not work, -20.', ' '];
            points = points -20;
        catch
            try
                evalc('root = falsePosition(fa,8,9,0.001,3)');
                
                % most tests will fail, best score is 120 so assign and exit
                notes = ['Function output arguments incorrect, can not test code -80.', ' '];
                fprintf(notes);
                fprintf('\n');
                points = 120;
                return
            catch
                notes = ['Function does not run -100.', ' '];
                fprintf(notes);
                fprintf('\n');
                points = 100;
                return
            end
        end
    end
end
% Answers should be...
% root = 8.6507     fx = -7.8566e-09    ea = 1.2562e-05     iter = 3
fprintf('First Test:\n')
if abs(root - 8.6507) > 1.0e-2 % > 8.651 || root < 8.620
    notes = [notes, 'Incorrect root ', num2str(root), ' vs ', '8.65607, -20.',  ' '];
    points = points - 20;
elseif fx > 1e-6
    notes = [notes, 'Function not sufficiently converged, -20.', ' '];
    points = points - 20;
else
    fprintf('  Correct root\n')
end
if ea > 0.0001
    notes = [notes, 'Approximate error too large, -20.', ' '];
    points = points - 20;
else
    fprintf('  Approximate error within tolerance\n')
end
if iter == 3
    fprintf('  Number of iterations correct\n')
else
    notes = [notes, 'Number of iterations incorrect, -20.', ' '];
    points = points - 20;
end


% Check to make sure es is adjustable
%evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9,0.1)');
try % try symbolic
    evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9,0.1)');
catch % try anonymous
    try
        evalc('[root,fx,ea,iter] = falsePosition(fa,8,9,0.1)');
    catch
    end
end
% Answers should be...
% root = 8.6207     fx = -6.3227e-06    ea = 0.0101     iter = 2
fprintf('Second Test:\n')
% Not double counting errors for incorrect root or iterations
if ea > 0.1
    notes = [notes, 'Specified approximate error too high, -20.', ' '];
    points = points - 20;
elseif ea < 0.001
    notes = [notes, 'Specified approximate error too low, -20.', ' '];
    points = points - 20;
else
    fprintf('  Approximate error within tolerance\n')
end


% Check to make sure maxiter is adjustable
% evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9,1e-15,4)');
try % try symbolic
    evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9,1e-15,4)');
catch % try anonymous
    try
        evalc('[root,fx,ea,iter] = falsePosition(fa,8,9,1e-15,4)');
    catch
    end
end
% Answers should be...
% root = 8.6207     fx = -9.7604e-12    ea = 1.5607e-08     iter = 4
fprintf('Third Test:\n')
% Not double counting errors for root or ea
if iter == 4
    fprintf('  Number of iterations correct\n')
else
    notes = [notes, 'Specified number of iterations incorrect, -20.', ' '];
    points = points - 20;
end

% % First test with default settings. Looks bad but stops student output
% try % try symbolic
%     evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9,1e-15,4)');
% catch % try anonymous
%     notes = [notes, 'Symbolic function argument failed.', ' '];
%     try
%         evalc('[root,fx,ea,iter] = falsePosition(fa,8,9,1e-15,4)');
%     catch
%         notes = [notes, 'Anonymous function argument failed.', ' '];
%         try
%             evalc('root = falsePosition(fa,8,9,1e-15,4)');
%             % most tests will fail, best score is 120 so assign and exit
%             notes = ['Function output arguments incorrect, can not test code -80.', ' '];    
%             fprintf('%s\n', notes);
%             points = 120;
%             return
%         catch
%         end
%     end
% end
% % Answers should be...
% % root = 8.6507     fx = -9.7604e-12    ea = 1.5607e-08     iter = 4
% fprintf('First Test:\n')
% if abs(root - 8.6507) > 1.0e-3
%     notes = [notes, 'Incorrect root ', num2str(root), ' vs 8.65607, -20.',  ' '];
%     points = points - 20;
% elseif abs(fx) > 1e-10
%     notes = [notes, 'Function not sufficiently converged, -20.', ' '];
%     points = points - 20;
% else
%     fprintf('  Correct root\n')
% end
% if ea > 2*1.5607e-08
%     notes = [notes, 'Specified approximate error to large, -20.', ' '];
%     points = points - 20;
% else
%     fprintf('  Approximate error within tolerance\n')
% end
% if iter == 4
%     fprintf('  Number of iterations correct\n')
% else
%     notes = [notes, 'Number of iterations incorrect, -20.', ' '];
%     points = points - 20;
% end
% 
% 
% % Check to make sure defaults exist
% try % try symbolic
%     evalc('[root,fx,ea,iter] = falsePosition(@(V) f(V),8,9)');
% catch % try anonymous
%     try
%         evalc('[root,fx,ea,iter] = falsePosition(fa,8,9)');
%     catch
%         notes = [notes, 'Function fails with default parameters -20.', ' '];    
%         points = points -20;
%         return
%     end
% end
% % Answers should be...
% % root = 8.6507     fx = -7.8566e-09    ea = 1.2562e-05     iter = 3
% fprintf('Third Test:\n')
% % Not double counting errors for root
% if ea > 2*1.2562e-05
%     notes = [notes, 'Default approximate error to large, -20.', ' '];
%     points = points - 20;
% else
%     fprintf('  Approximate error within tolerance\n')
% end
% % can't easily test default number of iterations without a messy function

fprintf('%s\n', notes);
% should never go negative
if points < 0, points = 0; end

end