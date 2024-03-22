
##Import file PC_scores_GPA_all
data(PC_scores_GPA_all_NW)
PC1<- PCscores1 <- PC_scores_GPA_all_NW[,1]
PC2 <- PCscores2 <- PC_scores_GPA_all_NW[,2]
PC3 <- PCscores3 <- PC_scores_GPA_all_NW[,3]

lbl<-c("",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"M",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"","","F")

library(rgl)
library(geometry)

plot3d(PC1, PC2, PC3, col=c(rep("seashell4",14),rep("gold3",17)), box = FALSE,
   type ="s", radius = 0.002, axis.scales = FALSE, grid=FALSE)
text3d(x=PC1, y=PC2,z=PC3,texts=lbl, col=1)

ps1 <- matrix(c(PC1[1:14],PC2[1:14],PC3[1:14]), ncol=3)  # generate points on a sphere
ts.surf1 <- t(convhulln(ps1))  # see the qhull documentations for the options

convex1 <-  triangles3d(ps1[ts.surf1,1],ps1[ts.surf1,2],ps1[ts.surf1,3],col="seashell4",alpha=.3)

ps2 <- matrix(c(PC1[15:31],PC2[15:31],PC3[15:31]), ncol=3)  # generate points on a sphere
ts.surf2 <- t(convhulln(ps2))  # see the qhull documentations for the options

convex2 <-  triangles3d(ps2[ts.surf2,1],ps2[ts.surf2,2],ps2[ts.surf2,3],col="gold3",alpha=.3)


rgl.snapshot(filename = "PCA_updated_Pan2_2024.png")
