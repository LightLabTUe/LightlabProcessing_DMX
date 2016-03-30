public class SunStrip extends Lamp{
  
  int nrOfChannels = 10;
  
  SunStrip(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 10){
      channels = new int[10];
      for(int i=0; i<channels.length; i++){
        channels[i] = BRIGHTNESS;
      }
      currentValues = new int[10];
      tweeningToValue = new int[10];
      lastTweeningUpdate = new int[10];
      tweeningTime = new int[10];
      tweeningDelta = new int[10];
      breathing = new boolean[10];
      minBreathingValue = new int[10];
      maxBreathingValue = new int[10];
      breathingDelta = new int[10];
      stopBreathing(); //fill array with false
    }else{
      traceln("error: number of channels of "+name+" is incorrect");
    }
  }
  
  //write different animation channels for the SunStrips
  public void chase(int speed){ 

  }
  
  
  //OVERWRITES
  //brightness per lamp if a lamp index is send along. 
  //If no index is send, brightness is adjusted for all lamps in the sunstrip equally (see Lamp)
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
