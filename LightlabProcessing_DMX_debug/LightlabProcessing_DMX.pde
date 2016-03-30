//EDITED: MovingHead + Lamp_Layout + narrowSpot

/**
 * This code works with the Arduino Lightlab_Arduino sketch. Please upload the Arduino code first
 * This program is based upon the layout of the lightlab (LP-1.18) as of july 2015.
 * If lamps use different channels than expected, it could be that this sketch is dated, and that the layout of the lightlab has been changed
 *
 * How to use: 
 * please only edit this TAB and the Lamp_Layout TAB (in case of unexpected lamp behaviour)
 * you can find the functions of a lamptype in the corresponding tabs
 *
 * This sketch was created by Karin Niemantsverdriet and Thomas van de Werff
 */
 
 //imports
import processing.serial.*;
import java.util.Date;

//variables
Serial myPort;           // Create object from Serial class
int val;                 // Data received from the serial port

//setup function (executed on startup)
void setup() 
{
  //setup canvas
  size(200, 200);
  
  //open serial communication
  String portName = Serial.list()[0];           //choose the right portNumber for your DMX arduino
  myPort = new Serial(this, portName, 115200);  //set BAUD rate equal to BAUD rate in Arduino sketch
 
 //initialize the lamps in the lightlab:
 initLightLab();       //If problems, check the initialized channels in the function in Lamp_Layout
 
 
 //alternativly add your own lamp:
 //rgbSpots.add(new RGBSpot(channelNumber, "name"));
}


//loop function, continuously executed while this program runs
void draw() {
  int ct = 2900;
  
  //for (int i=0;i < rgbSpots.size() ; i++){
  //  rgbSpots.get(i).setCTinKelvin(ct);
  //  rgbSpots.get(i).setBrightness(255);
  //}
  //for (int i=0;i < ctSpots.size() ; i++){
  //  ctSpots.get(i).setCTinKelvin(ct);
  //}
  //for (int i=0;i < cameleons.size() ; i++){
  //  cameleons.get(i).setCTinKelvin(ct);
  //  cameleons.get(i).setBrightness(220);
  //}
  //for (int i=0;i < ctLedWashers.size() ; i++){
  //  ctLedWashers.get(i).setCTinKelvin(ct);
  //  ctLedWashers.get(i).setBrightness(255);
  //}
  //for (int i=0;i < sunStrips.size() ; i++){
  //  //sunStrips.get(i).setCTinKelvin(ct);
  //}
  
  //update every lamp in the lightlab (needed for tweening)
  updateAll();
}

//calls the update function for every lamp in the lab, to update tweening
void updateAll(){
  //traceln("update");
  for (int i=0;i < rgbSpots.size() ; i++){
    rgbSpots.get(i).update();
  }
  for (int i=0;i < ctSpots.size() ; i++){
    ctSpots.get(i).update();
  }
  for (int i=0;i < cameleons.size() ; i++){
    cameleons.get(i).update();
  }
  for (int i=0;i < ctLedWashers.size() ; i++){
    ctLedWashers.get(i).update();
  }
  for (int i=0;i < sunStrips.size() ; i++){
    sunStrips.get(i).update();
  }
  for (int i=0;i < narrowSpots.size() ; i++){
    narrowSpots.get(i).update();
  }
  for (int i=0;i < strobes.size() ; i++){
    strobes.get(i).update();
  }
}


//test function, feel free to delete
//on mouseClick within the square, execute certain functions.
//on mouseClick outside of the square, execute other functions.
void mouseClicked(){
  background(255);
  if (mouseOverRect() == true) {  // If mouse is over square,
    fill(204);                    // change color and
    
    //for (int i=0;i < rgbSpots.size() ; i++){
    //  rgbSpots.get(i).tweenBrightness(int(random(0,255)), 2000);
    //  rgbSpots.get(i).tweenRGB(int(random(0,255)),int(random(0,255)),int(random(0,255)), 4000);
    //}
    //for (int i=0;i < ctSpots.size() ; i++){
    //  ctSpots.get(i).tweenCool(int(random(0,255)), 4000);
    //}
    
    for (int i=0;i < cameleons.size() ; i++){
     cameleons.get(i).setRGB(int(random(0,255)),int(random(0,255)),int(random(0,255)));
     cameleons.get(i).setBrightness(255);
    }
    //for (int i=0;i < ctLedWashers.size() ; i++){
    //  ctLedWashers.get(i).tweenBrightness(int(random(0,255)), 1500);
    //  ctLedWashers.get(i).tweenCool(int(random(0,255)), 4000);
    //}
    //for (int i=0;i < sunStrips.size() ; i++){
    //  for(int j=0; j<10; j++){
    //    sunStrips.get(i).startBreathing(0, 255, int(random(500,5000)),j);
    //  }
    //}
    //for (int i=0;i < narrowSpots.size() ; i++){
    //  narrowSpots.get(i).tweenBrightness(int(random(0,255)), 4000);
    //}
    //for (int i=0;i < strobes.size() ; i++){
    //  strobes.get(i).startBreathing(0, 255, 500,4);
    //  strobes.get(i).startBreathing(0, 255, 500,2);
    //}
    
    blackout(false);
  } 
  else {                        // If mouse is not over square,
    fill(0);                      // change color and
    blackout(true);
  }
  rect(50, 50, 100, 100);         // Draw a square
}

boolean mouseOverRect() { // Test if mouse is over square
  return ((mouseX >= 50) && (mouseX <= 150) && (mouseY >= 50) && (mouseY <= 150));
}

void exit()
{
   blackout(true);
}
 
 
//debug function
void traceln(String message){
  Date d = new Date();
  println(d.getHours()+":"+d.getMinutes()+":"+d.getSeconds()+"    "+message);
}
 