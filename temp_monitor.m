function temp_monitor(a)
% TEMP_MONITOR  LED Temperature Monitoring Device - Task 2
% Green D13: constant ON when 18-24
% Yellow D8: blinks 0.5s when below 18
% Red D11: blinks 0.25s when above 24

    yellowPin = 'D8';
    redPin    = 'D11';   %setting my circuit arrangement 
    greenPin  = 'D13';
    sensorPin = 'A0';

    % Setting up the live graph
    figure('Name', 'Live Temperature Monitoring');
    h = plot(NaN, NaN, '-b', 'LineWidth', 2);  %setting visual paramters for graph
    xlabel('Time (seconds)');            %labelling axism set line of graph to blue 
    ylabel('Temperature (°C)');
    title('Live Temperature Monitoring');
    grid on;
    xlim([0 60]); %upper and lower bounds of the axes
    ylim([0 40]);  %just made a guess on approiateb bounds 
    hold on;

    startTime = tic; %starts timer and the initially empty time and temp arrays
    timeData = [];
    tempData = [];

    disp('Starting temperature monitoring : Press Ctrl+C to stop.');

    while true   %this while loop displays the tempertaure range on the LEDs
        %it keeps going until the ser stopsit by pressing control and C
        % Read temperature

        voltage = readVoltage(a, sensorPin);
        tempC   = voltage * 100;   

        % This line prints the temperature readings as they are being read
        disp(['Temperature = ', num2str(tempC, '%.1f'), ' °C']);       


        % Adds to data
        currentTime = toc(startTime);
        timeData(end+1) = currentTime;
        tempData(end+1) = tempC;

        % Updating graph according to current data in feed (real time
        % updates)(
        set(h, 'XData', timeData, 'YData', tempData);
        if currentTime > 60
            xlim([currentTime-60 currentTime]);
        end
        drawnow;

        % Control LEDs

        if tempC >= 18 && tempC <= 24  %keeps green LED on when temp is in range 
            writeDigitalPin(a, greenPin, 1);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 0);
        elseif tempC < 18
            writeDigitalPin(a, greenPin, 0); %blinks yellow when temp is too low
            writeDigitalPin(a, redPin, 0);
            writeDigitalPin(a, yellowPin, 1); pause(0.25);
            writeDigitalPin(a, yellowPin, 0); pause(0.25);
        else
            writeDigitalPin(a, greenPin, 0); %simultaneously blinks red when temp is > 24
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 1); pause(0.125);
            writeDigitalPin(a, redPin, 0); pause(0.125);
        end

        pause(1);
    end
end