%%TASK 1 - READ TEMPERATURE, DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

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
