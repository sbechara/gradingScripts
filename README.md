A repo with grading scrpts for mech 105 matlab assignments.
The idea with these is that the GradingScript.m is supposed to be generalized. Its main purpose is to look in a directory full of assignment files, loop over all of them, correct the canvas file names to the assignemnt file name, and handle data output. So in theory the only things that need changed in it are the location to look in and assingment file name, and the grading file to use.

Files of the type homeworkGrader.m will need to be used to actually assign test and assign a grade for a given homework. These can assume that it is only testing one file with the correct function name, and need to return a score and a string of notes about grading.

As far as I know, this only work on matlab 2017 and beyond

For help with this, contact:
Nate Overton, noverton@rams.colostate.edu