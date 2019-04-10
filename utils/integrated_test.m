function [fail_count, fail_log] = integrated_test()
    file = {'ax18_kinematic_control',...
            'comau_kinematic_control',...
            'wam_kinematic_control',...
            'kuka_kinematic_control', ...
            'holonomic_base_control',...
            'cdts_broom_kuka',...
            'cdts_bucket_kuka',...
            'DampedNumericalFilteredController',...
            'draw_lines_planes_using_dual_quaternions',...
            'example_dq_kinematic_control',...
            'matlab_general_operations',...
            'pose_jacobian_time_derivative'
            };

    fail_log = sprintf('This is the list of failed tests: ');
    fail_count = 0;
    for i = 1:length(file)        
        try
            close all;
            clc;
            fprintf('\n%d of %d: Executing %s', i, length(file), file{i});
            eval(file{i});
        catch
            strcat(fail_log, file{i}, ', ');
            fprintf('\n');
            warning('Could not execute file %s', file{i});
            fail_count = fail_count + 1; 
        end
    end
    clc;
    fprintf('\n Number of fails: %s', fail_count);
    fprintf('\n%s', fail_log);
end