## Normalized diameter model 

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
setwd("")
dat<-read.xlsx("Diameter_Rinputs.xlsx",2,header=TRUE)
Age_months = (dat$Age)*12/365.25  

# null model 
Diameter_log = log10(dat$Diameter_norm)
M0 = lmer(Diameter_log ~ 1 + (1|Subject) + (1|Vessel), data=dat,REML=FALSE)

# model 1
M1 = lmer(Diameter_log ~ Age_months + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 
 
# model 2
M2 =  lmer(Diameter_log ~ Age_months + Genotype + (0+Age_months|Subject) + (0 + Age_months|Vessel), data=dat,REML=FALSE) 

# model 3
M3 = lmer(Diameter_log ~ Age_months + Genotype + Age_months*Genotype  + (0+Age_months|Subject) + (0+Age_months|Vessel), data=dat,REML=FALSE) 


# plot LME models 
effects_diam <- effects::effect(term= "Age_months*Genotype", mod= M3)
summary(effects_diam) #output of what the values are
x_diam <- as.data.frame(effects_diam)
x_diam_WT <-x_diam[which(x_diam$Genotype=="aWT"),]
x_diam_Tg <-x_diam[which(x_diam$Genotype=="Tg"),]

diam_plot <- ggplot() + 
  geom_point(data=dat, aes(Age_months,Diameter_norm,colour = Genotype,shape = Subject),size=3) +
  scale_color_manual(values=c("steelblue3","tomato3"), labels = c("WT","APP23 Tg")) +
  scale_shape_manual(values=c(15,16,15,16,0,0,1,17))+
  geom_line(data=x_diam_WT,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_diam_WT, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "steelblue3") +
  geom_line(data=x_diam_Tg,aes(Age_months,10^fit,colour = Genotype),) +
  geom_ribbon(data= x_diam_Tg, aes(Age_months, ymin=10^lower, ymax=10^upper), alpha= 0.3, fill = "tomato3") +
  labs(x="Age (months)",y=expression(paste("Normalized arteriolar diameter (", mu, "m/", mu,"m)")))+ 
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
diam_plot

diam_spaghettiWT <- ggplot(data=dat[which(dat$Genotype=="aWT"),], aes(x = Age*12/365.25, y = Diameter_norm, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="aWT"),], aes(Age*12/365.25,Diameter_norm,colour = Genotype,shape = Subject),size=2) + 
  geom_line(colour = c("steelblue3")) +
  scale_color_manual(values=c("steelblue3")) +
  scale_shape_manual(values=c(15,16,0,17)) + 
  labs(x="Age (months)",y="Normalized arteriolar diameter") + 
  ylim(0,2.5)+
  theme_bw() + 
  guides(shape="none")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
diam_spaghettiWT

diam_spaghettiTg <- ggplot(data=dat[which(dat$Genotype=="Tg"),], aes(x = Age*12/365.25, y = Diameter_norm, group = Vessel)) + 
  geom_point(data=dat[which(dat$Genotype=="Tg"),], aes(Age*12/365.25,Diameter_norm,colour = Genotype,shape = Subject),size=2) + 
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
diam_spaghettiTg
