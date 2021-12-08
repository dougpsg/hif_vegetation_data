# High-impedance vegetation fault dataset 

This repository contains the codes that compile the ["Vegetation Conduction Ignition Test Report"](https://www.energy.vic.gov.au/__data/assets/pdf_file/0022/41719/R_D_Report_-__Marxsen_Consulting_-_Vegetation_conduction_ignition_tests_final_report_15_July_2015_DOC_15_183075_-_external_.PDF) data, which are Vegetation High-Impedance Fault tests, into a HDF5 format described in the [data set letter](https://arxiv.org/abs/2112.03651).

It is important to note that although the data set contains metadata about the tests, one should use it with the report; more data such as videos and annotations can also be found in the data website. 


The original data is public and can be founded in the [Victorian Goverment data website](https://discover.data.vic.gov.au/dataset/powerline-bushfire-safety-program-vegetation-conduction-ignition-test-report). However, the files were disclosed in the obscure ".pnrf" format, which can be challenging to explore.
This format therefore makes it more avaliable to ones interested in using it for research as it is organized, structure, and accessible through many languages (C++, Python, MATLAB), given the H5DF support. 

There is  a MATLAB live script that illustrate some dataset exploration (python notebook to be added).

The published letter describing that data set is citable in case one finds it useful - https://arxiv.org/abs/2112.03651

## Dataset structure

hif_vegetation_dataset.h5/  
├── cal/  
│   ├── 036/  
│   │   ├── current_hf  
│   │   ├── current_lf  
│   │   ├── voltage_hf  
│   │   ├── voltage_lf  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			...  
│   └── 112/  
└── test/  
&nbsp;&nbsp;    ├── 014/  
&nbsp;&nbsp;&nbsp;│   ├── current_hf  
&nbsp;&nbsp;&nbsp;│   ├── current_lf  
&nbsp;&nbsp;&nbsp;│   ├── hf_trigger  
&nbsp;&nbsp;&nbsp;│   ├── voltage_hf  
&nbsp;&nbsp;&nbsp;│   ├── voltage_lf  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				...  
&nbsp;&nbsp;      └── 999/  

Attributes of cals: 'filename', 'cal_type'  
Attributes of tests: 'filename', 'cal_type', 'max_current', 'report_validity'  
Attributes of directories 'test' and 'cals' contains a list of their respective numbers  
 
