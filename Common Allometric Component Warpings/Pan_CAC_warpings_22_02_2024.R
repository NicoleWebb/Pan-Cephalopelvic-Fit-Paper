

#Analysis (FULL DATA =29)
External<-read.morphologika("Morphologika_sacralized_pelvis_EXT_FULL.txt")
Y.gpa<-gpagen(External$coords)
plot(Y.gpa)
meanspec<-findMeanSpec(External$coords)
print(meanspec)

Internal<-read.morphologika("Morphologika_sacralized_pelvis_INT_FULL.txt")
Y.gpa<-gpagen(Internal$coords)
plot(Y.gpa)
meanspec<-findMeanSpec(Internal$coords)
print(meanspec)

all.lm <- combine.subsets(External = External$coords,Internal = Internal$coords, gpa = FALSE, CS.sets = NULL)#make sure to do GPA

plotAllSpecimens((all.lm$coords))

library(Morpho)
Y.gpaINT<-gpagen(Internal$coords)
Y.gpaEXT<-gpagen(External$coords)
INT2D<-two.d.array(Y.gpaINT$coords)
EXT2D<-two.d.array(Y.gpaEXT$coords)


#female only 2-block
SEXINT<-coords.subset(Internal$coords, Internal$label)# group original file by sex
SEXEXT<-coords.subset(External$coords, External$label)

FcoordsInternal<-SEXINT$F#isolate females
FcoordsExternal<-SEXEXT$F

#establish mesh for warpings to CAC
mesh<- read.ply("Pan_troglodytes_0000496_F_AIMZ_pelvis.ply")

#CAC females only
all.females.lm <- combine.subsets(FcoordsExternal,FcoordsInternal, gpa = FALSE, CS.sets = NULL)#all male landmarks compiled no GPA
females<-two.d.array(all.females.lm$coords)
females_final<-arrayspecs(females,90,3)
proc <- procSym(females_final)
FY.gpa<-gpagen(females_final)
plot(FY.gpa)
summary(FY.gpa)
F_cac <- CAC(FY.gpa$coords,FY.gpa$Csize)
plot(F_cac$CACscores,F_cac$size)
cor.test(F_cac$CACscores,F_cac$size)
F_large <- showPC(max(F_cac$CACscores),F_cac$CAC,proc$mshape)
F_small <- showPC(min(F_cac$CACscores),F_cac$CAC,proc$mshape)
deformGrid3d(F_small,F_large,ngrid=0)
plotRefToTarget(F_large, F_small, method=c("TPS"), mag=1)


Warp_SizeF_small<-tps3d(mesh,proc$mshape,F_small)
Warp_SizeF_large<-tps3d(mesh,proc$mshape,F_large)
shade3d(Warp_SizeF_large, col=12)
shade3d(Warp_SizeF_small, col=13)