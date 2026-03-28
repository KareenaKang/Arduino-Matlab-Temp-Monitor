%task 3

function temp_predict(a)
%attempting to create a function that will hopefully calc the rate of
%change of temp, makes predictions for future temp readings, controls LEDs

%setting paramters for the function to consider
min_comfort = 18; %lowest okay temp
max_comfort = 24; %highest okay temp
red_Pin = 'D11';
yellow_Pin = 'D8';
green_Pin = 'D13';

noise_buffer =5; %this is the amount of readings i will consider in order 
% to filter out any noise from the readings 

%remembering old values between each cycle 
persistent temp_buffer time_buffer 

if isempty(temp_buffer)
    temp_buffer = zeros(1,noise_buffer); %starting empty
    time_buffer = zeros(1,buffer_size);
end 

current_temp = temp_monitor(a); %calling my function from the previous task

current_Time = clock;
current_Time = current_time(4)*3600 + current_time(5)*60 +current_time(6);
%i think this will give a full clock

temp_buffer = [temp_buffer(2:end) current_temp];
time_buffer = [time_buffer(2:end) current_time];

%only makes calculateions when there is enough reasings 
if time_buffer(1) > 0 
    %Simple average rate over the last few readings top smooth noise 
    delataT = temp_buffer(end) - temp_buffer(1); %change calc
    deltaTime = time_buffer(end) - time_buffer(1);
    rate_C_per_sec = deltaT / deltaTime;
else 
    rate_C_per_sec = 0;
end 

fprintf('Rate of Change:  %.2f °C    |    Predicted in 5 min: %.2f °C\n', ...
        current_temp, predicted_5min);

rate_C_per_min = rate_C_per_sec * 60 %converts the change rate from seconds to minutes

if rate_C_per_min > 4 %if deltaT is increasing too fast
    writeDigitalPin(a, red_Pin, 1);
    writeDigitalPin(a, yellow_Pin, 0);
    writeDigitalPin(a,green_Pin,0);
elseif rate_C_per_min < -4 %if deltaT is decreasing too fast
    wrietDigitalPin(a,red_Pin,0);
    writeDigitalPin(a, yellow_Pin,1);
    writeDigitalPin(a, green_Pin,0);
else current_temp >= comfort_min && current_temp <= comfort_max
    writeDigitalPin(a, red_Pin,0); %if deltat is inside the comfortable range
    writeDigitalPin(a, yellow_Pin,0);
    writeDigitalPin(a.green_Pin,1);
end

pause (0.5)%pause slightly so the loop doesn't overload with values too quickly
end 


