# Probe Reconstruction
Image Reconstruction Techniques for Absorption Imaging Analysis

## Overview
Conventional absorption imaging involves accquiring two similar images *A* and *P*. For the image *A*, the probe is shined onto the atoms and the shadow is imaged. This image contains information about the atomic density. For the other image *P*, atoms are removed from the probe path. As a results, *P* serves as a reference. One can evaluate the optical density *OD* according to the formula
<div align="left">
<img src="https://render.githubusercontent.com/render/math?math=\text{OD} = -log \frac{A}{P}">
</div>

In the ideal case, these two images should be exactly same, except for the shadow formed by the atoms. However, in practice, no two shots are exactly same. This is caused by a multitude of reasons like probe intensity fluctuations, mechanical vibrations etc. As a result, absorption imaging when done the conventional way, results in optical densities with a background of fringes. This becomes a significant problem if the SNR is low. Below are three examples with varying SNR.

<table>
<tr>
<td> <div align="left"> Conventional Abs. Imaging </div></td>
<td><img src="/Images for Readme/ODs_Date2020-11-24_None.png" alt="Drawing" width="600"/> </td>
</tr>
</table>

One can clearly see the spurious fringes in the above images. To avoid this issue, one should recontruct a probe image <img src="https://render.githubusercontent.com/render/math?math=P_{re}"> from the atom image *A*.
<table>
<tr>
<td> <div align="center">Gram Schmidt</div> </td>
<td><img src="/Images for Readme/ODs_Date2020-11-24_GS.png" alt="Drawing" width="600"/> </td>
</tr>
<tr>
<td> <div align="center">PCA</div> </td>
<td><img src="/Images for Readme/ODs_Date2020-11-24_PCA.png" alt="Drawing" width="600"/> </td>
</tr>
</table>

## Repo Structure
- *../Test/* contains examples and sample data to play with. 
- *../Functions/* contains all functions. Make sure to you add this directory to path.
- *../Functions/PCA Functions/* contains functions used for PCA analysis. 
- *../Functions/Gram Schmidt Functions/* contains functions used for Gram Schmidt analysis. 
- *../Functions/Class Definitions/* contains class definitions for PCA and Gram Schmidt data structures 'PCAset' and 'GSset'.
- *../Functions/Common OD Evaluation/* contains OD evaluation functions.

## Installation
- Clone this repository somewhere. 
- Modify the startup code *../Test/2020/2020_11_24/StartupPR.m* as follows. 
  - Change the variable *FunctionsPath* and set it to the path to directory *../Functions/* on your local machine.
  - Change the variable *DataFolderPath* and set it to the path to directory *../Test/* on your local machine.
<table>
<tr>
<td><img src="/Images for Readme/Installation.png" alt="Drawing" width="700"/> </td>
</tr>
</table>

- Run the examples.






