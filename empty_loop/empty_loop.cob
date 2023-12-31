       IDENTIFICATION DIVISION.
       PROGRAM-ID. EMPLOOP.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. PC-I686.
       OBJECT-COMPUTER. PC-I686.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.
       77  CUR-ITER                 PIC 9(10).

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
         MOVE ZERO TO CUR-ITER.
         PERFORM 200-EMPTY-LOOP
           VARYING CUR-ITER FROM 1 BY 1 UNTIL CUR-ITER > 2000000000.
         STOP RUN.

       200-EMPTY-LOOP.
         DISPLAY CUR-ITER.

       END PROGRAM EMPLOOP.
