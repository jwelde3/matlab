% CLASS DQ_DifferentialDriveRobot
%
% This class inherits from DQ_HolonomicBase
% 
% Usage: robot = DQ_DifferentialDriveRobot(wheel_radius,distance_between_wheels), 
% where both wheel_radius and distance_between_wheels are given in meters. 
%
% For more information about the available methods, see also
% Concrete:
%       constraint_jacobian
% Concrete (Inherited from DQ_HolonomicBase):
%       base_frame
%       get_dim_configuration_space
%       fkm
%       create_new_robot (Protected)
%       pose_jacobian (overloaded)
%       plot
%       raw_fkm
%       raw_pose_jacobian
%       set_base_diameter
%       update_robot     (Protected)
% Concrete (Inherited from DQ_Kinematics):
%       set_base_frame
%       set_reference_frame
% Static (Inherited from DQ_Kinematics):
%       distance_jacobian
%       rotation_jacobian
%       translation_jacobian


% (C) Copyright 2015 DQ Robotics Developers
%
% This file is part of DQ Robotics.
%
%     DQ Robotics is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Lesser General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     DQ Robotics is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Lesser General Public License for more details.
%
%     You should have received a copy of the GNU Lesser General Public License
%     along with DQ Robotics.  If not, see <http://www.gnu.org/licenses/>.
%
% DQ Robotics website: dqrobotics.github.io
%
% Contributors to this file:
%     Bruno Vihena Adorno - adorno@ufmg.br

classdef DQ_DifferentialDriveRobot < DQ_HolonomicBase
    methods
        function obj = DQ_DifferentialDriveRobot(wheel_radius,...
                distance_between_wheels)
            obj.wheel_radius = wheel_radius;
            obj.distance_between_wheels = distance_between_wheels;
            obj.base_diameter = obj.distance_between_wheels;
        end
        
        function J = constraint_jacobian(obj,phi)
            % J = constraint_jacobian(phi) returns the Jacobian matrix that
            % satisfies [x_dot, y_dot, phi_dot]' = J*[wr,wl]', where wr and
            % wl are the angular velocities of the right and left wheels,
            % respectively.
            % phi is the robot orientation angle
            r = obj.wheel_radius;
            l = obj.distance_between_wheels;
            c = cos(phi);
            s = sin(phi);
            
            J = [(r/2)*c, (r/2)*c;
                 (r/2)*s, (r/2)*s;
                  r/l, -r/l
                ];
        end
                
        function J = pose_jacobian(obj,q)
            % J = pose_jacobian(q) returns the Jacobian matrix that
            % satisfiex vec8(h_dot) = J*[wr,wl]', where h_dot is the time
            % derivative of the unit dual quaternion that represent the
            % mobile base pose and  wr and wl are the angular velocities of the
            % right and left wheels, respectively. 
            % q = [x,y,phi] is the robot configuration
            J_holonomic = pose_jacobian@DQ_HolonomicBase(obj,q);
            J = J_holonomic*obj.constraint_jacobian(q(3));
        end
    end
    
    properties (Access = protected)
        wheel_radius;
        distance_between_wheels; 
    end
end