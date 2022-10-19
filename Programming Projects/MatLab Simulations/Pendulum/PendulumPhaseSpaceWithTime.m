clear
clc
close all;

a=1;
x=2;

pRes = 10000;
itlim = 500;

%video = VideoWriter('PendulumPhase2Over1.mp4');
%open(video);

vLim = 0.0001;
for v = (vLim:vLim:vLim)

    loopArr = rand(pRes,pRes);
    ind1 = 1;
    for ang1 = (0:pi/pRes:pi)
        ind2 = 1;
        for ang2 = (0:pi/pRes:pi)
            loopArr(ind1,ind2) = loops(itlim,ang1,ang2,  v);
            %disp("ang1: " + ang1);
            %disp("ang2: " + ang2);
            %disp(" ");
            ind2=ind2+1;
        end
        ind1=ind1+1;
        
        f2 = figure(x);
        barh(100*(ang1/pi));
        xlim([0,100]);
    end

    f = figure(a);

    f.Position = [0,0,1920,1080];
    
    pc = surf(loopArr);
    pc.EdgeColor='none';
    xlabel("Ang1e 1 Index");
    ylabel("Ang1e 2 Index");
    zlabel("Loop Count");
    xlim([0,pRes]);
    ylim([0,pRes]);
    view([0,0,180]);

    %frame = getframe(gcf);
    %writeVideo(video,frame);
    
    
end

%close(video);


function loopCount = loops(iters,th1,th2, dth1)

    c=[0,0];
    l1   = 0.5;
    l2   = 0.5;
    m1 = 1;
    m2 = 1;
    dth2 = 0;
    
    a=1;
    g = 1;

    loopCount = 0;
    i=0;
    
    indicator1 = 1;
    indicator2 = 1;
    
    %p1Sum=0;
    %p2Sum=0;
    
    while i < iters
        i = i+1;

        %Mathematics
        ap = -g*(2*m1+m2)*sin(th1);
        b = -m2*g*sin(th1-2*th2);
        cp = -2*(sin(th1-th2))*m2*((dth2*dth2)*l2 + (dth1*dth1)*l1*cos(th1-th2));

        d = l1*(2*m1+m2-m2*cos(2*th1-2*th2));



        e = 2*sin(th1-th2);
        f = (dth1*dth1)*l1*(m1+m2);
        gp = g*(m1+m2)*cos(th1);
        h = (dth2*dth2)*l2*m2*cos(th1-th2);

        ip = l2*(2*m1+m2-m2*cos(2*th1-2*th2));

        ddth1 = ( ap+b+cp )/( d );
        ddth2 = ( e*(f+gp+h) )/( ip );

        dth1 = dth1+0.01*ddth1;
        dth2 = dth2+0.01*ddth2;

        th1 = th1+dth1;
        th2 = th2+dth2;
        
        p1 = [l1*sin(th1), -l1*cos(th1)];
        p2 = [p1(1) + l2*sin(th2), p1(2) - l2*cos(th2)];
        
        
            %  This is for the p1>p2 or p2>p1 mode
        %{
        if (p1(1)>p2(1)) || (p1(2)>p2(2))
            p1Sum = p1Sum+1;
        end
        if (p2(1)>p1(1))  || (p2(2)>p1(2))
            p2Sum = p2Sum+1;
        end
        %}
        
        
            %  This is for the summation of angular velocities mode
        %loopCount = loopCount+dth1+dth2;
        
            %  This is for the th2>th1 mode
        %if (p2(2)>p1(2))
        %    loopCount = loopCount+1;
        %end
        
        
            %  This is for the angle-Inverting mode
        if (dth1<0) == indicator1
            loopCount = loopCount+1;
            if indicator1==0
                indicator1 = 1;
            elseif indicator1==1
                indicator1 = 0;
            end
            %disp("---swapped direction of spin 1---");
        end
        if (dth2<0) == indicator2
            loopCount = loopCount+1;
            if indicator2==0
                indicator2 = 1;
            elseif indicator2==1
                indicator2 = 0;
            end
            %disp("---swapped direction of spin 2---");
        end
        

        %f = figure(a);
        %s1 = scatter(c(1),c(2));
        %hold on
        %s2 = scatter([p1(1),p2(1)],[p1(2),p2(2)], 'blue');
        %hold off
        %hold on
        %line([c(1),p1(1),p2(1)],[c(2),p1(2),p2(2)]);
        %hold off
        %f.Position = [100,100,500,500];
        %xlim([-2,2]);
        %ylim([-2,2]);
    end
    %f = figure(a);
    %s1 = scatter(c(1),c(2));
    %hold on
    %s2 = scatter([p1(1),p2(1)],[p1(2),p2(2)], 'blue');
    %hold off
    %hold on
    %line([c(1),p1(1),p2(1)],[c(2),p1(2),p2(2)]);
    %hold off
    %f.Position = [100,100,500,500];
    %xlim([-2,2]);
    %ylim([-2,2]);
    
    %{
    loopCount=0;
    if p1Sum > p2Sum
        loopCount=1;
    end
    %}
end
