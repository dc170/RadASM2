if exist %4 del %4
fbc -c %2 %3
fbc -dll -l kernel32 -l gdi32 -l user32 -x %1 %4 %3
