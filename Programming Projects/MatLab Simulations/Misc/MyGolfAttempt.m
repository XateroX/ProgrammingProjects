clear;
clc;
close all;

a = 1;

points = rand(300,300);
dupPoints = points;
disp(points);

points(90:110,90:110) = 0.75;
points(1:100,10:40) = 0.75;
points(120:200,110:130) = 0.75;


ballPos = [100,100];
ballVel = [rand(1),rand(1)];


i = 0;
while i < 10
    i=i+1;
    for j = 1:size(points)
        for k = 1:size(points)
            numSummedPoints = 1;
            dupPointFloating = points(j,k);
            if j > 1
                dupPointFloating = dupPointFloating + points(j-1,k);
                numSummedPoints = numSummedPoints + 1;
            end
            if j < size(points)
                dupPointFloating = dupPointFloating + points(j+1,k);
                numSummedPoints = numSummedPoints + 1;
            end
            if k > 1
                dupPointFloating = dupPointFloating + points(j,k-1);
                numSummedPoints = numSummedPoints + 1;
            end
            if k < size(points)
                dupPointFloating = dupPointFloating + points(j,k+1);
                numSummedPoints = numSummedPoints + 1;
            end
            dupPoints(j,k) = dupPointFloating/numSummedPoints;
        end
    end
    points = dupPoints;
    if mod(i,1) == 0
        f = figure(a);
        f.Position = [0,0,1500,1000];
        s = surf(points);
        s.EdgeColor = 'none';
        zlim([0,1]);
    end
end
i = 0;
while i < 150
    i=i+1;
    view([-45,-45,180]);
    f = figure(a);
    f.Position = [0,0,1500,1000];
    s = surf(points);
    s.EdgeColor = 'none';
    zlim([0,2]);
    hold on
    
    [Fx,Fy] = gradient(points);
    xadj = -3*Fx(round(ballPos(1)),round(ballPos(2)));
    yadj = -3*Fy(round(ballPos(1)),round(ballPos(2)));
    ballVel(1)=ballVel(1)+xadj;
    ballVel(2)=ballVel(2)+yadj;
    ballPos(1)=ballPos(1)+ballVel(1);
    ballPos(2)=ballPos(2)+ballVel(2);
    
    if round(ballPos(1)) > 200
        ballPos(1)=200;
        ballVel(1)=-ballVel(1);
    end
    if round(ballPos(2)) > 200
        ballPos(2)=200;
        ballVel(2)=-ballVel(1);
    end
    if round(ballPos(1)) < 0
        ballPos(1)=0;
        ballVel(1)=-ballVel(1);
    end
    if round(ballPos(2)) < 0
        ballPos(2)=0;
        ballVel(2)=-ballVel(1);
    end
    
    scatter3(round(ballPos(1)),round(ballPos(2)),0.1+points(round(ballPos(1)),round(ballPos(2))), 250, 'white','filled');
    disp(round(ballPos(1)));
    disp(round(ballPos(2)));
    hold off
end















