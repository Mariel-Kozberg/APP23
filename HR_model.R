## Diameter pulsatility LME model 

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


#Define data sheet 
rm(list=ls())

# for pulsatility_d: 
setwd("")
dat<-read.xlsx("Pulsatility_Rinputs.xlsx",2,header=TRUE)
Age_months <- (dat$Age)*12/365.25 

# create a null model 
HR <-as.numeric(dat$Hrate)
M0 = lmer(HR ~ 1 + (1|Subject) , data=dat,REML=FALSE) 

# model with age (note, HR should not differ based on vessel. Therefore, vessel is not included in the model as a random effect.)
M1 = lmer(HR ~  Age_months + (Age_months||Subject) , data=dat,REML=FALSE) 

# model with age + genotyoe 
M2 = lmer(HR ~  Age_months + Genotype  + (Age_months||Subject) , data=dat,REML=FALSE) 

# model with all + interaction  
M3 = lmer(HR ~ Age_months + Genotype  + Age_months*Genotype + (Age_months||Subject), data=dat,REML=FALSE) 

# plot LME models 
effects_HR <- effects::effect(term= "Age_months", mod= M1)
summary(effects_HR) #output of what the values are
x_HR <- as.data.frame(effects_HR)

HR_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,HR,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,17,17,8,8)) +
  geom_line(data=x_HR,aes(Age_months,fit)) +
  geom_ribbon(data= x_HR, aes(Age_months, ymin=lower, ymax=upper), alpha= 0.3, fill = "gray45") +
  labs(x="Age (months)",y=expression(paste("Heart rate (bpm)"))) +
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
  ylim(0,1000)+
  theme(text = element_text(size = 18))
HR_plot


HR_spaghettiWT<-ggplot(data=dat[which(dat$Genotype=="aWT"),], aes(x = Age*12/365.25, y = as.numeric(Hrate), group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="aWT"),], aes(Age*12/365.25,as.numeric(Hrate),colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("steelblue3")) +
  scale_color_manual(values=c("steelblue3")) +
  scale_shape_manual(values=c(15,16,0,17)) + 
  labs(x="Age (months)",y=expression(paste("Heart rate (bpm)"))) + 
  ylim(0,1000) + 
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
HR_spaghettiWT

HR_spaghettiTg<-ggplot(data=dat[which(dat$Genotype=="Tg"),], aes(x = Age*12/365.25, y = as.numeric(Hrate), group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="Tg"),], aes(Age*12/365.25,as.numeric(Hrate),colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("tomato3")) +
  scale_color_manual(values=c("tomato3")) +
  scale_shape_manual(values=c(15,16,0,1)) + 
  labs(x="Age (months)",y=expression(paste("Heart rate (bpm)"))) + 
  ylim(0,1000)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
HR_spaghettiTg
