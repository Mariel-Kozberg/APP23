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
setwd("/Users/marielkozberg/Library/CloudStorage/OneDrive-Personal/MKonedrive/CAAresearch/APP23_paper_forsubmission/data_sheets/")
dat<-read.xlsx("Pulsatility_Rinputs_new.xlsx",1,header=TRUE)

Pulsatility_log = log10(dat$Pulsatility) # log transform to correct for heteroskedasticity of data 
Age_months = (dat$Age)*12/365.25 

# null model 

M0 = lmer(Pulsatility_log ~ 1 + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# Model 1 
M1 = lmer(Pulsatility_log ~ Diameter  + Age_months + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# Model 1b
M1b = lmer(Pulsatility_log ~ Diameter  + Age_months + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

#Model 2 
M2 = lmer(Pulsatility_log ~ Diameter + Age_months + Genotype  + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# Model 2b
M2b = lmer(Pulsatility_log ~ Diameter  + Age_months + Genotype + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 

# Model 3
M3 = lmer(Pulsatility_log ~ Diameter + Age_months + Genotype  + Age_months*Genotype + (1|Subject) + (1|Vessel), data=dat,REML=FALSE) 

# Model 3b
M3b = lmer(Pulsatility_log ~ Diameter + Age_months + Genotype  + Age_months*Genotype + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 



# plot LME models 
effects_diampuls <- effects::effect(term= "Age_months*Genotype", mod= M3b)
summary(effects_diampuls) #output of what the values are
x_diampuls <- as.data.frame(effects_diampuls)
x_diampuls_WT <-x_diampuls[which(x_diampuls$Genotype=="aWT"),]
x_diampuls_Tg <-x_diampuls[which(x_diampuls$Genotype=="Tg"),]

diampuls_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Pulsatility_log,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17)) + 
  geom_line(data=x_diampuls_WT,aes(Age_months,fit,colour = Genotype),) +
  geom_ribbon(data= x_diampuls_WT, aes(Age_months, ymin=lower, ymax=upper), alpha= 0.3, fill = "steelblue3") +
  geom_line(data=x_diampuls_Tg,aes(Age_months,fit,colour = Genotype),) +
  geom_ribbon(data= x_diampuls_Tg, aes(Age_months, ymin=lower, ymax=upper), alpha= 0.3, fill = "tomato3") +
  labs(x="Age (months)",y=expression(paste("Log" [10]* " Pulsatility (", mu, "m*ms)"))) +
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
diampuls_plot

# plot non-log pulsatility 

diampuls_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Pulsatility,colour = Genotype,shape = Subject),size=2) + 
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17)) + 
  geom_line(data=x_diampuls_WT,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_diampuls_WT, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "steelblue3") +
  geom_line(data=x_diampuls_Tg,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_diampuls_Tg, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "tomato3") +
  labs(x="Age (months)",y=expression(paste( "Pulsatility (", mu, "m*ms)"))) +
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
diampuls_plot

diampuls_spaghettiWT <- ggplot(data=dat[which(dat$Genotype=="aWT"),], aes(x = Age*12/365.25, y = Pulsatility, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="aWT"),], aes(Age*12/365.25,Pulsatility,colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("steelblue3")) +
  scale_color_manual(values=c("steelblue3")) +
  scale_shape_manual(values=c(15,16,0,17)) + 
  labs(x="Age (months)",y=expression(paste( "Pulsatility (", mu, "m*ms)"))) + 
  ylim(0,3000)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
diampuls_spaghettiWT


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

