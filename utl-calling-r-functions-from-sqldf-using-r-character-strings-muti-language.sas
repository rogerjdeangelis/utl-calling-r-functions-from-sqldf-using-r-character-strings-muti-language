%let pgm=utl-calling-r-functions-from-sqldf-using-r-character-strings-muti-language;

Calling r functions from sql using r character strings muti language

Sqldf does not support the range function.
We create r and python functions and call them from sql.

It is a litle messy because you have to generate code in R.
A little cleaner generating the function in sas

  SOLUTIONS

     1 sas sql
     2 r base and sql
     3 gave up on python


github
https://tinyurl.com/3trb4htf
https://github.com/rogerjdeangelis/utl-calling-r-functions-from-sqldf-using-r-character-strings-muti-language


/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                   |                                      |                                             */
/*             INPUT                 |    PROCESS                           |            OUTPUT                           */
/*             =====                 |    =======                           |            ======                           */
/*                                   |                                      |                                             */
/*  NAME    SEX AGE HEIGHT WEIGHT    | COMPUTE THE RANGE OF                 | SEX AGE_RANGE HEIGHT_RANGE WEIGHT_RANGE     */
/*                                   | AGE, HEIGHT and WEIGHT               |                                             */
/*  Alfred   M   14  69.0   112.5    | BY SEX                               |   F         4         15.2           62     */
/*  Alice    F   13  56.5    84.0    |                                      |   M         5         14.7           67     */
/*  Barbara  F   13  65.3    98.0    |--------------------------------------|                                             */
/*  Carol    F   14  62.8   102.5    |                                      |                                             */
/*  Henry    M   14  63.5   102.5    | 1 SAS SOLUTION                       |                                             */
/*  James    M   12  57.3    83.0    |                                      |                                             */
/*  Jane     F   12  59.8    84.5    | select                               |                                             */
/*  Janet    F   15  62.5   112.5    |   sex                                |                                             */
/*  Jeffrey  M   13  62.5    84.0    |  ,range(age   ) as age_range         |                                             */
/*  John     M   12  59.0    99.5    |  ,range(height) as height_range      |                                             */
/*  Joyce    F   11  51.3    50.5    |  ,range(weight) as weight_range      |                                             */
/*  Judy     F   14  64.3    90.0    | from                                 |                                             */
/*  Louise   F   12  56.3    77.0    |   sd1.have                           |                                             */
/*  Mary     F   15  66.5   112.0    | group                                |                                             */
/*  Philip   M   16  72.0   150.0    |   by sex                             |                                             */
/*  Robert   M   12  64.8   128.0    |                                      |                                             */
/*  Ronald   M   15  67.0   133.0    |------------------------------------- |                                             */
/*  Thomas   M   11  57.5    85.0    |                                      |                                             */
/*  William  M   15  66.5   112.0    | 2 R BASE AND SQL                     |                                             */
/*                                   |                                      |                                             */
/*  options validvarname=upcase;     | /*--- r function           ---*/     |                                             */
/*  libname sd1 "d:/sd1";            | rangex <- function(x) {              |                                             */
/*  data sd1.have;                   |  var=substitute(x)                   |                                             */
/*   set sashelp.class;              |  return (paste("                     |                                             */
/*  run;quit;                        |     ,max(",var,")-min(",var,")       |                                             */
/*                                   |      as ",var))}                     |                                             */
/*                                   |                                      |                                             */
/*                                   | "select                              |                                             */
/*                                   |     SEX "                            |                                             */
/*                                   |    ,rangex(AGE)                      |                                             */
/*                                   |    ,rangex(HEIGHT)                   |                                             */
/*                                   |    ,rangex(WEIGHT),                  |                                             */
/*                                   | "from                                |                                             */
/*                                   |     have                             |                                             */
/*                                   |  group                               |                                             */
/*                                   |     by SEX"                          |                                             */
/*                                   |                                      |                                             */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 set sashelp.class;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  NAME       SEX    AGE    HEIGHT    WEIGHT                                                                             */
/*                                                                                                                        */
/*  Alfred      M      14     69.0      112.5                                                                             */
/*  Alice       F      13     56.5       84.0                                                                             */
/*  Barbara     F      13     65.3       98.0                                                                             */
/*  Carol       F      14     62.8      102.5                                                                             */
/*  Henry       M      14     63.5      102.5                                                                             */
/*  James       M      12     57.3       83.0                                                                             */
/*  Jane        F      12     59.8       84.5                                                                             */
/*  Janet       F      15     62.5      112.5                                                                             */
/*  Jeffrey     M      13     62.5       84.0                                                                             */
/*  John        M      12     59.0       99.5                                                                             */
/*  Joyce       F      11     51.3       50.5                                                                             */
/*  Judy        F      14     64.3       90.0                                                                             */
/*  Louise      F      12     56.3       77.0                                                                             */
/*  Mary        F      15     66.5      112.0                                                                             */
/*  Philip      M      16     72.0      150.0                                                                             */
/*  Robert      M      12     64.8      128.0                                                                             */
/*  Ronald      M      15     67.0      133.0                                                                             */
/*  Thomas      M      11     57.5       85.0                                                                             */
/*  William     M      15     66.5      112.0                                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
    table want as
  select
    sex
   ,range(age   ) as age_range
   ,range(height) as height_range
   ,range(weight) as weight_range
  from
    sd1.have
  group
    by sex
;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                 AGE_    HEIGHT_    WEIGHT_                                                                             */
/*  Obs    SEX    RANGE     RANGE      RANGE                                                                              */
/*                                                                                                                        */
/*   1      F       4        15.2        62                                                                               */
/*   2      M       5        14.7        67                                                                               */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___           _                       ___               _
|___ \   _ __  | |__   __ _ ___  ___   ( _ )    ___  __ _| |
  __) | | `__| | `_ \ / _` / __|/ _ \  / _ \/\ / __|/ _` | |
 / __/  | |    | |_) | (_| \__ \  __/ | (_>  < \__ \ (_| | |
|_____| |_|    |_.__/ \__,_|___/\___|  \___/\/ |___/\__, |_|
                                                       |_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
rangex <- function(x) {
 var=substitute(x)
 return (paste0(",max(",var,")-min(",var,") as ",var,"_RANGE"))
 }
want <- sqldf(paste(
      "select
          SEX "
         ,rangex(AGE)
         ,rangex(HEIGHT)
         ,rangex(WEIGHT),
      "from
          have
       group
          by SEX"))
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                           |                                                                            */
/* R                                         | SAS                                                                        */
/*                                           |                     AGE_    HEIGHT_    WEIGHT_                             */
/* SEX AGE_RANGE HEIGHT_RANGE WEIGHT_RANGE   | ROWNAMES    SEX    RANGE     RANGE      RANGE                              */
/*                                           |                                                                            */
/*   F         4         15.2           62   |     1        F       4        15.2        62                               */
/*   M         5         14.7           67   |     2        M       5        14.7        67                               */
/*                                           |                                                                            */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
