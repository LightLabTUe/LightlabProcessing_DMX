public class Strobe extends Lamp{
  
  int nrOfChannels = 6;
  
  Strobe(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 6){
      channels = new int[6];
      channels[0] = BRIGHTNESS;    //bottomright
      channels[1] = BRIGHTNESS;    //bottomleft
      channels[2] = BRIGHTNESS;    //upperright
      channels[3] = BRIGHTNESS;    //upperleft
      channels[4] = BRIGHTNESS;    //master
      channels[5] = STROBE;
      
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
  
  
  //OVERWRITES
  //brightness per lamp if a lamp index is send along. 
  //If no index is send, brightness is adjusted for quarters in the strobe equally (see Lamp)
  public void setBrightness(int bri, int index){
    if(channels[index]==BRIGHTNESS){
      writeDmx(index, bri);
    }
  }
  public void adjustBrightness(int deltaBri, int index){
    if(channels[index]==BRIGHTNESS){
       writeDmx(index, (currentValues[index]+deltaBri));
    }
  }
  public int getBrightness(int index){
    if(channels[index]==BRIGHTNESS){
      return currentValues[index];
    }return 0;
  }
  public void tweenBrightness(int bri, int time, int index){
    if(channels[index]==BRIGHTNESS){
      setTween(index, bri, time);
    }
  }
  public void startBreathing(int min, int max, int time, int index){
    if(channels[index]==BRIGHTNESS){
      minBreathingValue[index] = min;
      maxBreathingValue[index] = max;
      breathingDelta[index] = time/(max - min);
      setTween(index, max, (max-currentValues[index])*breathingDelta[index]);
      breathing[index] = true;
    }
  }
}
