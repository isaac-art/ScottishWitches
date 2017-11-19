
      ////////////////////////////////////////////////
     // A study of a survey of scottish witchcraft //
    //                by Isaac Clarke             //
   //                  November 2017             //
  ////////////////////////////////////////////////


/* 
include: data files
returns: pdf (can take a few minutes, a few thousand pages)

Acknowledgements:
---	Julian Goodare, Lauren Martin, Joyce Miller and Louise Yeoman, 
	'The Survey of Scottish Witchcraft', www.shc.ed.ac.uk/witches/ 
	(archived January 2003, accessed ’15/11/2017’).
	
	https://data.world/history/scottish-witchcraft/workspace/project-summary

	This database contains a variety of information on the almost 
	4,000 people who were accused of practicing witchcraft between 
	1563 and 1736 in Scotland.

---	Visual Dictionary - Lior Ben-Gai - 2017

*/

import processing.pdf.*;
PGraphicsPDF pdf;
int pageCounter = 0;
int rowCount = 0;
PFont largerTitleFont, titleFont, nameFont, detailsFont, pageFont, wordFont;
Table accused;
Table theCase;

void setup() {
	size(2480,3508);

	//config fonts and sizes
	largerTitleFont = createFont("Arial", 140);
	titleFont = createFont("Arial", 80);
  	wordFont = createFont("Arial", 40);
	pageFont = createFont("Arial", 60);
	nameFont = createFont("Arial", 32);
	detailsFont = createFont("Arial", 8);

	//open the csv into the table
	println("opening data files...");
	accused = loadTable("WDB_Accused.csv", "header");
	theCase = loadTable("WDB_Case.csv", "header");
	println("ready to go!");
	//count how many rows in the table and assign to an int
	rowCount = accused.getRowCount();

	pdf = (PGraphicsPDF)beginRecord(PDF, "ScottishWitches.pdf");
  	beginRecord(pdf);
}

void draw() {

	background(0);

	// draw the cover and intro first
	if(pageCounter == 0){
	    // FIRST PAGE
	    drawFrontCover();
	    pdf.nextPage();
	    drawAcknowledgements();
	    pageCounter++;
	}
	//draw the end pages at the end
	//else if(pageCounter > rowCount){
	else if(pageCounter > rowCount){

		background(0);
		drawBackCover();
      	endRecord(); 
      	exit(); 
	}

	//draw all the pages
	else{

		background(0);
		drawPageInfo();
	    pdf.nextPage();
	}


		
}

void drawPageInfo(){
  // get the next row from the accused table
  TableRow accusedRow = accused.getRow(pageCounter-1);
  // grab some details from the row
  String firstName = accusedRow.getString("FirstName");
  String lastName = accusedRow.getString("LastName");
  String fromPlace = accusedRow.getString("Res_county");
  String accusedRef = accusedRow.getString("AccusedRef");

  fill(255);
  stroke(84,9,22);
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  text(firstName+" "+lastName,width/2, 241);
  textFont(wordFont);
  //use the accused ref value to search the case table for extra details
  if(theCase.findRow(accusedRef, "AccusedRef") != null){
  	 TableRow theCaseRow = theCase.findRow(accusedRef, "AccusedRef");
  	 	//print the date of the case
	  if(theCaseRow.getString("Case_date") != null){
	 	 String theCaseDate = theCaseRow.getString("Case_date");
	 	 text(theCaseDate, width/2, 360);
	  }

		int fnLen = firstName.length();
		int lnLen = lastName.length();
		int placeLen = fromPlace.length();
		int accusedRefLen = accusedRef.length();

		//draw some shapes from the words plucked out
	  	pushMatrix();
		  	pushStyle();
		  	translate(220, 800);
		  		fill(184,9,22);
			  	beginShape();
				  	for(int i = 0; i < fnLen; i++){
				  		float firstNameletter = map(constrain(int(firstName.charAt(i)),97,222), 97, 222, 0, 800);
				  		vertex(firstNameletter, random(0, 800));
				  	}
			  	endShape();
		  	popStyle();
	  	popMatrix();

	  	pushMatrix();
		  	pushStyle();
		  	translate(width/2+220, 800);
		  		fill(71,88,121);
			  	beginShape();
				  	for(int i = 0; i < lnLen; i++){
				  		float lnLenletter = map(constrain(int(lastName.charAt(i)),97,222), 97, 222, 0, 800);
				  		vertex(lnLenletter, random(0, 800));
				  	}
			  	endShape();
		  	popStyle();
	  	popMatrix();

	  	pushMatrix();
		  	pushStyle();
		  	translate(220, 1700);
		  		fill(0,203,201);
			  	beginShape();
				  	for(int i = 0; i < placeLen; i++){
				  		float placeLenletter = map(constrain(int(fromPlace.charAt(i)),97,222), 97, 222, 0, 800);
				  		vertex(placeLenletter, random(0, 800));
				  	}
			  	endShape();
		  	popStyle();
	  	popMatrix();


	  //look through the text feilds for info and print what it finds into a grid like layout
	  if(theCaseRow.getString("CaseNotes") != null){
	 	 String theCaseCaseNotes = theCaseRow.getString("CaseNotes");
		 text(theCaseCaseNotes, 220, 800, 800, 800);
	  }  
	   if(theCaseRow.getString("Charnotes") != null){
	 	 String charnotes = theCaseRow.getString("Charnotes");
		 text(charnotes, width/2+220, 800, 800, 800);
	  }
	  if(theCaseRow.getString("DevilNotes") != null){
	 	 String devilNotes = theCaseRow.getString("DevilNotes");
		 text(devilNotes, 220, 1700, 800, 800);
	  }
	   if(theCaseRow.getString("MeetingNotes") != null){
	 	 String meetingNotes = theCaseRow.getString("MeetingNotes");
		 text(meetingNotes, width/2+220, 1700, 800, 800);
	  }
	   if(theCaseRow.getString("OtherMaleficiaNotes") != null){
	 	 String otherMaleficiaNotes = theCaseRow.getString("OtherMaleficiaNotes");
		 text(otherMaleficiaNotes, 220, 2600, 800, 800);
	  }

 
 }
 


  // page number
  textFont(pageFont);
  text(pageCounter++,width/2,height-120);
}

void drawFrontCover(){
  // FIRST PAGE
  fill(255);
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  text("A Study Of A Survey Of", width/2, (height/2)-180);
  textFont(largerTitleFont);
  text("Scottish Witchcraft", width/2, height/2);
  textFont(pageFont);
  text("Isaac Clarke",width/2, (height/2)+380);
  text("November 2017",width/2, (height/2)+440);
}

void drawAcknowledgements(){

}

void drawBackCover(){
	//add a blank page at the end.
	background(0);
	pdf.nextPage(); 
}