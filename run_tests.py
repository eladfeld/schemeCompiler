import os
import sys
import termios

def color_gen():
    while True:
        print("\033[38;5;11m",end="\n") #yellow
        sys.stdout.flush()
        yield
        print("\033[0m",end="\n")   #white
        sys.stdout.flush()
        yield


if __name__ == "__main__":    
    color = color_gen()
    os.system("mkdir -p results")
    files = os.listdir('.')
    files.sort()
    for file in files:
        if (file.endswith(".scm")):
            print(file,end=":\n")
            sys.stdout.flush()
            fname = file[:-4]    #without .scm
            os.system(f"make -f ./schemeCompiler/Makefile {fname} ;o1=`scheme -q < {fname}.scm` ;o2=`./{fname}` ; echo \"(equal? '($o1) '($o2))\" > ./results/{fname}_results.scm; scheme -q < ./results/{fname}_results.scm")
            os.system(f"rm ./schemeCompiler/{fname}.o ")
            os.system(f"rm ./schemeCompiler/{fname}.s ")
            os.system(f"rm ./{fname} ")
            next(color)
        

    