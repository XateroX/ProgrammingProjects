
clearvars;


l_lim     = 1;
u_lim     = 100;
step_size = 9;

r=0;


z = 1;



    
for n = (l_lim:step_size:u_lim)
    f = figure(z);
    f.Position = [0,0,1920,1080];
    
    disp("");
    disp("n: " + n);
    disp("");
    r = n;
    steps_record = [r];
    while r~=1
        r = collatz(r,1);
        steps_record = [steps_record, r];
    end
    steplist = (1:size(steps_record,2));
    ang = 2*pi*(n/u_lim);
    hold on;
    s = plot(steplist,steps_record,'-','color',[(sin(ang)+1)/2,(sin(ang+(2*pi/3))+1)/2,(sin(ang+(2 * 2*pi/3))+1)/2]);
    hold off;
    xlim([0,50]);
    ylim([0,300]);
end






function r_n = collatz(n,steps)
    while steps~=0
        if mod(n,2)~=0
            n = 3*n+1;
        else
            n=n/2;
        end
        steps=steps-1;
    end
    r_n = n;
end