function createfigure(zdata1)
%CREATEFIGURE(zdata1)
%  ZDATA1:  surface zdata

%  Auto-generated by MATLAB on 18-Jul-2021 19:06:29

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create surf
surf(zdata1,'Parent',axes1,'EdgeColor','none');

% Create zlabel
zlabel('Loop Count');

% Create ylabel
ylabel('Ang1e 2 Index');

% Create xlabel
xlabel('Ang1e 1 Index');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 2000]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 2000]);
grid(axes1,'on');
hold(axes1,'off');
