LOAD DATA
	INFILE data.txt	 
  REPLACE 
	INTO TABLE LOAD3	  
  when (t2 = "dec")
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	(
	t1,
	t2 "upper(:t2)",
	t3
	)