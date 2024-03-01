set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',20)
set(0,'defaultaxesfontname','Times New Roman')
set(0,'DefaultLineLineWidth',2);

nx=50;
ny=50;
V=zeros(nx,ny);
G=sparse(nx*ny,nx*ny);

Inclusion=0;

for i=1:nx
    for j=1:ny
        n=j+(i-1)*ny; % mapping line
        % Set the diagonal value for boundary nodes to 1
        if i == 1 || i == nx || j == 1 || j == ny
            G(n, n) = 1;
        else
            if i>10 & i<20 & j>10 & j<20
                G(n,n)=-2;
                % Update neighboring elements
                nxm = j + (i-2) * ny; % (i-1, j)
            nxp = j + (i) * ny;     % (i+1, j)
            nym = (j - 1) + (i-1) * ny; % (i, j-1)
            nyp = (j + 1) + (i-1) * ny; % (i, j+1)

            G(n, nxm) = 1;
            G(n, nxp) = 1;
            G(n, nym) = 1;
            G(n, nyp) = 1;
            else
            % Finite difference equation for the bulk nodes
            G(n, n) = -4;
            nxm = j + (i-2) * ny; % (i-1, j)
            nxp = j + (i) * ny;     % (i+1, j)
            nym = (j - 1) + (i-1) * ny; % (i, j-1)
            nyp = (j + 1) + (i-1) * ny; % (i, j+1)

            % Update neighboring elements
            G(n, nxm) = 1;
            G(n, nxp) = 1;
            G(n, nym) = 1;
            G(n, nyp) = 1;
            end
        end
    end
end


    figure
    figure('name','Matrix');
    spy(G)

    nmodes=20;
    [E,D]=eigs(G,nmodes,'SM');
    figure('name','Eigenvalues')
    plot(diag(D),'*');

    np = ceil(sqrt(nmodes))
    figure('name','Modes')
    for k=1:nmodes
        M=E(:,k);
        for i=1:nx
            for j=1:ny
                n=i+(j-1)*nx;
                V(i,j)=M(n);
            end
            subplot(np,np,k), surf(V,'linestyle','none')
            title(['EV=' num2str(D(k,k))])
        end
    end
