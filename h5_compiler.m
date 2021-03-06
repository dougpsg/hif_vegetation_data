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
        
        h5create('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/voltage_hf") ...
        ,[size(Voltage_HF,1) size(Voltage_HF,2)],'Deflate',4);
        h5write('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/voltage_hf"),Voltage_HF);
    
        h5create('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/current_hf") ...
            ,[size(Current_HF,1) size(Current_HF,2)]);
        h5write('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/current_hf"),Current_HF);
    
        h5create('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/current_lf") ...
            ,[size(Current_LF,1) size(Current_LF,2)]);
        h5write('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/current_lf"),Current_LF);
    
        h5create('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/voltage_lf") ...
            ,[size(Voltage_LF,1) size(Voltage_LF,2)]);
        h5write('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/voltage_lf"),Voltage_LF);
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
        h5create('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/hf_trigger") ...
        ,[size(trigger_waveform,1) size(trigger_waveform,2)]);
        h5write('hif_vegetation_dataset.h5',strcat("/test/",test_number,"/hf_trigger"),trigger_waveform);
    end
end

%% Add attributes
tests_numbers=[];
invalid_tests_from_report=[536;537;538;539;540;541;542;543;544;545;546;547;548;549;550;551;552;553;554;555;556;557;558;559;560;561;562;563;564;916;917;918;919;1;2;3;565;566;567;568;569;570;571;572;573;574;575;576;577;578;579;580;581;582;583;4;5;6;7;8;9;10;11;12;13;584;14;15;585;16;586;587;38;971;972;973;974;400;401;668;669;670;672;674;676;678;483;484;778;795;796;797;825;834;835;863];
for test_i=1:length(vt_files)
    test_number = vt_files{test_i}.extractBetween("VT",".pnrf");
    file_path = strcat(work_dir,vt_files{test_i});

    if all(str2num(test_number)~=tests_error)
        h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
            'filename',vt_files{test_i});
        if tests_info(tests_info(:,1)==str2num(test_number),2)==1
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                'fault_type','phase-to-phase');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==2
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                'fault_type','bush');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==3
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                'fault_type','phase-to-earth');
        elseif tests_info(tests_info(:,1)==str2num(test_number),2)==4
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                'fault_type','grass');
        end
        max_current=fault_currents(fault_currents(:,1)==str2num(test_number),2);
        h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                'max_current',max_current);
        if any(str2num(test_number)==invalid_tests_from_report)
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                    'report_validity','invalid');       
        else
            h5writeatt('hif_vegetation_dataset.h5',strcat("/test/",test_number), ...
                    'report_validity','valid');    
        end
    end
    tests_numbers(end+1)=test_number;
end

tests_numbers_valid=[];
for i=1:length(tests_numbers)
    if all(i~=tests_error)
        tests_numbers_valid(end+1)=i;
    end
end
h5writeatt('hif_vegetation_dataset.h5',"/test/",'test_numbers',tests_numbers_valid);


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
%Cals after number 94 are phase-to-phase 
cal_error=[];
for test_i=1:length(cal_files)
    test_number = cal_files{test_i}.extractBetween("VT_Test_site_calibration",".pnrf");
    file_path = strcat(work_dir,cal_files{test_i});
    
    if any(str2num(test_number)==n_cal)
        try
            [Voltage_LF,Current_LF,Voltage_HF,Current_HF] = extract_waveforms(file_path);
            
            h5create('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/voltage_hf") ...
            ,[size(Voltage_HF,1) size(Voltage_HF,2)]);
            h5write('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/voltage_hf"),Voltage_HF);
        
            h5create('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/current_hf") ...
                ,[size(Current_HF,1) size(Current_HF,2)]);
            h5write('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/current_hf"),Current_HF);
        
            h5create('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/current_lf") ...
                ,[size(Current_LF,1) size(Current_LF,2)]);
            h5write('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/current_lf"),Current_LF);
        
            h5create('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/voltage_lf") ...
                ,[size(Voltage_LF,1) size(Voltage_LF,2)]);
            h5write('hif_vegetation_dataset.h5',strcat("/cal/",test_number,"/voltage_lf"),Voltage_LF);
        catch
            cal_error(end+1)=test_number;
            %continue
        end
        h5writeatt('hif_vegetation_dataset.h5',strcat("/cal/",test_number), ...
            'filename',cal_files{test_i});
        if str2num(test_number)>94 
            h5writeatt('hif_vegetation_dataset.h5',strcat("/cal/",test_number), ...
                'cal_type','phase-to-phase');
        else
            h5writeatt('hif_vegetation_dataset.h5',strcat("/cal/",test_number), ...
                'cal_type','phase-to-earth');
        end
    end
end

h5writeatt('hif_vegetation_dataset.h5',"/cal/",'cal_test_numbers',n_cal);




