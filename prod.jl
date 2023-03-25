using Pkg; Pkg.activate(".")
using Toolips
using DocAnything

IP = "127.0.0.1"
PORT = 8000
DocAnythingServer = DocAnything.start(IP, PORT)
