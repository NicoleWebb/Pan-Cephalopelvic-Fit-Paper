# Pan Cephalopelvic Fit Assesment

This repository contains the code to showcase the various analyses executed in a study currently under consideration for publication. 

Usage Notes:

-The purpose of this repository is primarily for reproducibility and to show interested third parties the details of the conducted analyses and their associated visualizations. The analyses are standard 3D GM analyses using common code assocaited with morphometric packages in R (see below).

-Some of the R and MATLAB scripts may occasionally contain references to .ply and .csvs files that are too large to conveniently share within this respository; however, they will happily be made available if a formal request is sent to nicole.webb@senckenberg.de (the same applies to raw image data etc.)


R code relevant citations: 

Package: Geomorph

  Baken E, Collyer M, Kaliontzopoulou A, Adams D (2021). “geomorph v4.0
  and gmShiny: enhanced analytics and a new graphical interface for a
  comprehensive morphometric experience.” _Methods in Ecology and
  Evolution_, *12*, 2355-2363.

  Adams D, Collyer M, Kaliontzopoulou A, Baken E (2024). “Geomorph:
  Software for geometric morphometric analyses. R package version
  4.0.7.” <https://cran.r-project.org/package=geomorph>.

Package: Morpho

  Schlager S (2017). “Morpho and Rvcg - Shape Analysis in R.” In Zheng
  G, Li S, Szekely G (eds.), _Statistical Shape and Deformation
  Analysis_, 217-256. Academic Press. ISBN 9780128104934.

Matlab code info:

The script for calculating the distances between the mean fetal head and maternal pelvic meshes is a simple loop that takes all linear distances and then calculates a mean based on a user specified percentage. There is an option to change the "granularity" which means you can reduce the sampling of the distances used in order to shorten computation time. The original .csv files were quite large because of their resolution which is why they will have to be independently requested from the authors to successfully run the provided script. However, the authors are happy to share all data and to support those interested in replicating the analyses.




