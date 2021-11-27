function [Voltage_LF,Current_LF,Voltage_HF,Current_HF] = extract_waveforms(file_path)

FromDisk=actxserver('Perception.Loaders.PNRF');
Data=FromDisk.LoadRecording(file_path);

for PLoop=1:4
    if PLoop==1||3
        ItfData = Data.Recorders.Item(1).Channels.Item(PLoop).DataSource(1);
        ItfData.get;
        SegmentsOfData = ItfData.Data(-200, 200);
        WaveformData = SegmentsOfData.Item(1).Waveform(4, 1, 1e8, 1);
        if PLoop==1
            Voltage_LF(:,1)=WaveformData(1,:);
        end
        if PLoop==3
            Current_LF(:,1)=WaveformData(1,:);
        end
    end

    if PLoop==2||4
        ItfData = Data.Recorders.Item(1).Channels.Item(PLoop).DataSource(2); %Locate Data
        ItfData.get; %Data info
        SegmentsOfData = ItfData.Data(-200, 200); %Select time interval of data
        if PLoop==2
            for o=1:SegmentsOfData.get.Count
                WaveformData = SegmentsOfData.Item(o).Waveform(4, 1, 1e8, 1); %Collect Data
                position=40000*(o-1);
                for p=1:40000
                    Voltage_HF(p+position,1)=WaveformData(1,p);
                end
            end
        end
        if PLoop==4
            for o=1:SegmentsOfData.get.Count
                WaveformData = SegmentsOfData.Item(o).Waveform(4, 1, 1e8, 1); %Collect Data
                position=40000*(o-1);
                for p=1:40000
                    Current_HF(p+position,1)=WaveformData(1,p);
                end
            end
        end
    end
end
