/**
 * This code works with the Arduino DmxSimple SerialToDmxLightlab sketch. Please upload the Arduino code to the Arduino first. 
 * Make sure the arduino is connected to the Dmx cable by using a DMX shield and to your PC. 
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
  size(1000, 1000);

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

  // do lamp effects here

  //update every lamp in the lightlab (needed for tweening)
  updateAll();
}

//calls the update function for every lamp in the lab, to update tweening
void updateAll() {
  //traceln("update");
  for (int i=0; i < rgbSpots.size(); i++) {
    rgbSpots.get(i).update();
  }
  for (int i=0; i < ctSpots.size(); i++) {
    ctSpots.get(i).update();
  }
  for (int i=0; i < cameleons.size(); i++) {
    cameleons.get(i).update();
  }
  for (int i=0; i < ctLedWashers.size(); i++) {
    ctLedWashers.get(i).update();
  }
  for (int i=0; i < sunStrips.size(); i++) {
    sunStrips.get(i).update();
  }
  for (int i=0; i < narrowSpots.size(); i++) {
    narrowSpots.get(i).update();
  }
  for (int i=0; i < strobes.size(); i++) {
    strobes.get(i).update();
  }
}

void exit()
{
  blackout(true);
}

//debug function
void traceln(String message) {
  Date d = new Date();
  println(d.getHours()+":"+d.getMinutes()+":"+d.getSeconds()+"    "+message);
}