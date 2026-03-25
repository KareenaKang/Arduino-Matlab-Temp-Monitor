%Kareena Kang
%egykk15@nottinghm.ac.uk

%PRELIMINARY TASK - AROUND AND GIT INSTALLATION [5 MARKS]

clear a
a = arduino('COM3', 'Uno');

for i = 1:10
    writeDigitalPin(a, 'D10', 1);   % LED ON
    pause(0.5);
    writeDigitalPin(a, 'D10', 0);   % LED OFF
    pause(0.5);
end
