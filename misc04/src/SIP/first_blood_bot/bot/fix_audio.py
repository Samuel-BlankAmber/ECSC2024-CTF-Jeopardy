import os
import sys

filename = ".".join(sys.argv[1].split(".")[:-1])

os.system(f"ffmpeg -i {filename}.wav -acodec pcm_u8 -ar 8000 -ac 1 {filename}_fixed.wav")