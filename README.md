# COBOL-examples
Small COBOL programs for testing purposes


# Details

This is a sample program that displays "Hello World":

The I of IDENTIFICATION must be at the column 8 ( 7 spaces before ).

---- hello.cob -------------------------
     * Sample COBOL program
      IDENTIFICATION DIVISION.
      PROGRAM-ID. hello.
      PROCEDURE DIVISION.
      DISPLAY "Hello World!".
      STOP RUN.
----------------------------------------

The compiler is cobc, which is executed as follows:

$ cobc -x hello.cob
$ ./hello
Hello World!

The executable file name (i.e., hello in this case) is determined by removing
the extension from the source file name.

You can specify the executable file name by specifying the compiler option -o
as follows:

$ cobc -o hello-world hello.cob
$ ./hello-world
Hello World!


# Acknowledge

I must thanks Hedhili Jaidane for his examples and help when I wrote some of
these scripts. I should also thanks some helpful peoples that I forgot on the
forum "Developpez.net" in the Mainframe z/OS section.

