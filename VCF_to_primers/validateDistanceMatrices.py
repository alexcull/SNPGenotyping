#!/usr/bin/env python
"""
\033[1mDESCRIPTION\033[0m
    Data frame / matrix parser.

    Returns information on which samples have a value of 0.0,
    i.e. no difference in SNP genotypes (null genetic distance).

    Returns the info in an output file, tab-delimited.

\033[1mUSAGE\033[0m
    $program <in_file> <out_file>

\033[1mCREDITS\033[0m
    Satan 2020 \m/
"""
import sys

try:
    in_file = sys.argv[1]
    out_file = sys.argv[2]
except:
    print (__doc__)
    sys.exit(666)

c = 0 # Integer object to store line counts
num_sp = 0 # Integer object to store number of samples (i.e. number of columns)
sp_id = {} # Dict() that will contain column numbers with their respective sample ID

# Opening the input file and parsing each line
## We also simultaniously open the output file to create it
## as we go from line to line in the input file.
with open(in_file, "r") as i_f:
    with open(out_file, "w") as o_f:
        for line in i_f:
            line = line.strip() # Standard: deleting unecessary characters in the line
            
            # First line in input file = "header" with all the sample IDs
            if c == 0:
                
                t_num = 0 # Temporary number to fill in the 'sp_id' dict()
                
                # Keeping track of the number of samples in the dataframe
                num_sp += len(line.split())
                
                # Filling in the dict() that stores column number with their respective
                # sample ID.
                while t_num < num_sp:
                    
                    # Filling in the dict() with this logic:
                    # key = column number
                    # value = sample ID
                    sp_id[t_num] = line.split()[t_num]
                    
                    t_num += 1 # Adding 1 to the column number we are currently dealing with
                
            # If the count object > 0, it means we are dealing with a row in the dataframe
            elif c > 0:
                
                sp = line.split()[0] # First element of the row = sample ID, here called 'sp'
                
                # Temporary object to store current sample number
                # This number = species-specific column index, as stored in 'sp_id' dict()
                sp_num = 0 
                while sp_num < num_sp:
                    
                    # Placing the value in the current cell of the dataframe in a floating
                    # numerical object, i.e. decimal value.
                    d = float(line.split()[1:][sp_num])
                    
                    # If the value equals 0 (that's what we want)
                    if d == 0.0:
                        
                        sp_col = sp_id[sp_num]
                        
                        # If the two sample IDs are different, then we keep that info
                        # and write it down in output file:
                        if sp != sp_col:
                            
                            # Writing to output file
                            o_f.write("Strains " + str(sp) \
                                + " and " + str(sp_col) \
                                + " could not be differentiated" + "\n")
                    
                    # Adding 1 to the current sample number, i.e. column number
                    sp_num += 1

            # Adding 1 to the line count
            c += 1

print ("\n\033[1mTask completed\033[0m\n")    

## Check out the author's other work @https://github.com/fohebert