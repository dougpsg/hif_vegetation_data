# High-impedance vegetation fault dataset 

This repository contains the codes that compile the "Vegetation Conduction Ignition Test Report" data, which are Vegetation High-Impedance Fault tests, into a HDF5 format.

There is also a MATLAB live script that illustrate some dataset exploration (python notebook to be added). 

The original data is public and can be founded in the [Victorian Goverment data website](https://discover.data.vic.gov.au/dataset/powerline-bushfire-safety-program-vegetation-conduction-ignition-test-report). However, the files were disclosed in the obscure ".pnrf" format, which can be challenging to explore.

## Dataset structure

hif_vegetation_dataset.h5/  
├── cal/  
│   ├── 036/  
│   │   ├── current_hf  
│   │   ├── current_lf  
│   │   ├── voltage_hf  
│   │   ├── voltage_lf  
			...  
│   └── 999/  
└── test/  
      ├── 014/  
      │   ├── current_hf  
      │   ├── current_lf  
      │   ├── hf_trigger  
      │   ├── voltage_hf  
      │   ├── voltage_lf  
				...  
      └── 999/  

Attributes of cals: 'filename', 'cal_type'
Attributes of tests: 'filename', 'cal_type', 'max_current', 'report_validity'
Attributes of directories 'test' and 'cals' contains a list of their respective numbers
 
