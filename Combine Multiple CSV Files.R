
#########################################################
#     Example Code for Combining Multiple CSV Files     #
#########################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# OVERVIEW - TWO SOLUTIONS ARE INCLUDED #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# The first solution simply combines all csv files that are in a specified folder 
# The second solution all csv files that are in a specified folder and also adds a column that is populated with the original filenames
# The code can easily be recycled - simply change the working directory (i.e., setwd()) to wherever your csv files are located
# The columns can be in different orders within each csv but the columns MUST have the same names




#############################################
#     SOLUTION 1 ~ SIMPLY COMBINE FILES     #
#############################################

#~~~~~~~~~~~~~~~~~~~~~~~#
# Clear the Environment #
#~~~~~~~~~~~~~~~~~~~~~~~#
rm(list=ls())

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Set Working Directory           #
# Identify Each Filename          #
# Import All Files SIMULTANEOUSLY #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
setwd("Z:/Raw Data/SQL/Import Files/End of Course Evaluations/Qualtrics/")
filenames = list.files(pattern="*.csv")
All = do.call(rbind, lapply(filenames, function(x) read.csv(x, colClasses="character")))

#~~~~~~~~~~~~~~~~~~~~#
# Export Data as CSV #
#~~~~~~~~~~~~~~~~~~~~#
setwd("Z:/Raw Data/SQL/Import Files/End of Course Evaluations/")
write.csv(All, "EndOfCourseEval.csv",row.names = F,na="")
# NOTE: Export results to a different folder so that the combined file is not included in future imports





#########################################################
#     SOLUTION 2 ~ INCLUDE FILENAME AS FIRST COLUMN     #
#########################################################

#~~~~~~~~~~~~~~~~~~~~~~~#
# Clear the Environment #
#~~~~~~~~~~~~~~~~~~~~~~~#
rm(list=ls())

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Set Working Directory       #
# Identify Each Filename      #
# Import Each File SEPARATELY #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
setwd("Z:/Raw Data/SQL/Import Files/End of Course Evaluations/Qualtrics/")
filenames = list.files(pattern="*.csv")
for (i in 1:length(filenames)) assign(filenames[i], read.csv(filenames[i],colClasses="character"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Identify Data Frames That Were Just Imported               #
# "Stack" These Data Frames and Use Source Name for Rownames #
# Add FileNames (row names) to first column                  #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
dfs = sapply(.GlobalEnv, is.data.frame) 
All <- do.call(rbind, mget(names(dfs)[dfs]))
All <- cbind("DataSource" = sapply(strsplit(row.names(All),".csv"),'[',1) #first column - splitting rownames and taking first half
                      ,All  #all other columns
                      ,stringsAsFactors=FALSE ) #make first column regular string, not a factor
rownames(All) <- NULL # OPTIONAL: reset row names

#~~~~~~~~~~~~~~~~~~~~#
# Export Data as CSV #
#~~~~~~~~~~~~~~~~~~~~#
setwd("Z:/Raw Data/SQL/Import Files/End of Course Evaluations/")
write.csv(All, "EndOfCourseEval.csv",row.names = F,na="")
# NOTE: Export results to a different folder so that the combined file is not included in future imports





