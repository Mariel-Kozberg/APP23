# Abeta model
#Load packages 
library(tidyverse) #for all data wrangling
library(cowplot) #for manuscript ready figures
library(lme4) #for lmer & glmer models
library(sjPlot) #for plotting lmer and glmer mods
library(sjmisc) 
library(effects)
library(sjstats) #use for r2 functions
library(car); library(ggplot2); library(nlme); library(reshape); library(ggeffects)
library(lme4); library(jtools); library(lmerTest); 
library("xlsx")
library("ggplot2")

# load data 
rm(list=ls())
setwd("")
dat<-read.xlsx("Abeta_density.xlsx",1,header=TRUE)
Age_months = (dat$Age)*12/365.25 

# null model 
M0 = lmer(Abeta ~ 1 + (1|Subject) + (1|FOV), data=dat,REML=FALSE) 

# model with age (including random slope + intercept) -- singular fit 
M1s = lmer(Abeta ~ Age_months + (1|Subject) + (Age_months||FOV), data=dat, REML=FALSE)
summary(M1s)

# model with age (including random slope + intercept) -- singular fit 
M1s2 = lmer(Abeta ~ Age_months + (Age_months||FOV), data=dat, REML=FALSE)
summary(M1s2)

# model with age (random intercept)
M1 = lmer(Abeta ~ Age_months + (1|Subject) + (1|FOV), data=dat, REML=FALSE)
summary(M1)

# model with age (random slope)
M1b = lmer(Abeta ~ Age_months + (0+Age_months|Subject) + (0 + Age_months|FOV), data=dat, REML=FALSE)
summary(M1b)



# plot LME models 
effects_abeta <- effects::effect(term= "Age_months", mod= M2)
summary(effects_abeta) #output of what the values are
x_abeta <- as.data.frame(effects_abeta)

abeta_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Abeta,shape = Subject),color="tomato3",size=3) + 
  scale_shape_manual(values=c(15,16,0,1))+
  geom_line(data=x_abeta,aes(Age_months,fit),color="tomato3") + 
  geom_ribbon(data= x_abeta, aes(Age_months, ymin=lower, ymax=upper), alpha= 0.3, fill = "tomato3") +
 labs(x="Age (months)",y=expression(paste(" Vascular amyloid-",beta," coverage (%)"))) + 
  theme_bw() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  theme(text = element_text(size = 22))+
  theme(legend.position = "none")
abeta_plot

abeta_spaghetti <- ggplot(data=dat[which(dat$Genotype=="Tg"),], aes(x = Age*12/365.25, y = Abeta, group = FOV)) + 
geom_point(data=dat[which(dat$Genotype=="Tg"),], aes(Age*12/365.25,Abeta,colour = Genotype,shape = Subject),size=2) + 
scale_color_manual(values=c("tomato3")) +
scale_shape_manual(values=c(15,16,0,1)) +
geom_line(colour = c("tomato3")) +
labs(x="Age (months)",y=expression(paste(" Vascular amyloid-",beta," coverage (%)"))) + 
# ylim(0,1.25)+
theme_bw() + 
guides(shape="none")+
theme(panel.grid.major = element_blank(), 
panel.grid.minor = element_blank(),
legend.position = "none")
abeta_spaghetti
