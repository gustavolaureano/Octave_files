clear all;
close all;
clc;

%===============================================================================
% all rates in Hz (steps/second)
initial_step_rate =     400;
max_step_rate =       2000;
step_acceleration =     8000;

steps_to_do =           800;
%===============================================================================


steps_to_accelerate = floor(((max_step_rate^2)-(initial_step_rate^2))/(2*step_acceleration));

disp('==================================');
disp('Steps to ramp (calculated):');
disp(steps_to_accelerate);

if (steps_to_do < (2*steps_to_accelerate)) 
  steps_to_accelerate = floor(steps_to_do/2);  
endif

disp('Steps to ramp (applied):');
disp(steps_to_accelerate);
disp('Initial speed (step/s)');
disp(initial_step_rate);
disp('Acceleration (step/s.s)');
disp(step_acceleration);
disp('Final speed (step/s)');
disp(max_step_rate);
disp('----------------------------------');

steps_freqtable(1) = initial_step_rate;
timevector(1) = 1/initial_step_rate;

for i=2:steps_to_do
  
  if(i >= (steps_to_do-steps_to_accelerate))
  % deceleration
  steps_freqtable(i) = steps_freqtable(i-1) - (step_acceleration/steps_freqtable(i-1));
  
  elseif (i <= steps_to_accelerate)
  % acceleration
  steps_freqtable(i) = steps_freqtable(i-1) + (step_acceleration/steps_freqtable(i-1));
  
  else
  % steady move
  steps_freqtable(i) = steps_freqtable(i-1);
  endif
  
  timevector(i) = timevector(i-1) + (1/steps_freqtable(i));
  
endfor

disp('Total moving time (s):');
disp(timevector(end));
disp('==================================');

%figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
plot(timevector,(steps_freqtable),'k','LineWidth',1);
%title('');
xlabel('Time (s)');
ylabel('Speed (steps/s)');
xlim([-(0.05*timevector(end)) (timevector(end)*1.05)]);
ylim([0 max(steps_freqtable)+initial_step_rate]);
grid minor;

subplot(2,1,2)       % add second plot in 2 x 1 grid
plot(timevector,1:steps_to_do,'k','LineWidth',1);
xlabel('Time (s)');
ylabel('Position (steps)');
xlim([-(0.05*timevector(end)) (timevector(end)*1.05)]);
ylim([-(0.1*steps_to_do) (steps_to_do*1.1)]);
grid minor;
