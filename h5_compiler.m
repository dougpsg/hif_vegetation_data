%% H5 data set compiler
%% Get file names
work_dir="C:\VegetationData\Gen3iFiles\";

files_ = ls(work_dir);

vt_files = {};
for i=1:size(files_,1)
    if startsWith(files_(i,:),"VT")
        vt_files{end+1}=string(files_(i,:));
    end
end

%% Extract waveforms

tests_error=[];
for test_i=1:length(vt_files)
    test_number = vt_files{test_i}.extractBetween("VT",".pnrf");
    file_path = strcat(work_dir,vt_files{test_i});
    
    try
        [Voltage_LF,Current_LF,Voltage_HF,Current_HF] = extract_waveforms(file_path);
        
        h5create('test2.h5',strcat("/test/",test_number,"/voltage_hf") ...
        ,[size(Voltage_HF,1) size(Voltage_HF,2)],'Deflate',4);
        h5write('test2.h5',strcat("/test/",test_number,"/voltage_hf"),Voltage_HF);
    
        h5create('test2.h5',strcat("/test/",test_number,"/current_hf") ...
            ,[size(Current_HF,1) size(Current_HF,2)],'Deflate',4);
        h5write('test2.h5',strcat("/test/",test_number,"/current_hf"),Current_HF);
    
        h5create('test2.h5',strcat("/test/",test_number,"/current_lf") ...
            ,[size(Current_LF,1) size(Current_LF,2)],'Deflate',4);
        h5write('test2.h5',strcat("/test/",test_number,"/current_lf"),Current_LF);
    
        h5create('test2.h5',strcat("/test/",test_number,"/voltage_lf") ...
            ,[size(Voltage_LF,1) size(Voltage_LF,2)],'Deflate',4);
        h5write('test2.h5',strcat("/test/",test_number,"/voltage_lf"),Voltage_LF);
    catch
        tests_error(end+1)=test_number;
        %continue
    end
end


%% Extract triggers


for test_i=1:length(vt_files)
    test_number = vt_files{test_i}.extractBetween("VT",".pnrf");
    file_path = strcat(work_dir,vt_files{test_i});

    if all(str2num(test_number)~=tests_error)
        trigger_waveform = extract_trigger(file_path);
        h5create('test2.h5',strcat("/test/",test_number,"/hf_trigger") ...
        ,[size(trigger_waveform,1) size(trigger_waveform,2)],'Deflate',4);
        h5write('test2.h5',strcat("/test/",test_number,"/hf_trigger"),trigger_waveform);
    end
end

%% Add attributes
tests_numbers=[];
for test_i=1:length(vt_files)
    test_number = vt_files{test_i}.extractBetween("VT",".pnrf");
    file_path = strcat(work_dir,vt_files{test_i});

    if all(str2num(test_number)~=tests_error)
        h5writeatt('test2.h5',strcat("/test/",test_number), ...
            'filename',vt_files{test_i});
        if tests_info(tests_info(:,1)==str2num(test_number),2)==1
            h5writeatt('test2.h5',strcat("/test/",test_number), ...
                'fault_type','phase-to-phase');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==2
            h5writeatt('test2.h5',strcat("/test/",test_number), ...
                'fault_type','bush');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==3
            h5writeatt('test2.h5',strcat("/test/",test_number), ...
                'fault_type','phase-to-earth');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==4
            h5writeatt('test2.h5',strcat("/test/",test_number), ...
                'fault_type','grass');
        end
        max_current=fault_currents(fault_currents(:,1)==str2num(test_number),2);
        h5writeatt('test2.h5',strcat("/test/",test_number), ...
                'max_current',max_current);
    end
    tests_numbers(end+1)=test_number;
end

tests_numbers_valid=[];
for i=1:length(tests_numbers)
    if all(i~=tests_error)
        tests_numbers_valid(end+1)=i;
    end
end
h5writeatt('test2.h5',"/test/",'test_numbers',tests_numbers_valid);




%% Extract calibration

% Get file names
work_dir="C:\VegetationData\Gen3iFiles\Calibrations\";

files_ = ls(work_dir);

cal_files = {};
for i=1:size(files_,1)
    if startsWith(files_(i,:),"VT")
        cal_files{end+1}=string(files_(i,:));
    end
end

n_cal=[36 37 38 39 40 41 42 43 44 47 48 49 50 51 52 53 55 57 58 59 60 61 62 63 64 65 66 77 78 79 80 81 82 83 87 88 89 93 94 95 100 101 102 103 104 105 106 107 108 109 110 111 112];

cal_error=[];
for test_i=1:length(cal_files)
    test_number = cal_files{test_i}.extractBetween("VT_Test_site_calibration",".pnrf");
    file_path = strcat(work_dir,cal_files{test_i});
    
    if any(str2num(test_number)==n_cal)
        try
            [Voltage_LF,Current_LF,Voltage_HF,Current_HF] = extract_waveforms(file_path);
            
            h5create('test2.h5',strcat("/cal/",test_number,"/voltage_hf") ...
            ,[size(Voltage_HF,1) size(Voltage_HF,2)],'Deflate',4);
            h5write('test2.h5',strcat("/cal/",test_number,"/voltage_hf"),Voltage_HF);
        
            h5create('test2.h5',strcat("/cal/",test_number,"/current_hf") ...
                ,[size(Current_HF,1) size(Current_HF,2)],'Deflate',4);
            h5write('test2.h5',strcat("/cal/",test_number,"/current_hf"),Current_HF);
        
            h5create('test2.h5',strcat("/cal/",test_number,"/current_lf") ...
                ,[size(Current_LF,1) size(Current_LF,2)],'Deflate',4);
            h5write('test2.h5',strcat("/cal/",test_number,"/current_lf"),Current_LF);
        
            h5create('test2.h5',strcat("/cal/",test_number,"/voltage_lf") ...
                ,[size(Voltage_LF,1) size(Voltage_LF,2)],'Deflate',4);
            h5write('test2.h5',strcat("/cal/",test_number,"/voltage_lf"),Voltage_LF);
        catch
            cal_error(end+1)=test_number;
            %continue
        end
        h5writeatt('test2.h5',strcat("/cal/",test_number), ...
            'filename',cal_files{test_i});
    end
end

h5writeatt('test2.h5',"/cal/",'cal_test_numbers',n_cal);







