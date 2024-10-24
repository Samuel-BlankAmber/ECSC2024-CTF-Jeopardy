with open("./teams.txt", "r") as infile:
    with open("./teams_ids.txt", "w") as outfile:
        outfile.write("NOP,0\n")
        data = infile.readlines()
        for i,line in enumerate(data):
            if line.strip()!="":
                outfile.write(line.strip())
                outfile.write(",")
                outfile.write(str(i+1))
                outfile.write("\n")
