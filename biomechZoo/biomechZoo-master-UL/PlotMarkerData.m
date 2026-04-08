
for i = 1:length(forearmDyn(:,1))
   
    A=forearmDyn(i,1:2);
    B=forearmDyn(i,4:5);
    C=forearmDyn(i,7:8);
    u = A-B;
    v = C-B;
  

   phi_trans(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );

   clear A B C u v


    A=forearmDyn(i,2:3);
    B=forearmDyn(i,5:6);
    C=forearmDyn(i,8:9);
    u = A-B;
    v = C-B;
  

   phi_front(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );

   clear A B C u v


    A=forearmDyn(i,[1 3]);
    B=forearmDyn(i,[4 6]);
    C=forearmDyn(i,[7 9]);
    u = A-B;
    v = C-B;
  

   phi_sag(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );
  
   clear A B C u v
end



%%
    ELB = upperarmDyn(:,7:9);
    FRM = forearmDyn(:,4:6);
    UPA = upperarmDyn(:,4:6);

    figure;
    subplot(3,1,1)
    hold on; plot(UPA(:,1), UPA(:,2), 'o'); plot(ELB(:,1), ELB(:,1), 'o'); plot(FRM(:,1), FRM(:,2), 'o'); legend ('UPA', 'ELB', 'FRM')
    xlabel('X'); ylabel('Y'); title('Transverse')

    subplot(3,1,2)
    hold on; plot(UPA(:,2), UPA(:,3), 'o'); plot(ELB(:,2), ELB(:,3), 'o'); plot(FRM(:,2), FRM(:,3), 'o'); legend ('UPA', 'ELB', 'FRM')
    xlabel('Y'); ylabel('Z'); title('Frontal')

    subplot(3,1,3)
    hold on; plot(UPA(:,1), UPA(:,3), 'o'); plot(ELB(:,1), ELB(:,3), 'o'); plot(FRM(:,1), FRM(:,3), 'o'); legend ('UPA', 'ELB', 'FRM')
    xlabel('X'); ylabel('Z'); title('Sagittal')
   

    
for i = 1:length(forearmDyn(:,1))
   
    A=UPA(i,1:2);
    B=ELB(i,1:2);
    C=FRM(i,1:2);
    u = A-B;
    v = C-B;
   

   phi_trans(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );

   clear A B C u v


    A=UPA(i,2:3);
    B=ELB(i,2:3);
    C=FRM(i,2:3);
    u = A-B;
    v = C-B;
  

   phi_front(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );

   clear A B C u v


    A=UPA(i,[1 3]);
    B=ELB(i,[1 3]);
    C=FRM(i,[1 3]);
    u = A-B;
    v = C-B;
  

   phi_sag(i,1)=acosd( dot(u,v) / (sqrt(sum(u.^2)) * sqrt(sum(v.^2))) );
  
   clear A B C u v
end

figure;
hold on; plot(phi_trans); plot(phi_sag); plot(phi_front);
legend('Transverse', 'Sagittal', 'Frontal')
ylim([0 180])
set(gca, 'FontSize', 14); ylabel('Degrees'); xlabel('Frame')
