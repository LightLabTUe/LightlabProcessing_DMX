//COLOUR TEMP (Kelvin values is missing. In lamp orin CTLEDWash?
//DIMMER speed missing. Eerst checken wat het doet
//ID ADDRESS select, function 7, is niet meegenomen in dit programma

public class CTLEDWash extends Lamp{
  
  int nrOfChannels = 7;
  
  CTLEDWash(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 7){
      functions = new int[6];
      functions[0] = BRIGHTNESS;
      functions[1] = COOL;
      functions[2] = WARM;
      functions[3] = CT;               //make CT with kelvin parameter value! not 0-255
      functions[4] = STROBE;
      //functions[5] = DIMMERSPEED;      //not functional yet.....
      
      currentValues = new int[6];
      tweeningToValue = new int[6];
      lastTweeningUpdate = new int[6];
      tweeningTime = new int[6];
      tweeningDelta = new int[6];
      breathing = new boolean[6];
      minBreathingValue = new int[6];
      maxBreathingValue = new int[6];
      breathingDelta = new int[6];
      stopBreathing(); //fill array with false
    }else{
      traceln("error: number of channels of "+name+" is incorrect");
    }
  }
  
  /* using MACROS
  public void setCTinKelvin(int temp){
    int min = 2800;
    int max = 5900;
    int step = 200;
    
    for (int i = min; i <= max; i += step){
      if (temp <= i && temp > i-step){
        setCT(30+30*((i-min)/step));
      }
    }
        
    if (temp < min){
      setCT(30);
    }
    
    if (temp >= max){
      setCT(255);
    }
  }*/
}