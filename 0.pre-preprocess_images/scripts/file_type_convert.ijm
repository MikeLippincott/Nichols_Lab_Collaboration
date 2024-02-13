macro "Maximum Intensity Projection" {
	//INPUT/OUTPUT folders
	inDir=getDirectory("Choose the input folder");
	outDir=getDirectory("Choose the output folder");
	myList=getFileList(inDir);  //an array
	start = getTime();
	waitForUser("I solemnly swear I am up to no good");
	// Make an array of tif files only
	flist = newArray(0);
	for (i=0; i<myList.length; i++) {
		if (endsWith(myList[i], ".ims")) {
			flist = append(flist, myList[i]);
		}
	}

	for (j = 0 ; j < flist.length ; j++ ){
		progress = j / flist.length;
		print(progress+"% complete");
		path=inDir+flist[j];
		open(path);
		a = File.getName(path);
		print(a);
		tmp_name1=a+" - "+a+" Resolution Level 1";
		tmp_name2=a+" - "+a+" Resolution Level 2";
		tmp_name3=a+" - "+a+" Resolution Level 3";
		tmp_name4=a+" - "+a+" Resolution Level 4";
		tmp_name5=a+" - "+a+" Resolution Level 5";

		close(tmp_name2);
		close(tmp_name3);
		close(tmp_name4);
		close(tmp_name5);

		b=replace(a, ".ims", ".tiff");


		saveAs("Tiff", outDir+b);
		close("*");
	}
	sec = (getTime()-start)/1000;
	min = sec/60;
	hour = min/60;
	print(sec+" seconds");
	print(min+" minutes");
	print(hour+" hours");
	waitForUser("Mischeif Managed");
}


function append(arr, value) {
    arr2 = newArray(arr.length+1);
    for (i=0; i<arr.length; i++)
        arr2[i] = arr[i];
        arr2[arr.length] = value;
    return arr2;
}
