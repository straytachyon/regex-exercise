rem @perl "extract.pl" "Education and Related Services" "sick leave.{1,50}\d+|\d+.{1,50}sick leave|sick day.{1,50}\d+|\d+.{1,50}sick day" > edu-sickleave.txt

@perl "extract.pl" "Education and Related Services" "(sick leave.{1,150}\d+.{1,20}day|\d+.{1,20}day.{1,150}sick leave|sick leave.{1,150}\d+.{0,20}month|\d+.{1,150}sick days|d+.{1,20}hour.{1,150}sick leave|illness.{1,150}period of.{1,30}\d+)" > edu-sickleave.txt