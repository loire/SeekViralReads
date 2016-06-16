# -*- coding: utf-8 -*-
import sys
from os.path import exists
basename=sys.argv[1]
fileout = open(sys.argv[1]+"_report.md",'w')

# Start filling context dic to map values into template
context = {}
context["basename"]=basename

# First part Cutadapt1
# parse log
if exists("log_cutadapt_1_"+sys.argv[1]):
    with open("log_cutadapt_1_"+sys.argv[1],'r') as cut1f:
        for line in cut1f:
            if "Command line parameters" in line:
                c =line.split(":")
                context["CutAdaptCMD1"]="cutadapt "+c[1]
                continue
            if "Total read pairs processed" in line:
                c = line.split(":")
                context["CutA_1_total"]=c[1]
                continue
            if "Read 1 with adapter" in line:
                c = line.split(":")
                context["CutA_1_R1_adap"] = c[1]
                continue
            if "Read 2 with adapter" in line:
                c=line.split(":")
                context["CutA_1_R2_adap"] = c[1]
            if "Pairs written (passing" in line:
                c=line.split(":")
                context["CutA_1_written"] = c[1]
                continue
            if "Total basepairs processed" in line:
                line = cut1f.next()
                c = line.split(":")
                context["CutA_1_LR1"] = c[1]
                line = cut1f.next()
                c = line.split(":")
                context["CutA_1_LR2"] = c[1]
                line = cut1f.next()
                c = line.split(":")
                context["CutA_1_LF"] = c[1]
                line = cut1f.next()
                c = line.split(":")
                context["CutA_1_LR1A"] = c[1]
                line = cut1f.next()
                c = line.split(":")
                context["CutA_1_LR2A"] = c[1]
                break
else:
    print "Error, file log_cutadapt_1_"+sys.argv[1]+" do not exit in current dir"
    sys.exit()

#Cutadapt2
# parse log 
if exists("log_cutadapt_1_"+sys.argv[1]):
    with open("log_cutadapt_2_"+sys.argv[1],'r') as cut2f:
        for line in cut2f:
            if "Command line parameters" in line:
                c =line.split(":")
                context["CutAdaptCMD2"]="cutadapt "+c[1]
                continue
            if "Total read pairs processed" in line:
                c = line.split(":")
                context["CutA_2_total"]=c[1]
                continue
            if "Read 1 with adapter" in line:
                c = line.split(":")
                context["CutA_2_R1_adap"] = c[1]
                continue
            if "Read 2 with adapter" in line:
                c=line.split(":")
                context["CutA_2_R2_adap"] = c[1]
            if "Pairs written (passing" in line:
                c=line.split(":")
                context["CutA_2_written"] = c[1]
                continue
            if "Total basepairs processed" in line:
                line = cut2f.next()
                c = line.split(":")
                context["CutA_2_LR1"] = c[1]
                line = cut2f.next()
                c = line.split(":")
                context["CutA_2_LR2"] = c[1]
                line = cut2f.next()
                line = cut2f.next()
                line = cut2f.next()
                line = cut2f.next()
                c = line.split(":")
                context["CutA_2_LF"] = c[1]
                line = cut2f.next()
                c = line.split(":")
                context["CutA_2_LR1A"] = c[1]
                line = cut2f.next()
                c = line.split(":")
                context["CutA_2_LR2A"] = c[1]
                break
else:
    print "Error, file log_cutadapt_2_"+sys.argv[1]+" do not exit in current dir"
    sys.exit()

if exists("log_bwa_"+sys.argv[1]):
    with open("log_bwa_"+sys.argv[1],"r") as bwaf:
        for line in bwaf:
            if "CMD" in line:
                c = line.split(":")
                context["bwaCMD"]=c[1]
else:
    print "Error, file log_bwa"+sys.argv[1]+" do not exit in current dir"
    sys.exit()

if exists("Stats_mapping_contaminent_"+sys.argv[1]+".txt"):
    with open("Stats_mapping_contaminent_"+sys.argv[1]+".txt") as samf:
        for line in samf:
            if "properly paired" in line:
                c = line.split("+")
                context["bwaMapped"] = str(int(c[0])/2)
                d = c[1].split("(")
                e = d[1].split()
                context["bwaMappedpc"] = e[0]
                continue
            if "paired in sequencing" in line:
                c = line.split("+")
                context["bwaInputReads"] = str(int(c[0])/2)
                continue
            if "with mate mapped to a different" in line:
                c = line.split("+")
                context["bwaSingle"]= c[0]
                continue
    context["bwaOutput"]=str(int(context["bwaInputReads"])-(int(context["bwaMapped"])+int(context["bwaSingle"])))

else:
    print "Stats_mapping_contaminent"+sys.argv[1]+".txt do not exit in current dir"
    sys.exit()




for key in context.keys():
    context[key] = context[key].replace("\n","").strip()




template = """ 
# SeekViralReads results for sample **_"{basename}"_** 

---

## Adapters removal by cutadapt 

### command line:

```bash 
{CutAdaptCMD1}
```
### Results summary

| variable | value |
| --- | --- |
| Total read pairs processsed | {CutA_1_total} | 
| R1 with adapters |{CutA_1_R1_adap}| 
| R2 with adapters | {CutA_1_R2_adap} | 
| R1 total length before | {CutA_1_LR1} | 
| R1 total length after | {CutA_1_LR1A} | 
| R2 total length before | {CutA_1_LR2}  | 
| R2 total length after | {CutA_1_LR2A} |
| Total length of filtered sequences (R1+R2) | {CutA_1_LF} |
| Reads pairs written | {CutA_1_written} | 

## Quality trimming by cutadapt 

### command line:

```bash 
{CutAdaptCMD2}
```

### Results summary:

| variable | value |
| --- | --- |
| Total reads pairs processsed | {CutA_2_total} |
| R1 with adapters | {CutA_2_R1_adap} |
| R2 with adapters | {CutA_2_R2_adap} |
| R1 total length before | {CutA_2_LR1} |
| R1 total length after | {CutA_2_LR1A} |
| R2 total length before | {CutA_2_LR2}  |
| R2 total length after | {CutA_2_LR2A} |
| Total length of quality trimmed sequences | {CutA_2_LF} |
| Reads pairs written | {CutA_2_written} |

## Mapping on contaminent sequences

```bash
{bwaCMD}
```

### Stats

| variable | value |
| --- | --- |
| Reads input   | {bwaInputReads} |
| Properly Mapped | {bwaMapped}  |
| Properly Mapped % | {bwaMappedpc} |
| Mapped with mate to a different chrom  | {bwaSingle}   |
| Output reads | {bwaOutput}   |
"""
fileout.write(template.format(**context))


