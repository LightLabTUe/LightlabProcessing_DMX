public class NarrowSpot extends Lamp{
  
  int nrOfChannels = 4;
  String[] colors = {"white", "blue", "yellow", "pink", "green", "red", "lightBlue", "orange"};
  
  NarrowSpot(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 4){
      functions = new int[4];
      functions[0] = BRIGHTNESS;
      functions[1] = COLORS;
      functions[2] = STROBE;
      //functions[3] = FUNCTION;
      
      currentValues = new int[4];
      tweeningToValue = new int[4];
      lastTweeningUpdate = new int[4];
      tweeningTime = new int[4];
      tweeningDelta = new int[4];
      breathing = new boolean[4];
      minBreathingValue = new int[4];
      maxBreathingValue = new int[4];
      breathingDelta = new int[4];
      stopBreathing(); //fill array with false
    }else{
      traceln("error: number of channels of "+name+" is incorrect");
    }
    
  }
  
  public void setBrightness(int bri){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
        writeDmx(i, bri);
      }
    }
    
    if (bri > 0) writeDmx(2, 5);
  }
  
  public void setColor(String c){
    for (int i=0; i<colors.length-1; i++){
      if(c.equals(colors[i])){
        writeDmx(1, (i*7)+7);
        break;
      }
    }
    //      traceln("the color " + c + " doesn't exist in Narrowspot");
  }
  public void setColor(int c){
     writeDmx(1, (c*7)+7);
  }
  
  
  public void setRGB(int r, int g, int b){
    String c = "";
    
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
          c = "green";
        }
      } else if (9 < min) {
        if (b > max){            //0,0,255
          c = "blue";
        }
      }
    }
    
    if (c != "") {
      setColor(c);
    }
  }
  
}