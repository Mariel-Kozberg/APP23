# normalized velocity

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

# for diameter: 
#setwd("/Volumes/mgkdata/APP23/analysis/Velocity_Overall")
setwd("/Users/marielkozberg/Library/CloudStorage/OneDrive-Personal/MKonedrive/CAAresearch/APP23_paper_forsubmission/data_sheets/")
dat<-read.xlsx("Velocity_Rinput2.xlsx",2,header=TRUE)
Age_months = (dat$Age)*12/365.25 

# null model 
Velocity_log = log10(dat$Velocity_norm)
M0 = lmer(Velocity_log ~ 1 + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# model 1 
M1 = lmer(Velocity_log ~ Age_months + (0+ Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# model 2  
M2 = lmer(Velocity_log ~ Age_months + Genotype + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# model 3  
M3 = lmer(Velocity_log ~ Age_months + Genotype + Age_months*Genotype + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# plot LME models 
effects_velocity <- effects::effect(term="Age_months", mod= M1)
summary(effects_velocity) #output of what the values are
x_velocity <- as.data.frame(effects_velocity)

velocity_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Velocity_norm,colour = Genotype,shape = Subject),size=3) +
  scale_color_manual(values=c("steelblue3","tomato3"),labels=c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17))+
  geom_line(data=x_velocity,aes(Age_months,10^fit)) +
  geom_ribbon(data= x_velocity, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "gray45") +
  labs(x="Age (months)",y=expression(paste("Normalized arteriolar RBC velocity (", mu, "m/s/", mu,"m/s)")))+ 
  theme(text = element_text(size = 24)) +
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
  theme(text = element_text(size = 22))
velocity_plot

velocity_spaghettiWT <- ggplot(data=dat[which(dat$Genotype=="aWT"),], aes(x = Age*12/365.25, y = Velocity_norm, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="aWT"),], aes(Age*12/365.25,Velocity_norm,colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("steelblue3")) +
  scale_color_manual(values=c("steelblue3")) +
  scale_shape_manual(values=c(15,16,0,17,1)) + 
  labs(x="Age (months)",y="Normalized arteriolar velocity") + 
 # ylim(0,2.5)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
       # legend.position = "none"
       legend.position = c(.99, .99),
       legend.justification = c("right", "top"),
       legend.box.just = "right",
       legend.title=element_blank(),
       legend.text=element_text(size=18),
       legend.box.margin = margin(0, 0, 0, 0))
velocity_spaghettiWT

velocity_spaghettiTg <- ggplot(data=dat[which(dat$Genotype=="Tg"),], aes(x = Age*12/365.25, y = Velocity_norm, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="Tg"),], aes(Age*12/365.25,Velocity_norm,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("tomato3")) +
  scale_shape_manual(values=c(15,16,0,1)) +
  geom_line(colour = c("tomato3")) +
  labs(x="Age (months)",y="Normalized arteriolar diameter") + 
  ylim(0,2.5)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
velocity_spaghettiTg
