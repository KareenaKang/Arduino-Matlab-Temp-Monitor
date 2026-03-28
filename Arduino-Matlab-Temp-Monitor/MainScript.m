% Kareena Kang
% egykk15@nottingham.ac.uk

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

clear a
a = arduino('COM3', 'Uno');

for i = 1:10
    writeDigitalPin(a, 'D10', 1);   % LED ON
    pause(0.5);
    writeDigitalPin(a, 'D10', 0);   % LED OFF
    pause(0.5);
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

%b)
clear a; 

duration = 600; %aquisition time in seconds 
samplesPerMinute = 60;

a = arduino('COM3','Uno');

disp('Starting Temperature acquisition for capsule (10 minutes)');

%creating arrays to store the time and temp values
timeData = zeros(1, duration);
tempData = zeros(1, duration);

startTime = tic; %starts the timer


for i = 1:duration
    voltage = readVoltage(a, 'A0'); %reads volatage from my chosen pin

    temperature = (voltage - 0.5) * 100; 
%Converts voltage to temperature using Vout = VO + Tc * T
%where VO = 0.5, Tc = 0.01 - is the right formula i think

    currentTime = toc(startTime); %The time passed since the start

    timeData(i) = currentTime; %stores data
    tempData(i) = temperature;

    pause(1); %Reads values every second
end 

%Calculating the three required statistical quantities 

minTemp = min(tempData);
maxTemp = max(tempData);
avgTemp = mean(tempData);

%displaying the stat results in a table

fprintf('\nMinimum: %.2f °C | Maximum: %.2f °C | Average: %.2f °C\n\n', minTemp, maxTemp, avgTemp);

%c)
figure; %Creating the window for the graph
plot(timeData, tempData, 'b-', 'LineWidth',2);
xlabel('Time (seconds)'); %labelling the axis 
ylabel('Temperature (°C)');
title('Suborbital Capsule Temperature over 10 minutes');
grid on;

%Save plot as an image for Word template
saveas(gcf, 'temp_plot.png');
disp('Plot saved as temp_plot.png');

%d)e)
%using the sprintf to create the exact format required
logFile = fopen('capsule_temperature.txt', 'w');
fprintf(logFile,'Capsule Temperature Log\n\n');

for minute = 0:10
    % Finding all samples that belong to this minute
    startSec = minute * 60 + 1;
    endSec = min((minute + 1) * 60, duration);
    
    if startSec > duration
        break;
    end
    
    % Calculates average temperature for this minute
    avgMinuteTemp = mean(tempData(startSec:endSec));
    
    % Creates the line
    line = sprintf('Date: 25/03/2026   Location: X   Minute: %d   Temperature: %.2f °C', ...
                   minute, avgMinuteTemp);
    
    fprintf('%s\n', line);           % Shows on screen
    fprintf(logFile, '%s\n', line);  % Saves it to file
end

fclose(logFile);


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Main Script for Task 2 - LED Temperature Monitoring Device
clear; clc;

% Creating the Arduino connection
a = arduino;

% Calls the function for Task 2
temp_monitor(a);



%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

temp_predict(a); %ccalling function defined in task 3 temp_predict file


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% No need to enter any answers here, please answer on the .docx template.


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.