function trigger_waveform = extract_trigger(file_path)

FromDisk=actxserver('Perception.Loaders.PNRF');
Data=FromDisk.LoadRecording(file_path);
ItfData = Data.Recorders.Item(2).Channels.Item(1).DataSource(1);
ItfData.get;
SegmentsOfData = ItfData.Data(-200, 200);
trigger_waveform = SegmentsOfData.Item(1).Waveform(4, 1, 1e8, 1);

% find(WaveformData==max(WaveformData));
% t0=(ans(1)/1e4)-fix(ans(1)/1e4);
% trigger_waveform=(t0+(0:ceil(length(WaveformData)/1e4)))';