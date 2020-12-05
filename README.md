# Probe Reconstruction
Image Reconstruction Techniques for Absorption Imaging Analysis

<table>
<tr>
<td> Conventional Abs. Imaging </td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_None.png" alt="Drawing" width="300"/> </td>
</tr>
<tr>
<td> Gram Schmidt </td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_GS.png" alt="Drawing" width="300"/> </td>
</tr>
<tr>
<td> PCA </td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_PCA.png" alt="Drawing" width="300"/> </td>
</tr>
</table>

## Overview:
- */Probe-Reconstruction/* contains all functions. Make sure to you add this directory to path.
- */Probe-Reconstruction/PCA Functions/* contains functions used for PCA analysis. 
- */Probe-Reconstruction/Gram Schmidt Functions/* contains functions used for Gram Schmidt analysis. 
- *Probe-Reconstruction/Class Definitions/* contains class definitions for PCA and Gram Schmidt data structures 'PCAset' and 'GSset'
- Rest of the functions in */Probe-Reconstruction/* are required to analyze the data at
- */Probe-Reconstruction/Test/* contains all the examples to run

## Installation
Clone this repository somewhere. 
Copy the examples and startup code */Probe-Reconstruction/Test/StartupPR.m* into your Data folder. The data should be of the format as in here. Else you'll have to modify some of the functions. 

## Usage
In StartupPR.m* define the varaibles 'Functions' and 'DataFolder' as paths to */Probe-Reconstruction/* and your data folder respectively.
Run the example codes.




