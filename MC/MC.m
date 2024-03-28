set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',20)
set(0,'defaultaxesfontname','Calibry')
set(0,'DefaultLineLineWidth',2);

F = 1;
m = 1;

x = 0;
v = 0;
t = 0;

dt = 1;
nt = 1000;
v = zeros(1,1);
x = zeros(1,1);


re = 0;

for i = 2:nt
    t(i) = t(i-1)+dt;

    v(:,i) = v(:,i-1) + F/m*dt;
    x(:,i) = x(:,i-1) + 0.5*F/m*dt^2;


    r = rand(1,1) < 0.05
    v(r,i) = re*v(r,i);
    AveV(i,:) = mean(v,2);




    subplot(3,1,1);
    plot(t,v,'-');
    hold on
    subplot(3,1,1);
    plot(t,AveV(i),'r*');
    hold off
    xlabel('time')
    ylabel('v')
    title(['Average v: ' num2str(AveV(i))])

    subplot(3,1,2);
    plot(x(1,:),v(1,:),'b-');
    hold on
    subplot(3,1,2);
    plot(x(1,:),AveV(i),'r*');
    hold off
    xlabel('x')
    ylabel('v')

    subplot(3,1,3);
    plot(t,x);
    xlabel('time')
    ylabel('x')

    pause(0.01)
end
