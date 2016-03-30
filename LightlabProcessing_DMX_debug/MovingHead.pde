public class MovingHead extends Lamp{
  
  int nrOfChannels = 13;
  String[] colors = {"white", "yellow", "pink", "green", "red", "lightBlue", "lightGreen", "orange", "darkBlue", "white+yellow", "yellow+pink", "pink+green", "green+red", "red+lightBlue", "lightBlue+lightGreen", "lightGreen+orange", "orange+darkBlue", "darkBlue+white"};
  
  MovingHead(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 13){
      functions = new int[13];
      functions[0] = PANNING;
      functions[1] = TILTING;
      //functions[2] = PANNINGFINE;
      //functions[3] = TILTINGFINE;
      //functions[4] = SPEED;
      functions[5] = COLORS;      //same as narrow?
      functions[6] = STROBE;
      functions[7] = BRIGHTNESS;
      //functions[8] = ROTATION;
      //functions[9] = ROTATIONDIRECTION;
      //functions[10] = PRISM;
      //functions[11] = CHANNELFUNCTIONS;
      //functions[12] = BUILD-INPROGRAMS;
      
      currentValues = new int[13];
      tweeningToValue = new int[13];
      lastTweeningUpdate = new int[13];
      tweeningTime = new int[13];
      tweeningDelta = new int[13];
      breathing = new boolean[13];
      minBreathingValue = new int[13];
      maxBreathingValue = new int[13];
      breathingDelta = new int[13];
      stopBreathing(); //fill array with false
    }else{
      traceln("error: number of channels of "+name+" is incorrect");
    }
  }
  
  //MOVEMENT FUNCTIONS
  
  //pan (horizontal movement
  public void setPan(int p){
    writeDmx(0, p);
  }
  public void adjustPan(int deltaP){
    writeDmx(0, (currentValues[0]+deltaP));
  }
  public int getPan(){
    return currentValues[0];
  }
  public void adjustPanFine(int deltaPfine){
    writeDmx(2, (currentValues[2]+deltaPfine));
  }
  //tilt (vertical movement)
  public void setTilt(int t){
    writeDmx(1, t);
  }
  public void adjustTilt(int deltaT){
    writeDmx(1, (currentValues[1]+deltaT));
  }
  public int getTilt(){
    return currentValues[1];
  }
  public void adjustTiltFine(int deltaTfine){
    writeDmx(3, (currentValues[3]+deltaTfine));
  }
  //speed
  public void setSpeed(int s){    //0 = max, 255 = min
    writeDmx(4, s);
  }
  public void adjustSpeed(int deltaS){
    writeDmx(4, (currentValues[4]+deltaS));
  }
  public int getSpeed(){
    return currentValues[4];
  }
  
  //check strobe
  void checkStrobe(){
    if(currentValues[6]==0){
      writeDmx(6, 5);
    }
  }
  //color wheel functions
  public void setColor(String c){
    checkStrobe();
    for (int i=0; i<colors.length-1; i++){
      if(c.equals(colors[i])){
        writeDmx(5, (i*7)+3);
        break;
      }
      //traceln("color doesn't exist in MovingHead");
    }
  }
  public void setColor(int c){
     checkStrobe();
     writeDmx(5, (c*7)+3);
  }
  public int getColor(){
    return currentValues[5];
  }
  public void adjustColor(int deltaC){
    checkStrobe();
    writeDmx(5, currentValues[5]+deltaC);
  }
  public void setRainbow(int speed, boolean clockWise){  //speed 0-255, direction boolean (true == clockwise / positive)
    checkStrobe();
    int start = 192;
    if(clockWise){
      start = 128;
    }
    writeDmx(5, start+int(map(speed, 0, 255, 0, 63)));
  }
  
  public void setBrightness(int bri){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
        writeDmx(7, bri);
      }
    }
    
    if (bri > 0) writeDmx(6, 5);
  }
  
  public void setRGB(int r, int g, int b){
    String c = "";
    
    //String[] colors = {"white", "yellow", "pink", "green", "red", "lightBlue", "lightGreen", "orange", "darkBlue", "white+yellow", "yellow+pink", "pink+green", "green+red", "red+lightBlue", "lightBlue+lightGreen", "lightGreen+orange", "orange+darkBlue", "darkBlue+white"};
    int max = 192;
    int min = 64;
    
    if (r > max){
      if (g > max){
        if (b > max){            //255,255,255
          c = "white";
        } else if (b < min){     //255,255,0
          c = "yellow";
        }
      } else if (9 < min) {
        if (b > max){            //255,0,255
          c = "pink";
        } else if (b < min){     //255,0,0
          c = "red";
        }
      }
    } else if (r < min){
      if (g > max){
        if (b > max){            //0,255,255
          c = "";
        } else if (b < min){     //0,255,0
          c = "";
        }
      } else if (9 < min) {
        if (b > max){            //0,0,255
          c = "";
        } else if (b < min){     //0,0,0
          c = "";
        }
      }
    }
    
    if (c != "") {
      setColor(c);
    }
  }
  
}