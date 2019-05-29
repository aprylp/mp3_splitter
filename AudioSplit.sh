#!/bin/bash
# If running as a script in bash first line of script needs to be #!/bin/bash
# prior to running script, many need to run - alter path to match location of files/script
#             chmod +x /mnt/c/users/apryl/documents/acoustics/splitter
# to run script use (./ means run in current directory, script must also be in this dicrectory to run )
#             ./AudioSplit.sh

# By Apryl Perry 19 May 1
# split acoustic bubble files
# ffmpeg must be in the same directory as files being split
# -i somefile.mp3 = input file
# -hide_banner hides ffmpeg banner and details only shows media file info
# -f segment  = output file format (split file)
# -segment_time 360 is the duration of the the file in seconds 360 s = 6 min
# -c copy copies audio/video over without running through a decode -> filter -> encode process; -c is short for codec
# out%03d.mp3 is the output file format this looks like out000.mp3, out001.mp3 etc

# ffplay audio.mp3 will play an audio or video file; audio.mp3 is the name of the file you want to file(s)

# basic ffmpeg mp3 file split by segment(s)
      #     ffmpeg -i somefile.mp3 -hide_banner -f segment -segment_time 360 -c copy out%03d.mp3

# confirm correct working directory

# This is an EXAMPLE loop to only use files that end in a number, are .mp3's, and outputs them
# with the same file name, but appended with the letter M
  # for file in *[0-9].mp3;
    #   do echo $file ;
    #   target=`basename $file .mp3`M.mp3 ;
    #   cat $file | tr -s '[:blank:]' ',' > ${target};
  # done

# pwd   /mnt/c/users/apryl/documents/acoustics/splitter
# man man on command line (Ubuntu) pulls up help manual

# This loops through all the subdirectors in the current (pwd) directory and appends that directory name to each file within each subdirectory
# make sure you are in the "parent" directory of the folder where you want this to happen.
# ~ means home directory
# $ means superuser (admin priveleges)
# -d "$folder" checks to see if content(s) are directories
# cd changes to directory and assigns PRE variable for directory name
# PRE is the variable declared for the directory name followed by the directory syntax(?) ./ means only directories, not sure what # is
# then for each file in the directory mv renames files to include directory and file name
# so if directory is SalliesFen_1-4 and file is 180906 then file in directory becomes SalliesFen_1-4_180906
# script then exists subdirectory and starts over again untill all subdirectories have been looped through
# NOTE:  for file in *.mp3 portion, if returns error saying mv cannot stat '*.mp3' no such file or directory, it means that there is an empty
# subdirectory and can be ignored.  script will still run and append all files within the subdirectories regardless

  for folder in *; do
    if [ -d "$folder" ]; then
      cd "$folder"
      PRE=${folder#./}
      for file in *.mp3; do
        mv "$file" "${PRE}_$file"
      done
      cd ..
    fi
  done

# loops through and creates one chopped folder as a subdirectory within each directory, the folder name is appended with chopped_
# so split files have a folder in which to be saved to (2nd part of for loop; change $folder to {1..3} would create 3 folders whose name
# starts with whatever is specified after the mkdir command)

for folder in *; do
if [ -d "$folder" ]; then
  cd "$folder"
    for folder in $folder; do
      mkdir Chopped_"$folder"
    done
    cd ..
  fi
done

# Next...once files have been appended with their directory names, and chpped folders created they can now be split into 6 minute increments

# This loops through the directories with the files whose names have previously been appended by the above loop and uses ffmpeg to read
# all the files in the current working directory, use pwd to check and navigate to desired location
# if..then..fi if command/statment is true execute up to else statement or up to fi (if no else)
# the variable name is used to create the format desired for the split file outputs.  See top of script for documentation on the breakdown of
# commands used in the ffmpeg line.  NOTE:  ffmpeg cannot read a file and write the same filename to the same directory.  The text
# after the copy command indicates the foldername/filenames of the outputed split files.  ffmpeg in this instance is creating a new folder
# appended with Chopped_ then the entire filename which was appended with the directory name in the previous loop and sequentially numbering the
# split files ie ExistingDirectoryName_Filename_001.mp3, ExistingDirectoryName_Filename__002.mp3, etc
# It does this for every directory within the parent directory from which the script is run

for folder in *; do
if [ -d "$folder" ]; then
  cd "$folder"

   for i in *.mp3; do
      name=`echo "${i%.*}"`; #format to use in output file name
      echo $name;
      ffmpeg -i $i -hide_banner -f segment -segment_time 360 -c copy "Chopped_$folder/${name}_%03d.mp3";
    done
    cd ..
  fi
done
