public class RGBSpot extends Lamp{
  
  int nrOfChannels = 4;
  
  RGBSpot(int sC, String n){
    startChannel = sC;
    name = n;
    
    //for now only the four channel mode is defined
    if(nrOfChannels == 4){
      functions = new int[4];
      functions[0] = BRIGHTNESS;
      functions[1] = RED;
      functions[2] = GREEN;
      functions[3] = BLUE;
      
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
  
  //NIET GOED GECONVERTEERD
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