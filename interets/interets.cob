       IDENTIFICATION DIVISION.
       PROGRAM-ID. INTERETS.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. PC-I686.
       OBJECT-COMPUTER. PC-I686.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT ACCT-DATA-IN  ASSIGN TO DISK "ACCT.DAT"
                ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS ST-ACCT-IN.
         SELECT RATE-DATA     ASSIGN TO DISK "RATE-KEY.DAT"
                ORGANIZATION INDEXED
                ACCESS RANDOM
                RECORD KEY TYPE-ACCT
                FILE STATUS IS ST-RATE.
         SELECT ACCT-DATA-OUT ASSIGN TO DISK "ACCT-OUT.DAT"
                ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS ST-ACCT-OUT.
         SELECT TOTAL-DATA    ASSIGN TO DISK "TOTAL.DAT"
                ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS ST-TOTAL.

       DATA DIVISION.
       FILE SECTION.
 *    * Account analyzed
       FD  ACCT-DATA-IN.
       01  ACCT-DATA-IN-RECORD.
           05  OWNER-NAME-IN        PIC X(20).
           05   FILLER              PIC X.
           05  SAVING-IN            PIC 9(7).
           05   FILLER              PIC X.
           05  ACCT-TYPE-IN         PIC X(4).
           05   FILLER              PIC X.
           05  DESCRIPTION-IN       PIC X(20).

 *    * Rate analyzed with key
       FD  RATE-DATA.
       01  RATE-DATA-RECORD.
           05  TYPE-ACCT            PIC X(4).
           05  RATE                 PIC 999V99.
           05  MAX-SAVING           PIC 9(5).
           05  DESCRIPTION          PIC X(32).

 *    * Updated Account
       FD  ACCT-DATA-OUT.
       01  ACCT-DATA-OUT-RECORD.
           05  OWNER-NAME-OUT       PIC X(20).
           05   FILLER              PIC X.
           05  SAVING-OUT           PIC 9(7).
           05   FILLER              PIC X.
           05  ACCT-TYPE-OUT        PIC X(4).
           05   FILLER              PIC X.
           05  DESCRIPTION-OUT      PIC X(20).

 *    * Total per Owner
       FD  TOTAL-DATA.
       01  PRINT-REC.
           05  NAME-OUT             PIC X(20).
           05   FILLER              PIC X(10).
           05  TOTAL-OUT            PIC Z(7).9(2).

       WORKING-STORAGE SECTION.
       77  CUR-NAME                 PIC X(32).
       77  CUR-ENTRIES              PIC 999.
       77  CUR-FUND                 PIC Z(7).9(2).
       77  CUR-PERCENTAGE           PIC 9V9(5).
       77  CUR-ITER                 PIC 99.
       77  ARE-THERE-MORE-RECORDS   PIC X           VALUE 'Y'.

       01  ST-ACCT-IN               PIC X(02)       VALUE SPACES.
           88  ST-ACCT-IN-SUCCESS                   VALUE '00'.
           88  ST-ACCT-IN-EOF                       VALUE '10'.

       01  ST-ACCT-OUT              PIC X(02)       VALUE SPACES.
           88  ST-ACCT-OUT-SUCCESS                  VALUE '00'.
           88  ST-ACCT-OUT-EOF                      VALUE '10'.

       01  ST-RATE                  PIC X(02)       VALUE SPACES.
           88  ST-RATE-SUCCESS                      VALUE '00'.
           88  ST-RATE-EOF                          VALUE '10'.

       01  ST-TOTAL                 PIC X(02)       VALUE SPACES.
           88  ST-TOTAL-SUCCESS                     VALUE '00'.
           88  ST-TOTAL-EOF                         VALUE '10'.

       01  IS-FIRST-ENTRY           PIC X           VALUE 'Y'.
           88  NOT-FIRST-ENTRY                      VALUE 'N'.

       01  TABLE-RATE.
           07  TABLE-RATE-RECORD    OCCURS 9 TIMES
                                    ASCENDING KEY CUR-TYPE-ACCT
                                    INDEXED BY MY-INDEX.
               10  CUR-TYPE-ACCT    PIC X(4).
               10  CUR-RATE         PIC 999V99.
               10  CUR-MAX-SAVING   PIC 9(5).
               10  CUR-DESCRIPTION  PIC X(32).

       PROCEDURE DIVISION.
       100-MAIN-MODULE.
         INITIALIZE ST-ACCT-IN ST-ACCT-OUT ST-RATE ST-TOTAL CUR-ITER.
         MOVE HIGH-VALUES TO TABLE-RATE.
         PERFORM 200-LOAD-TABLE.
         PERFORM 300-OPEN-ACCT.
         STOP RUN.

       110-ERROR-EXIT.
         EXIT.
         STOP RUN.

       200-LOAD-TABLE.
         OPEN INPUT RATE-DATA.
         IF ST-RATE-SUCCESS
           DISPLAY 'RATE OPEN SUCCESS'
         ELSE
           DISPLAY 'RATE OPEN FAILED'
           PERFORM 110-ERROR-EXIT
         END-IF.
         READ RATE-DATA INTO RATE-DATA-RECORD.
 *    *   AT END MOVE 'N' TO ARE-THERE-MORE-RECORDS.
         PERFORM 210-LOAD-RATE
           VARYING CUR-ITER FROM 1 BY 1 UNTIL CUR-ITER > 9
           OR ARE-THERE-MORE-RECORDS = 'N'.
         CLOSE RATE-DATA.

       210-LOAD-RATE.
         MOVE RATE-DATA-RECORD TO TABLE-RATE-RECORD (CUR-ITER).
         READ RATE-DATA INTO RATE-DATA-RECORD.
 *    *    AT END MOVE 'N' TO ARE-THERE-MORE-RECORDS.

       300-OPEN-ACCT.
         MOVE 'Y' TO ARE-THERE-MORE-RECORDS.
         OPEN INPUT ACCT-DATA-IN
              OUTPUT ACCT-DATA-OUT.
         IF ST-ACCT-IN-SUCCESS AND ST-ACCT-OUT-SUCCESS
           DISPLAY 'ACCT OPEN SUCCESSFUL'
         ELSE
           DISPLAY 'ACCT OPEN FAILED'
           PERFORM 110-ERROR-EXIT
         END-IF.
         PERFORM 310-PROCESSING-ACCT
         CLOSE ACCT-DATA-IN
               ACCT-DATA-OUT.

       310-PROCESSING-ACCT.
         READ ACCT-DATA-IN INTO ACCT-DATA-IN-RECORD
           AT END MOVE 'N' TO ARE-THERE-MORE-RECORDS.
         PERFORM 320-SEARCH-RATE
           UNTIL ARE-THERE-MORE-RECORDS = 'N'.

       320-SEARCH-RATE.
         SET MY-INDEX TO 1.
         SEARCH TABLE-RATE-RECORD
 *    *  SEARCH ALL TABLE-RATE-RECORD
           AT END PERFORM 330-NOT-FOUND
           WHEN CUR-TYPE-ACCT (MY-INDEX) = ACCT-TYPE-IN
             MOVE OWNER-NAME-IN TO CUR-NAME
             DIVIDE CUR-RATE (MY-INDEX) BY 100 GIVING CUR-PERCENTAGE
             MULTIPLY CUR-PERCENTAGE BY SAVING-IN GIVING CUR-FUND.
         PERFORM 340-WRITE-ACCT.

       330-NOT-FOUND.
         MOVE SAVING-IN TO SAVING-OUT.

       340-WRITE-ACCT.
         MOVE OWNER-NAME-IN TO OWNER-NAME-OUT.
         MOVE CUR-FUND TO SAVING-OUT.
         MOVE ACCT-TYPE-IN TO ACCT-TYPE-OUT.
         MOVE DESCRIPTION-IN TO DESCRIPTION-OUT.
         WRITE ACCT-DATA-OUT-RECORD.

       END PROGRAM INTERETS.
