%% 
clear all;
clc;
%% Flyback Parameters
V_line_minimum= 210; % V rms
V_line_max=230 ; % Vrms
V_dc_min= 280; % 5 percentage ripple
V_dc_max=sqrt(2)*V_line_max;
Output_power= 15; % Watt
Efficiency= 0.95 ; % between 0-1 
Input_power= Output_power/Efficiency;

%% DC Link Capacitor Calculation
D_ch=0.2; % for capacitor charging duty
F_line= 50; % Line frequency 

C_DC = (Input_power*(1-D_ch))/ ...
    (F_line*((2*V_line_minimum^2)-V_dc_min^2));

fprintf(' %f microFarad \n',C_DC*1e6);


%% Determination of Maximum Duty Cycle
D_max= 0.6 ; % for CCM mode, it is bigger than 0.5
V_Ro= (D_max/(1-D_max))*V_dc_min;
V_ds= V_dc_max+V_Ro;

%% Lm Determination
f_s= 45000; % Switching Frequecny Hertz
K_f= 0.3; % for ccm 0.25-0.50 
L_m= (( V_dc_min*D_max)^2)/(2*Input_power*f_s*K_f)...
    *1e3; % mili Henry
fprintf('% f mH \n', L_m);
L_m=L_m*1e-3;

%% Calculation of peak current of FSP( mosfet, IGBT)
I_edc= Input_power/(V_dc_min*D_max); % average ...
... switching amplifier
Delta_Ids= (V_dc_min*D_max)/(L_m*f_s);
Ids_Peak=I_edc+(Delta_Ids/2);
Ids_rms=sqrt((3*I_edc^2) + ((Delta_Ids/2)^2*D_max/2));
fprintf('%f %f \n',Ids_Peak,Ids_rms);

%% Primary Side Turns Determination
Ae=540*1e-6; % m^2  
B_sat=1/2 ; %Tesla
N_p= ((L_m*Ids_Peak)/(B_sat*Ae));
fprintf('%f \n', N_p);

%% Secondary Side Turn Ratio

N_s= N_p/((V_Ro)/(15+0.7));
fprintf('%f \n', N_s);



