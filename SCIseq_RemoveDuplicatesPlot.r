args <- commandArgs(trailingOnly = TRUE)

IN<-read.table(args[1])

DEPTH<-paste(args[2], ".read_count_distribution.pdf", sep = "");
COMPL<-paste(args[2], ".complexity_distribution.pdf", sep = "");

library(ggplot2)

PLT<-ggplot(data=IN) + theme_bw() + geom_histogram(aes(log10(V4)),fill="lightcyan4",colour="gray20",size=0.25,binwidth=0.1) + xlab("log10 Unique Read Counts") + ylab("Index Counts")
ggsave(plot=PLT,filename=DEPTH,width=6,height=5)

PLT<-ggplot(data=subset(IN,V5>0&V5<=100)) + theme_bw() +
	geom_point(aes(V5,log10(V4)),colour="lightcyan4",size=1) +
	geom_density2d(aes(V5,log10(V4)),colour="gray20",size=0.3) +
	xlab("Unique Read Percentage") + ylab("Log10 Unique Read Count") +
	scale_x_continuous(limits=c(0,100)) + scale_y_continuous(limits=c(0,7))

ggsave(plot=PLT,filename=COMPL,width=6,height=5)
