public class Lamp {
  
  int[] functions;
  int[] currentValues;
  
  //tweening values
  int[] tweeningToValue;
  int[] lastTweeningUpdate;
  int[] tweeningTime;
  int[] tweeningDelta;
  
  //breathing values
  int minBreathingValue[];
  int maxBreathingValue[];
  int breathingDelta[];
  boolean breathing[];
  
  int startChannel;
  String name;
  boolean blackout = false;
  
  int CT_MIN = 2800;
  int CT_MAX = 5900;
  int CT_CENTER = CT_MIN + (CT_MAX - CT_MIN)/2;

  Lamp(){
    
  }

  //on (laatste waarde, zo niet, bri aan);
  //off
  //brigthness (laatste kleur, als nog geen kleur: wit);
  //colour temp
  //strobe
  
  //OFF
  public void blackOut(boolean bO){
    blackout = bO;
    if(bO){
      for(int i=0; i<functions.length; i++){
        writeDontSaveDmx(i, 0);
      }
    }else{
      for(int i=0; i<functions.length; i++){
        writeDontSaveDmx(i, currentValues[i]);
      }
    }
  }
  
  boolean failed = true;

  //RGB FUNCTIONS
  public void setRGB(int r, int g, int b){
    
    for(int i=0; i<functions.length; i++){
      if(functions[i]==RED){
        writeDmx(i, r);
      }else if(functions[i]==GREEN){
        writeDmx(i, g);
      }else if(functions[i]==BLUE){
        writeDmx(i, b);
      }
    }
    
    if (failed) error("setRGB");
  }
  public void adjustRGB(int deltaR, int deltaG, int deltaB){
    failed = true;

    for(int i=0; i<functions.length; i++){
      if(functions[i]==RED){
        writeDmx(i, (currentValues[i]+deltaR));
      }else if(functions[i]==GREEN){
        writeDmx(i, (currentValues[i]+deltaG));
      }else if(functions[i]==BLUE){
        writeDmx(i, (currentValues[i]+deltaB));
      }
    }
    
    if (failed) error("adjustRGB");
  }
  public int[] getRGB(){
    int[] rgb = new int[3];
    for(int i=0; i<functions.length; i++){
      if(functions[i]==RED){
        rgb[0] = currentValues[i];
      }else if(functions[i]==GREEN){
        rgb[1] = currentValues[i];
      }else if(functions[i]==BLUE){
        rgb[2] = currentValues[i];
      }
    }
    
    return rgb;
  }
  public void tweenRGB(int r, int g, int b, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==RED){
        setTween(i, r, time);  
      }else if(functions[i]==GREEN){
        setTween(i, g, time);  
      }else if(functions[i]==BLUE){
        setTween(i, b, time);  
      }
    }
  }
  
  public void setColor(String c){
    if (c=="white") setRGB(255,255,255);
    else if (c=="red") setRGB(255,0,0);
    else if (c=="green") setRGB(0,255,0);
    else if (c=="blue") setRGB(0,0,255);
    else if (c=="pink") setRGB(255,0,255);
    else if (c=="yellow") setRGB(255,255,0);
    else if (c=="orange") setRGB(255,156,0);
    else traceln("color "+c+" does not exist in setColor");
  }

  
  //BRIGHTNESS FUNCTIONS
  public void setBrightness(int bri){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
        writeDmx(i, bri);
      }
    }
    
    if (failed) error("setBrightness");

  }
  public void adjustBrightness(int deltaBri){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
         writeDmx(i, (currentValues[i]+deltaBri));
      }
    }
    if (failed) error("adjustBrightness");
  }
  public int getBrightness(){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
        return currentValues[i];
      }
    }return 0;
  }
  public void tweenBrightness(int bri, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==BRIGHTNESS){
        setTween(i, bri, time);
      }
    }
  }
  public void startBreathing(){
    startBreathing(0, 255, 4000);
  }
  public void startBreathing(int min, int max, int time){
    for(int i=0; i<functions.length; i++){
      minBreathingValue[i] = min;
      maxBreathingValue[i] = max;
      breathingDelta[i] = time/(max - min);
    
      if(functions[i]==BRIGHTNESS){
        setTween(i, max, (max-currentValues[i])*breathingDelta[i]);
        breathing[i] = true;
      }
    }
  }
  public void updateBreathing(int i){
    if(currentValues[i] == maxBreathingValue[i]){
      setTween(i, minBreathingValue[i], (currentValues[i]-minBreathingValue[i])*breathingDelta[i]);
    }else if(currentValues[i] == minBreathingValue[i]){
      setTween(i, maxBreathingValue[i], (maxBreathingValue[i]-currentValues[i])*breathingDelta[i]);
    }
  }
  public void stopBreathing(){
    for(int i=0; i<breathing.length; i++){
      breathing[i] = false;
    }
  }
    
    
    
  
  //CT FUNCTIONS
  public void setCT(int ct){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==CT){
        writeDmx(i, ct);
      }
    }
    if (failed) error("setCT");
  }
  public void adjustCT(int deltaCT){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==CT){
         writeDmx(i, (currentValues[i]+deltaCT));
      }
    }
    if (failed) error("adjustCT");
  }
  public int getCT(){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==CT){
        return currentValues[i];
      }
    }return 0;
  }
  public void tweenCT(int ct, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==CT){
        setTween(i, ct, time);
      }
    }
  }
  
  public void setCTinKelvin(int temp){
     
    int warmW = int(map(temp, CT_MIN, CT_CENTER, 255, 0));
    if (warmW < 0) warmW = 0;
    setWarm(warmW);
      
    int coolW = int(map(temp, CT_CENTER, CT_MAX, 0, 255));
    if (coolW < 0) coolW = 0;
    setCool(coolW);
  }
  
  public void adjustCTinKelvin(int deltaK){
    
    
    
    //updateWarm(deltaCT);
    //updateCool(deltaCT);
   
    
    traceln("werkt helaas nog niet, is erg moeilijk..");
  }
  
  public int getCTinKelvin(){
    int cWarm = 0;
    int cCool = 0;
    
    for(int i=0; i<functions.length; i++){
      if(functions[i]==WARM){
        cWarm = currentValues[i];
      }
      if(functions[i]==COOL){
        cCool = currentValues[i];
      }
    }
        
    int ct = int(map(cWarm * -1 + cCool,-255,0,CT_MIN,CT_MAX));
    
    return ct;
  }
  
  //warm
  public void setWarm(int w){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==WARM){
        writeDmx(i, w);
      }
    }
    if (failed) error("setWarm");
  }
  public void adjustWarm(int deltaW){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==WARM){
         writeDmx(i, (currentValues[i]+deltaW));
      }
    }
    if (failed) error("adjustWarm");
  }
  public int getWarm(){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==WARM){
        return currentValues[i];
      }
    }return 0;
  }
  public void tweenWarm(int w, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==WARM){
        setTween(i, w, time);
      }
    }
  }
  
  //cool
  public void setCool(int c){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==COOL){
        writeDmx(i, c);
      }
    }
    if (failed) error("setCool");
  }
  public void adjustCool(int deltaC){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==COOL){
         writeDmx(i, (currentValues[i]+deltaC));
      }
    }
    if (failed) error("adjustCool");
  }
  public int getCool(){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==COOL){
        return currentValues[i];
      }
    }return 0;
  }
  public void tweenCool(int c, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==COOL){
        setTween(i, c, time);
      }
    }
  }
  
  
  //STROBE FUNCTIONS
  public void setStrobe(int s){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==STROBE){
        writeDmx(i, s);
      }
    }
    if (failed) error("setStrobe");
  }
  public void adjustStrobe(int deltaS){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==STROBE){
         writeDmx(i, (currentValues[i]+deltaS));
      }
    }
    if (failed) error("adjustStrobe");
  }
  public int getStrobe(){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==STROBE){
        return currentValues[i];
      }
    }return 0;
  }
  public void tweenStrobe(int s, int time){
    for(int i=0; i<functions.length; i++){
      if(functions[i]==STROBE){
        setTween(i, s, time);
      }
    }
  }
  public void strobeOff(boolean sO){
      for(int i=0; i<functions.length; i++){
        if(functions[i]==STROBE){
          if(sO){
            writeDontSaveDmx(i, 0);
          }else{
            writeDontSaveDmx(i, currentValues[i]);
          }
        }
      }
  }
  
  
  //set the tween values to start the tween
  void setTween(int i, int value, int time){
    if(value - currentValues[i] != 0){
      traceln("i "+i+", value: "+value+", time:"+time);
      float tempTime = time/(value-currentValues[i]);
      tweeningDelta[i] = 1;
        
      if(tempTime<0){
        tweeningDelta[i] = -1;
        tempTime = abs(tempTime);
      }
      if(tempTime<1){
        tweeningDelta[i] = round(1/tempTime);
        tempTime = 1;
      }
      tweeningTime[i] = int(tempTime);
      traceln("tweeningTime "+i+": "+tweeningTime[i]);    
      tweeningToValue[i] = value;
    }
  }
  
  //stop all tweens at their current value
  void stopTweens(){
    for(int i=0; i<tweeningTime.length; i++){
      tweeningDelta[i] = 0;
      tweeningTime[i] = 0;
      tweeningToValue[i] = currentValues[i];
    }
  }
  
  //update all tween & breath functions 
  public void update(){ 
    //only update if not in blackout mode
    if(blackout == false){
      for(int i=0; i<tweeningTime.length; i++){
        //if i am currently tweening
        if(tweeningTime[i]>0){
          //if it is time to update the value again
          if (millis()-lastTweeningUpdate[i] >= tweeningTime[i]){
            traceln("i'm tweening: "+(currentValues[i]+tweeningDelta[i]));  
            writeDmx(i, (currentValues[i]+tweeningDelta[i]));
            lastTweeningUpdate[i] = millis();
            
            //if done tweening, reset time and delta, or restart breathing tween
            if(abs(currentValues[i]-tweeningToValue[i])<2){
              writeDmx(i, (tweeningToValue[i]));
              tweeningDelta[i] = 0;
              tweeningTime[i] = 0;
              traceln("i'm done tweening!");  
              
              //when breathing, start new tween (to min or max);
              if(breathing[i] == true){
                updateBreathing(i);
              }
            }
          }
        }
      }
    }
  }

  
  //write to the DMX and save the value
  void writeDmx(int i, int value){
    writeDontSaveDmx(i, value);
    currentValues[i] = value;
  }
  
  //write to the DMX but don't save the value
  void writeDontSaveDmx(int i, int value){
    if(value > 255){
      value = 255;
    }else if(value < 0){
      value = 0;
    }
    
    myPort.write(""+(startChannel+i)+"c"+value+"w");
    //traceln("send to DMX: c: "+(startChannel+i)+", w: "+value);
    
    failed = false;
  }
  
  
  void error(String function) {
    traceln(name+"does not understand "+ function + ". Try something else ;)");
    failed = true;
  }
}