@echo off
tremor.exe intro.dat /v0 
cls
stonet.exe
tremor.exe outro.dat /v0 /d200
cls
type over.dat