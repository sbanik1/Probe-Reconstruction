# Probe Reconstruction
Image Reconstruction Techniques for Absorption Imaging Analysis

## Overview
Conventional absorption imaging involves accquiring two similar images *A* and *P* with the camera. For one of the images *A*, the probe is shined onto the atoms and the shadow is imaged. This image *A* has has the information about atomic density. The other image *P* is taken by removing the atoms from its path. Thus forming a reference. One can evaluate the optical density *OD* according to the formula
<div align="left">
<img src="https://render.githubusercontent.com/render/math?math=\text{OD} = -log \frac{A}{P}">
</div>

In the ideal case, these two images should be exactly same, except for the shadow formed by the atoms. However, in practice, no two shots are exactly same. This is caused by a multitude of reasons like probe intensity fluctuations, mechanical vibrations etc. As a result, absorption imaging when done the conventional way, results in optical densities with a background of fringes. This becomes a significant problem if the SNR is low. Below are three examples.

<table>
<tr>
<td> <div align="left"> Conventional Abs. Imaging </div></td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_None.png" alt="Drawing" width="300"/> </td>
</tr>
</table>

One can clearly see the spurious fringes in the above images. To avoid this issue, one should recontruct a probe image <img src="https://render.githubusercontent.com/render/math?math=P_{re}"> from the atom image *A*.
<table>
<tr>
<td> <div align="center">Gram Schmidt</div> </td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_GS.png" alt="Drawing" width="300"/> </td>
</tr>
<tr>
<td> <div align="center">PCA</div> </td>
<td><img src="/Test/OD_Images/ODs_Date2020-11-24_PCA.png" alt="Drawing" width="300"/> </td>
</tr>
</table>

## File Organization
- */Probe-Reconstruction/* contains all functions. Make sure to you add this directory to path.
- */Probe-Reconstruction/PCA Functions/* contains functions used for PCA analysis. 
- */Probe-Reconstruction/Gram Schmidt Functions/* contains functions used for Gram Schmidt analysis. 
- *Probe-Reconstruction/Class Definitions/* contains class definitions for PCA and Gram Schmidt data structures 'PCAset' and 'GSset'.
- Rest of the functions in */Probe-Reconstruction/* are required to analyze the data avialable at <>
- */Probe-Reconstruction/Test/* contains all the examples to run.

## Installation
Clone this repository somewhere. 
Copy the examples and startup code */Probe-Reconstruction/Test/StartupPR.m* into your Data folder. The images should be of the format as that data available at <>. Else you'll have to modify some of the functions. 

## Usage
In StartupPR.m* define the varaibles 'Functions' and 'DataFolder' as paths to */Probe-Reconstruction/* and your data folder respectively.
Run the example codes.




