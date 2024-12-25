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
#setwd("/Volumes/mgkdata/APP23/analysis/Pulsatility_Overall")
setwd("/Users/marielkozberg/Library/CloudStorage/OneDrive-Personal/MKonedrive/CAAresearch/APP23_paper_forsubmission/data_sheets/")
dat<-read.xlsx("Pulsatility_Rinputs_new.xlsx",1,header=TRUE)
Pulsatility_log = log10(as.numeric(dat$Amplitude_corrected)) # log transform to correct for heteroskedasticity of data 
Pulsatility2 = as.numeric(dat$Amplitude_corrected)
Age_months = (dat$Age)*12/365.25 

# null model 
M0 = lmer(Pulsatility_log ~ 1 + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# model 1
M1 = lmer(Pulsatility_log ~  Age_months + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# model 1b
M1b = lmer(Pulsatility_log ~  Age_months + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# model 2
M2 = lmer(Pulsatility_log ~  Age_months + Genotype  + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# model 2b
M2b = lmer(Pulsatility_log ~  Age_months + Genotype  + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# model 3 
M3 = lmer(Pulsatility_log ~  Age_months + Genotype  + Age_months*Genotype + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# model 3b 
M3b = lmer(Pulsatility_log ~  Age_months + Genotype  + Age_months*Genotype + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# plot LME models 
effects_pulsatility <- effects::effect(term= "Age_months", mod= M1b)
summary(effects_pulsatility) #output of what the values are
x_pulsatility <- as.data.frame(effects_pulsatility)


pulsatility_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Pulsatility_log,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17)) +
  geom_line(data=x_pulsatility,aes(Age_months,fit),) +
  geom_ribbon(data= x_pulsatility, aes(Age_months, ymin=lower, ymax=upper), alpha= 0.3, fill = "gray45") +
  labs(x="Age (months)",y=expression(paste("Log" [10]* " Max amplitude of pulsatility peak (", mu, "m)"))) +
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
  theme(text = element_text(size = 18)) +
ylim(-2, -0.5)
pulsatility_plot

# plot non-log data 

pulsatility_plot2 <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Pulsatility2,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17)) +
  geom_line(data=x_pulsatility,aes(Age_months,10^fit),) +
  geom_ribbon(data= x_pulsatility, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "gray45") +
  labs(x="Age (months)",y=expression(paste("Max amplitude of pulsatility peak (", mu, "m)"))) +
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
  theme(text = element_text(size = 18))
pulsatility_plot2

pulsatility_spaghettiWT <- ggplot(data=dat[which(dat$Genotype=="aWT"),], aes(x = Age*12/365.25, y = Pulsatility2, group = Vessel)) + 
 geom_point(data=dat[which(dat$Genotype=="aWT"),], aes(Age*12/365.25,dat$Amplitude_corrected,colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("steelblue3")) +
  scale_color_manual(values=c("steelblue3")) +
  scale_shape_manual(values=c(15,16,0,17)) + 
  labs(x="Age (months)",y=expression(paste("Max amplitude of pulsatility peak (", mu, "m)"))) + 
 # ylim(0,3000)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
pulsatility_spaghettiWT


diampuls_spaghettiTg <- ggplot(data=dat[which(dat$Genotype=="Tg"),], aes(x = Age*12/365.25, y = Pulsatility, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="Tg"),], aes(Age*12/365.25,Pulsatility,colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("tomato3")) +
  scale_color_manual(values=c("tomato3")) +
  scale_shape_manual(values=c(15,16,0,1)) + 
  labs(x="Age (months)",y=expression(paste( "Pulsatility (", mu, "m*ms)"))) + 
  ylim(0,3000)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
diampuls_spaghettiTg




