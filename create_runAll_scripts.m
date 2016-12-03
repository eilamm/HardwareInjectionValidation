% Eilam Morag
% December 2, 2016
% Creates four scripts that will run all the lalapps-calling scripts
function create_runAll_scripts()
    base = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/';
    % Cumulative Compute
    inputFile = [base, 'recover_pulsarx*cumulative'];
    outputFile = 'ComputeCumulativeRunAllScripts';
    create_runAll_scripts_helper(inputFile, outputFile);
    
    % Daily Compute
    inputFile = [base, 'recover_pulsarx*daily'];
    outputFile = 'ComputeDailyRunAllScripts';
    create_runAll_scripts_helper(inputFile, outputFile);
    
    % Cumulative Predict
    inputFile = [base, 'predict_pulsarx*cumulative'];
    outputFile = 'PredictCumulativeRunAllScripts';
    create_runAll_scripts_helper(inputFile, outputFile);
    
    % Daily Predict
    inputFile = [base, 'predict_pulsarx*daily'];
    outputFile = 'PredictDailyRunAllScripts';
    create_runAll_scripts_helper(inputFile, outputFile);
end