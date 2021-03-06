# Fist target is the default target
# $@ == target
# $^ == dependancies of the rule
# create a wildcard variable
#

# make bash default
SHELL=/bin/bash

include config.mk

# reads file names

#PATH_TO_READS_FILE="coucou"
FASTQ_R1_FILES=$(wildcard $(PATH_TO_READS_FILE)/*R1.fastq)
FASTQ_R2_FILES=$(wildcard $(PATH_TO_READS_FILE)/*R2.fastq)

all : variables index load outdir cutadpat

# Phony target, no target created but use @echo (and not echo to avoir printing the command)  and the TXT_FILES variables to print all matching patterns
## variables: print variables 
.PHONY : variables
variables :
		@echo R1 files: $(FASTQ_R1_FILES) ; 
		@echo R2 files: $(FASTQ_R2_FILES) ; 
		@echo HOST REF: $(PATH_TO_HOST_SEQS) ; 
		@echo test:  $(PATH_TO_HOST_SEQS).bwt 
## Load modules
.PHONY : load
load: 	
		module load compiler/gcc/4.9.2  
## index reference 

index : $(PATH_TO_HOST_SEQS).bwt

$(PATH_TO_HOST_SEQS).bwt : $(PATH_TO_HOST_SEQS)
		bwa index $<


.PHONY : outdir
outdir: 
	mkdir -p $(baseoutdir)


cutadapt : clean_$(FASTQ_R1_FILES) clean_$(FASTQ_R2_FILES)


clean_$(FASTQ_R1_FILES) clean_$(FASTQ_R2_FILES) : $(FASTQ_R1_FILES) $(FASTQ_R2_FILES)
		@echo "coucou"

#
#
#
#
#
#TXT_FILES=$(wildcard books/*.txt)
#DAT_FILES=$(patsubst books/%.txt, %.dat, $(TXT_FILES))
#PLOT_FILES=$(patsubst %.dat, %.png, $(DAT_FILES))
#
## program names variables
##
#COUNT_SRC=wordcount.py
#COUNT_EXE=python $(COUNT_SRC)
#
#ZIP_SRC=zipf_test.py
#ZIP_EXE=python $(ZIP_SRC)
#
#PLOT_SRC=plotcount.py
#PLOT_EXE=python $(PLOT_SRC)
#
#
## All variables can be contained in config file
## include a file that contain variable definition (src and exe)
##include config.mk
#
#.PHONY : all
#all : $(PLOT_FILES) results.txt
#
#
### results.txt : Generate zipf summary table
#results.txt: $(DAT_FILES)  $(ZIP_SRC)
#	$(ZIP_EXE) *.dat  > $@
#
#
### pngs: Generate png files from dat files 
#.PHONY : pngs
#pngs : $(PLOT_FILES)
#
#%.png : $(DAT_FILES) $(PLOT_SRC)
#		$(PLOT_EXE) $< $*.png
#
#
### dats : Generates wordcount of text files
#.PHONY : dats
#dats : $(DAT_FILES)
##count words.
#%.dat : books/%.txt $(COUNT_SRC)
#		$(COUNT_EXE) $< $*.dat
#
#
#
##
### Phony target, no target created but use @echo (and not echo to avoir printing the command)  and the TXT_FILES variables to print all matching patterns
#### variables: print variables 
##.PHONY : variables
##variables :
##		@echo TXT_FILES: $(TXT_FILES)
##		@echo DAT_FILES: $(DAT_FILES)
##		@echo PLOT_FILES: $(PLOT_FILES)
##
#.PHONY : help
#help: Makefile
#		@sed -n 's/^##//p' $<
#
##
##isles.dat : books/isles.txt wordcount.py
##	        python wordcount.py $< $@
##abyss.dat : books/abyss.txt wordcount.py
##	        python wordcount.py $< $@
##last.dat : books/last.txt wordcount.py
##	        python wordcount.py $< $@
## A phony target permit to execute a rule without a target. clean is not a target, it's the container of a  rule
### clean : clean autogenerated files
#.PHONY: clean
#clean :
#	        rm -f $(DAT_FILES) $(PLOT_FILES)  results.txt
#
#
