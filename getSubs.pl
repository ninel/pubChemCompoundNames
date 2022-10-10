#!/usr/bin/perl
my @a = (0..943);
foreach(@a) {
	$i = $_;
	#download file
	$file = sprintf("Substance_%09d_%09d.sdf.gz",1+500000*$i,500000*(1+$i));
	$url = sprintf("https://ftp.ncbi.nlm.nih.gov/pubchem/Substance/CURRENT-Full/SDF/%s",$file);
	printf("$url\n");
	$cmd = "curl -O '$url'";
	unless ( -e $file ) {
		printf("$cmd\n");
		system("$cmd");
	}
	
	# get substance name
	$cmd2 = sprintf("zcat $file | grep -A2 _COMMENT | grep -v _COMMENT | grep -v 'Imaging Agents' | grep [a-zA-Z] | sort | uniq > s%d.txt", $i);
	printf("$cmd2\n");
	system("$cmd2");
	
	# delete downloaded file
	#system("rm $file");
}
