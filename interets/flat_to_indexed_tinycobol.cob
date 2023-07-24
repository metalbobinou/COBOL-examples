       IDENTIFICATION DIVISION.
       PROGRAM-ID. REORG.


       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. PC-I686.
       OBJECT-COMPUTER. PC-I686.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT RATE-DATA      ASSIGN TO DISK "RATE.DAT"
                ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS ST-RATE-IN.
         SELECT RATE-DATA-OUT  ASSIGN TO DISK "RATE-KEY.DAT"
                ORGANIZATION INDEXED
                ACCESS RANDOM
                RECORD KEY TYPE-ACCT-OUT
                FILE STATUS IS ST-RATE-OUT.

       DATA DIVISION.
       FILE SECTION.
 *    * Account analyzed
       FD  RATE-DATA.
       01  RATE-RECORD.
           05  TYPE-ACCT-IN        PIC X(4).
           05  FILLER              PIC X.
           05  RATE-IN             PIC 9(3),9(2).
           05  FILLER              PIC X.
           05  MAX-SAVING-IN       PIC 9(5).
           05  FILLER              PIC X.
           05  DESCRIPTION-IN      PIC X(32).
 *    * Account analyzed with key
       FD  RATE-DATA-OUT.
       01  RATE-DATA-OUT-RECORD.
           05  TYPE-ACCT-OUT       PIC X(4).
           05  RATE-OUT            PIC 999V99.
           05  MAX-SAVING-OUT      PIC 9(5).
           05  DESCRIPTION-OUT     PIC X(32).

       WORKING-STORAGE SECTION.
       77  CURRENT-NAME            PIC X(32).
       77  CURRENT-ENTRIES         PIC 999.
       01  ST-RATE-IN              PIC X(02)    VALUE SPACES.
           88  ST-RATE-IN-SUCCESS               VALUE '00'.
           88  ST-RATE-IN-EOF                   VALUE '10'.
       01  ST-RATE-OUT             PIC X(02)    VALUE SPACES.
           88  ST-RATE-OUT-SUCCESS              VALUE '00'.
           88  ST-RATE-OUT-EOF                  VALUE '10'.
       01  ARE-THERE-MORE-RECORDS  PIC XXX      VALUE 'YES'.
       01  IS-FIRST-ENTRY          PIC XXX      VALUE 'YES'.
           88 NOT-FIRST-ENTRY                   VALUE 'NO '.

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
         INITIALIZE ST-RATE-IN ST-RATE-OUT
         PERFORM 200-OPEN-RATE
         STOP RUN.

       110-ERROR-EXIT.
         EXIT.
         STOP RUN.

       200-OPEN-RATE.
         MOVE 'YES' TO IS-FIRST-ENTRY
         OPEN INPUT RATE-DATA
              OUTPUT RATE-DATA-OUT.
         IF ST-RATE-IN-SUCCESS AND ST-RATE-OUT-SUCCESS
           DISPLAY "RATE OPEN SUCCESSFUL"
         ELSE
           DISPLAY "RATE OPEN FAILED"
           PERFORM 110-ERROR-EXIT
         END-IF.
         PERFORM 210-COPY-RATE
         CLOSE RATE-DATA
               RATE-DATA-OUT.

       210-COPY-RATE.
         READ RATE-DATA INTO RATE-RECORD
       	   AT END MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
         END-READ.
         PERFORM 220-WRITE-RATE
           UNTIL ARE-THERE-MORE-RECORDS = 'NO'.

       220-WRITE-RATE.
         MOVE TYPE-ACCT-IN TO TYPE-ACCT-OUT.
         MOVE RATE-IN TO RATE-OUT.
         MOVE MAX-SAVING-IN TO MAX-SAVING-OUT.
         MOVE DESCRIPTION-IN TO DESCRIPTION-OUT.
         WRITE RATE-DATA-OUT-RECORD
           INVALID PERFORM 230-ERROR-KEY.
         READ RATE-DATA INTO RATE-RECORD
           AT END MOVE 'NO ' TO ARE-THERE-MORE-RECORDS
         END-READ.

       230-ERROR-KEY.
         DISPLAY "CLE DOUBLE : " TYPE-ACCT-IN.
         STOP RUN.

       END PROGRAM REORG.