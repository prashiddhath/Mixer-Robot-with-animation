clear all
close all
clf
handle_axes= axes('XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.4]);

xlabel('e_1'); 
ylabel('e_2');
zlabel('e_3');

view(-130, 26);
grid on;
axis equal;
camlight
axis_length= 0.05;


%% Root frame E
trf_E_axes= hgtransform('Parent', handle_axes); 
% The root-link transform should be created as a child of the axes from the
% beginning to avoid the error "Cannot set property to a deleted object".
% E is synonymous with the axes, so there is no need for plot_axes(trf_E_axes, 'E');

%% Link-0: Base-link

trf_link0_E= make_transform([0, 0, 0], 0, 0, pi/2, trf_E_axes);
plot_axes(trf_link0_E, 'L_0', false, axis_length); 

trf_viz_link0= make_transform([0, 0, 0.1], 0, 0, 0, trf_link0_E);
length0= 0.2; radius0= 0.05;
h(1)= link_cylinder(radius0, length0, trf_viz_link0, [0.823529 0.411765 0.117647]); 
plot_axes(trf_viz_link0, ' ', true, axis_length); % V_0

%% Link-1
trf_viz_link1= make_transform([0, 0, 0.10], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
length1= 0.3; radius1= 0.02;
h(2)= link_cylinder(radius1, length1, trf_viz_link1, [0, 0, 1]); 
% V_1 and L_1 are the same.

%% Link-1_2
trf_viz_link1p2= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(4)= link_cylinder(0.035, 0.05, trf_viz_link1p2, [0, 0, 1]); 
plot_axes(trf_viz_link1p2, ' ', true, axis_length); % V_{1-3}

%% Link-1_3
trf_viz_link1p3= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(3)= link_box([0.25, 0.02, 0.04], trf_viz_link1p3, [0, 0, 1]); 
plot_axes(trf_viz_link1p3, ' ', true, axis_length); % V_{1-2}

%% Link-2
trf_viz_link2= make_transform([0, 0, 0], 0, pi/2, 0); % Do not specify parent yet: It will be done in the joint
h(5)= link_box([0.2, 0.02, 0.04], trf_viz_link2, [0, 0, 1]);
% V_2 and L_2 are the same.

%% Link 2-1
trf_viz_link2p1= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(6)= link_cylinder(0.025, 0.05, trf_viz_link2p1, [1, 0.54902, 0]); 
plot_axes(trf_viz_link2p1, ' ', true, axis_length); % V_{2-2}

%% Link-3
trf_viz_link3= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(7)= link_cylinder(0.012, 0.03, trf_viz_link3, [0.196078, 0.803922, 0.196078]); 
plot_axes(trf_viz_link3, ' ', true, axis_length); % V_3

%% Link-3-1
trf_viz_link3p1= make_transform([0, 0, 0], pi/2, 0, pi/2); % Do not specify parent yet: It will be done in the joint
h(8)= link_cylinder(0.012, 0.05, trf_viz_link3p1, [0.196078, 0.803922, 0.196078]); 
plot_axes(trf_viz_link3p1, ' ', true, axis_length); % V_{3-2}

%% Link-4-1
trf_viz_link4p1= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(9)= link_cylinder(0.005, 0.05, trf_viz_link4p1, [0.482353 0.407843 0.933333]); 
plot_axes(trf_viz_link4p1, ' ', true, axis_length); % V_{4}

%% Link-4-2
trf_viz_link4p2= make_transform([0, 0, 0], 0, 0, 0); % Do not specify parent yet: It will be done in the joint
h(10)= link_cylinder(0.005, 0.05, trf_viz_link4p2, [0.482353 0.407843 0.933333]); 
plot_axes(trf_viz_link4p2, ' ', true, axis_length); % V_{4}
 
%% Now define all the joints

%% Joint 1: Links 0,1: Prismatic
 j1_translation_axis_j1= [0,0,1]';
 j1_translation= 0; % [-0.04, 0.04]
 
 trf_joint1_link1= make_transform([0, 0, 0.20], 0, 0, 0, trf_link0_E); 
 trf_link1_joint1= make_transform_prismatic(j1_translation_axis_j1, j1_translation, trf_joint1_link1);
 plot_axes(trf_link1_joint1, 'L_1', false, axis_length); 
 make_child(trf_link1_joint1, trf_viz_link1);

%% Joint 2: Links 1,1_2: Revolute
 j2_rot_axis_j2= [0,0,1]';
 j2_rot_angle= 0; % [-pi/2, pi/2]

 trf_joint2_link0= make_transform([0, 0, 0.275], 0, 0, 0, trf_link1_joint1); 
 trf_link1_joint2= make_transform_revolute(j2_rot_axis_j2, j2_rot_angle, trf_joint2_link0); 
 plot_axes(trf_link1_joint2, 'L_2', false, axis_length); 
 make_child(trf_link1_joint2, trf_viz_link1p2);
 
%% Joint: Links 1,1_3: Fixed
trf_link1p3_link1= make_transform([0.09+0.035, 0, 0], 0, 0, 0, trf_link1_joint2); 
make_child(trf_link1p3_link1, trf_viz_link1p3);

%% Joint: Links 1_3,2: Fixed
trf_link2_link1p3 = make_transform([0.105, 0, -0.12], 0, 0, 0, trf_link1p3_link1);
make_child(trf_link2_link1p3, trf_viz_link2);

%% Joint: Links 2,2_1: Fixed
 trf_link2p2_link2= make_transform([0, 0, -0.125], 0, 0, 0, trf_link2_link1p3); 
 make_child(trf_link2p2_link2, trf_viz_link2p1);

%% Joint 3: Links 2_1,3: Revolute
 j3_rot_axis_j3= [0,0,1]';
 j3_rot_angle= 0; % [-pi/2, pi/2]
 
 trf_joint3_link2= make_transform([0.23, 0, -0.285], 0, 0, 0, trf_link1_joint2);
 trf_link3_joint3= make_transform_revolute(j3_rot_axis_j3, j3_rot_angle, trf_joint3_link2); 
 plot_axes(trf_link3_joint3, 'L_3', false, axis_length); 
 make_child(trf_link3_joint3, trf_viz_link3);

%% Joint: Links 3,3_1: Fixed
 trf_link3p2_link3= make_transform([0, 0, -0.025], 0, 0, 0, trf_link3_joint3); 
 make_child(trf_link3p2_link3, trf_viz_link3p1);

%% Joint: Links 3_1,4_1: Fixed
 trf_link4p1_link3= make_transform([-0.015, 0, -0.03], 0, 0, 0, trf_link3p2_link3); 
 make_child(trf_link4p1_link3, trf_viz_link4p1);
 
%% Joint: Link 3_1,4_2: Fixed
 trf_link4p2_link3= make_transform([0.015, 0, -0.03], 0, 0, 0, trf_link3p2_link3); 
 make_child(trf_link4p2_link3, trf_viz_link4p2);

%% Animation: One joint at a time
for q1=[linspace(0, -pi/2, 30), linspace(-pi/2, pi/2, 30), linspace(pi/2, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
    trf_q1= makehgtform('axisrotate', j2_rot_axis_j2, q1);
    set(trf_link1_joint2, 'Matrix', trf_q1);
    drawnow;
    pause(0.02);
end


for q3=[linspace(0, -pi/2, 30), linspace(-pi/2, pi/2, 30), linspace(pi/2, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
    trf_q3= makehgtform('axisrotate', j3_rot_axis_j3, q3);
    set(trf_link3_joint3, 'Matrix', trf_q3);
    drawnow;
end

for a4=[linspace(0, -0.04, 30), linspace(-0.04, 0.04, 30), linspace(0.04, 0, 30)]
    set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
    trf_a4= makehgtform('translate',  j1_translation_axis_j1*a4);
    set( trf_link1_joint1, 'Matrix', trf_a4);
    drawnow;
    pause(0.02);
end

%% Animation: All joints together.
q_init= 0.5*ones(4,1); % This leads to all joints being at 0.

for i= 1:20
    q_next= rand(4,1); 
    % rand() gives uniformly distributed random numbers in the interval [0,1]
    
    for t=0:0.02:1
        q= q_init + t*(q_next - q_init);
        q1= (pi/2)*(2*q(1) - 1);
        q2= (pi/2)*(2*q(2) - 1);
        q3= (pi/2)*(2*q(3) - 1);
        a4= (0.04)*(2*q(4) - 1);
        
        set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
        trf_q1= makehgtform('axisrotate', j2_rot_axis_j2, q1);
        set(trf_link1_joint2, 'Matrix', trf_q1);
        
        set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
        trf_q3= makehgtform('axisrotate', j3_rot_axis_j3, q3);
        set(trf_link3_joint3, 'Matrix', trf_q3);
        
        set(handle_axes, 'XLim', [-0.4,0.4], 'YLim', [-0.2,0.4], 'ZLim', [0,0.7]);
        trf_a4= makehgtform('translate', j1_translation_axis_j1*a4);
        set(trf_link1_joint1, 'Matrix', trf_a4);
        drawnow;
        pause(0.005);
        
    end
    
    q_init= q_next;
    
end
