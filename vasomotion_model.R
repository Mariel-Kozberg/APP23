## Linear mixed effects model for vasomotion 

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

# Subject = mouse ID number 
# FOV = field of view 
# Abeta = vascular amyloid beta coverage across field of view 
# Vasomotion_microns = max amplitude of vasomotion peak in microns 

setwd("")

dat<-read.xlsx("Vasomotion_Rinput.xlsx",1,header=TRUE) # data set input 
Vasomotion_log = log10(dat$Vasomotion_microns) 
Age_months = (dat$Age)*12/365.25 

# create a null model 
M0 = lmer(Vasomotion_log ~ 1 + (1|Subject) + (1|FOV), data=dat,REML=FALSE) 

# model with abeta 
M1 = lmer(Vasomotion_log ~ Abeta + (1|FOV) + (1|Subject), data=dat,REML=FALSE) 
summary(M1)

# model with abeta (fixed effects including uncorrelated random slope + intercept for FOV)
M1b = lmer(Vasomotion_log ~ Abeta + (Age_months||FOV) + (1|Subject), data=dat,REML=FALSE) 
summary(M1b)

# model with abeta + age 
M2 = lmer(Vasomotion_log ~ Abeta + Age_months + (1|Subject) + (1|FOV), data=dat,REML=FALSE) 
summary(M2)

# model with abeta (fixed effects including uncorrelated random slope + intercept for FOV)
M2b = lmer(Vasomotion_log ~ Abeta + Age_months + (1|Subject) + (Age_months||FOV), data=dat,REML=FALSE) 
summary(M2b)

# model with both abeta + age + genotype 
M3 = lmer(Vasomotion_log ~  Age_months + Abeta + Genotype + (1|Subject) + (1|FOV), data=dat,REML=FALSE) 
summary(M3)

# model with both abeta + age + genotype (fixed effects including uncorrelated random slope + intercept for FOV) 
# model failed to converge 
M3b = lmer(Vasomotion_log ~  Age_months + Abeta + Genotype + (1|Subject) + (Age_months||FOV), data=dat,REML=FALSE) 
summary(M3b)

# model with both abeta + age*genotype 
M4 = lmer(Vasomotion_log ~ Abeta + Age_months*Genotype + (1|Subject) + (1|FOV), data=dat,REML=FALSE) 
summary(M4)

# model with both abeta + age*genotype (fixed effects including uncorrelated random slope + intercept for FOV) 
# model with singular fit 
M4b = lmer(Vasomotion_log ~ Abeta + Age_months*Genotype + (1|Subject) + (Age_months||FOV), data=dat,REML=FALSE) 
summary(M4b)

# plot LME model

effects_vasomotion<- effects::effect(term= "Age_months*Genotype", mod= M4)
summary(effects_vasomotion) #output of what the values are
x_vaso <- as.data.frame(effects_vasomotion)
x_vaso_WT <-x_vaso[which(x_vaso$Genotype=="aWT"),]
x_vaso_Tg <-x_vaso[which(x_vaso$Genotype=="Tg"),]

vasomotion_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Vasomotion_microns,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17)) +
  geom_line(data=x_vaso_WT,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_vaso_WT, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "steelblue3") +
  geom_line(data=x_vaso_Tg,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_vaso_Tg, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "tomato3") +
  labs(x="Age (months)",y=expression(paste("Max amplitude of vasomotion peak (", mu, "m)"))) +
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = c(.99, .99),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.title=element_blank(),
        legend.text=element_text(size=18),
        legend.box.margin = margin(0, 0, 0, 0)) +
  theme(text = element_text(size = 20))
vasomotion_plot
