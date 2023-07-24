       IDENTIFICATION DIVISION.
        PROGRAM-ID. test3.
        AUTHOR. Pralinor.
       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        INPUT-OUTPUT SECTION.
         FILE-CONTROL.
           SELECT Fichier assign to 'FE'.

        DATA DIVISION.
         FILE SECTION.
          FD fichier.
           01  fichier-ENR pic x(80).

        WORKING-STORAGE SECTION.
           01  R-Fic-enr.
               05  struct1  pic x(40).
               05  filler   pic x.
               05  struct2  pic x(39).


       PROCEDURE DIVISION.
       Debut.
           open input fichier.
       lecture.
           read fichier into r-fic-enr
                  at end go to fin.
           display r-fic-enr.
           go to lecture.
       fin.
           close fichier.
           stop run.
