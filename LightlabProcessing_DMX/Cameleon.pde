public class Cameleon extends Lamp{
  
  int nrOfChannels = 5;
  
  Cameleon(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 5){
      channels = new int[5];
      channels[0] = RED;
      channels[1] = GREEN;
      channels[2] = BLUE;
      channels[3] = BRIGHTNESS;
      channels[4] = STROBE;   
      
      currentValues = new int[5];
      tweeningToValue = new int[5];
      lastTweeningUpdate = new int[5];
      tweeningTime = new int[5];
      tweeningDelta = new int[5];
      breathing = new boolean[5];
      minBreathingValue = new int[5];
      maxBreathingValue = new int[5];
      breathingDelta = new int[5];
      stopBreathing(); //fill array with false
    }else{
      traceln("error: number of channels of "+name+" is incorrect");
    }
  }
  
  public void setCTinKelvin(int kelvin){
    int temp = kelvin / 100;
    float r, g, b;

    if( temp <= 66 ){ 
        r = 255; 
        g = temp;
        g = 99.4708025861 * log(g) - 161.1195681661;
        if( temp <= 19){
            b = 0;
        } else {
            b = temp-10;
            b = 138.5177312231 * log(b) - 305.0447927307;
        }
    } else {
        r = temp - 60;
        r = 329.698727446 * pow(r, -0.1332047592);
        g = temp - 60;
        g = 288.1221695283 * pow(g, -0.0755148492 );
        b = 255;
    }
    
    setRGB(int(r),int(g),int(b));
  }
}