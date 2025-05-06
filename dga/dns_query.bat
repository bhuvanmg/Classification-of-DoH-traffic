@echo off
:loop
call "C:\Users\BHUVAN M G\miniconda3\Scripts\activate.bat" dga
python dns_query.py
timeout /t 5
goto loop
