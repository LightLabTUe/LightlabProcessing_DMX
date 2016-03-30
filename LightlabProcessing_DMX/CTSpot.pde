//MACRO-COLOURS IS still missing

public class CTSpot extends Lamp{
  
  int nrOfChannels = 4;
  
  CTSpot(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 4){
      channels = new int[4];
      channels[0] = COOL;
      channels[1] = WARM;
      channels[2] = STROBE;
      channels[3] = MACRO;
      
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
  
  //OVERWRITES
  //Brightness & CT do not exist in CT spot
  //therefore the brightnesschannels from Lamp are overwritten here for CT spot functionality specific
  public void setBrightness(int bri){
    for(int i=0; i<channels.length; i++){
      if(channels[i]==COOL){
         writeDmx(i, bri);
      }else if(channels[i]==WARM){
         writeDmx(i, bri);
      }
    }
  }
  public void adjustBrightness(int deltaBri){
    for(int i=0; i<channels.length; i++){
      if(channels[i]==COOL){
         writeDmx(i, currentValues[i]+deltaBri);
      }else if(channels[i]==WARM){
         writeDmx(i, currentValues[i]+deltaBri);
      }
    }
  }
  public int getBrightness(){
    int averageBri = 0;
    for(int i=0; i<channels.length; i++){
      if(channels[i]==COOL){
         averageBri=averageBri+currentValues[i];
      }else if(channels[i]==WARM){
         averageBri=averageBri+currentValues[i];
      }
    }return averageBri;
  }
  
  //color temperature
  public void adjustCT(int deltaCT){
    for(int i=0; i<channels.length; i++){
      if(channels[i]==COOL){
         writeDmx(i, (currentValues[i]+deltaCT));
      }else if(channels[i]==WARM){
         writeDmx(i, (currentValues[i]-deltaCT));
      }
    }
  }
  
}