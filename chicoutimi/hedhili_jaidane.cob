0002   IDENTIFICATION DIVISION.
0003  ******************************************************************
0004  *                                                                *
0005  * CALCUL MOYENNE PAR PERSONNE
0006  *                                                                *
0007  ******************************************************************
0008   PROGRAM-ID. MOYENNE.
0009   AUTHOR. H. JAIDANE.
0010   ENVIRONMENT DIVISION.
0011   CONFIGURATION SECTION.
0012   SOURCE-COMPUTER. IBM-AS400.
0013   OBJECT-COMPUTER. IBM-AS400.
0014   SPECIAL-NAMES. DECIMAL-POINT IS COMMA.
0018   INPUT-OUTPUT SECTION.
0019   FILE-CONTROL.
0020       SELECT FICHIER ASSIGN DISK-FICHIER
                  ORGANIZATION SEQUENTIAL.
0020       SELECT TRI ASSIGN DISK-TRI.
       DATA DIVISION.
0049   FILE SECTION.
0051   FD  FICHIER.
0052   01  FICHIER-RD.
           03 NOM       PIC X(10).
           03 FILLER    PIC X.
           03 DEPENSE   PIC 999V99.
           03 FILLER    PIC X.
           03 DATEX     PIC X(8).
0051   SD  TRI.
0052   01  TRI-RD.
           03 NOM       PIC X(10).
           03 FILLER    PIC X.
           03 DEPENSE   PIC 999V99.
           03 FILLER    PIC X.
           03 DATEX     PIC X(8).
0054  *
0078   WORKING-STORAGE SECTION.
       77  WTOT-P         PIC 9(5)V99 COMP-3.
       77  WTOT-G         PIC 9(5)V99 COMP-3.
       77  WNBR-P         PIC 9(5) COMP-3.
       77  WNBR-G         PIC 9(5) COMP-3.
       77  WNOM           PIC X(10).
       77  WTOT           PIC Z(4)9,99.
       77  WMOY           PIC Z(4)9,99.
       77  WNBR           PIC Z(4)9.
       01  FIN-FICHIER PIC X.
           88 EOF   VALUE 1.
0078   LINKAGE SECTION.
0242   PROCEDURE DIVISION.
0245   TRAITEMENT SECTION.
       TRAIT-TRI.
           SORT TRI ON ASCENDING KEY NOM OF TRI-RD
                INPUT PROCEDURE  ENTREE
                OUTPUT PROCEDURE SORTIE.
           STOP RUN.
       ENTREE SECTION.
       ENTR1.
           OPEN INPUT FICHIER.
           MOVE 0 TO FIN-FICHIER.
           PERFORM LECT-FICHIER UNTIL EOF.
           CLOSE FICHIER.
       ENTREE-DIVERS SECTION.
       LECT-FICHIER.
           READ FICHIER AT END MOVE 1 TO FIN-FICHIER.
           IF NOT EOF PERFORM ECRIT-TRI.
       ECRIT-TRI.
           RELEASE TRI-RD FROM FICHIER-RD.
       SORTIE SECTION.
0248   DEBUT.
           MOVE 0 TO FIN-FICHIER.
           MOVE 0 TO WTOT-G WNBR-G.
           MOVE LOW-VALUE TO WNOM.
           PERFORM TRAIT-FICHIER-TRI UNTIL EOF.
           IF WNOM = LOW-VALUE DISPLAY "FICHIER VIDE"
           ELSE PERFORM FIN-TRAIT.
       SORTIE-DIVERS SECTION.
       TRAIT-FICHIER-TRI.
           RETURN TRI AT END MOVE 1 TO FIN-FICHIER.
           IF NOT EOF
              PERFORM TRAIT-NOM
           ELSE PERFORM FIN-NOM.
       TRAIT-NOM.
           IF NOM OF TRI-RD NOT = WNOM
              IF WNOM NOT = LOW-VALUE
                 PERFORM FIN-NOM
                 PERFORM DEBUT-NOM
              ELSE PERFORM DEBUT-NOM
           ELSE PERFORM CUMUL-NOM.
       CUMUL-NOM.
           ADD 1 TO WNBR-P.
           ADD DEPENSE OF TRI-RD TO WTOT-P.
       DEBUT-NOM.
           MOVE NOM OF TRI-RD TO WNOM.
           MOVE 1 TO WNBR-P.
           MOVE DEPENSE OF TRI-RD TO WTOT-P.
       FIN-NOM.
           ADD WNBR-P TO WNBR-G.
           ADD WTOT-P TO WTOT-G.
           DIVIDE WTOT-P BY WNBR-P GIVING WMOY ROUNDED.
           MOVE WNBR-P TO WNBR.
           MOVE WTOT-P TO WTOT.
           DISPLAY "NOM.... = " WNOM.
           DISPLAY "TOTAL.. = " WTOT.
           DISPLAY "NOMBRE. = " WNBR.
           DISPLAY "MOYENNE = " WMOY.
           DISPLAY "--------------------".
       FIN-TRAIT.
           DIVIDE WTOT-G BY WNBR-G GIVING WMOY ROUNDED.
           MOVE WNBR-G TO WNBR.
           MOVE WTOT-G TO WTOT.
           DISPLAY "********************".
           DISPLAY "GENERAL = ".
           DISPLAY "TOTAL.. = " WTOT.
           DISPLAY "NOMBRE. = " WNBR.
           DISPLAY "MOYENNE = " WMOY.
