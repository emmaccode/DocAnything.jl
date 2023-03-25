using Pkg; Pkg.activate(".")
using Toolips
using Revise
using DocAnything

IP = "127.0.0.1"
PORT = 8000
DocAnythingServer = DocAnything.start(IP, PORT)
