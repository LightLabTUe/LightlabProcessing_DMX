//function defines 
final int BRIGHTNESS = 1;
final int RED = 2;
final int GREEN = 3;
final int BLUE = 4;
final int COOL = 5;
final int WARM = 6;
final int STROBE = 7;
final int MACRO = 8;
final int CT = 9;
final int PANNING = 10;
final int TILTING = 11;
final int COLORS = 12;

String[] channelNames = new String[] {
"BRIGHTNESS",
"RED",
"GREEN",
"BLUE",
"COOL",
"WARM",
"STROBE",
"MACRO",
"CT",
"PANNING",
"TILTING",
"COLORS"
};

//initialize all lamp ArrayLists
ArrayList<RGBSpot> rgbSpots = new ArrayList<RGBSpot>();
ArrayList<CTSpot> ctSpots = new ArrayList<CTSpot>();
ArrayList<Cameleon> cameleons = new ArrayList<Cameleon>();
ArrayList<CTLEDWash> ctLedWashers = new ArrayList<CTLEDWash>();  
ArrayList<NarrowSpot> narrowSpots = new ArrayList<NarrowSpot>();
ArrayList<SunStrip> sunStrips = new ArrayList<SunStrip>();
ArrayList<Strobe> strobes = new ArrayList<Strobe>();
ArrayList<MovingHead> movingheads = new ArrayList<MovingHead>();


//function to initialize the lightLAB setup
//change the channels if needed!
void initLightLab(){
  final int[] RGBSPOT_CHANNELS = {1,5,9,13,17,21};
  final int[] CTSPOT_CHANNELS = {33,37,41,45};
  final int[] CAMELEON_CHANNELS = {81,86,91,81};
  final int[] CTLEDWASH_CHANNELS = {49,57,65,73,49,73};
  final int[] SUNSTRIP_CHANNELS = {97,113};
  final int[] NARROWSPOT_CHANNELS = {177};
  final int[] STROBE_CHANNELS = {129};
  final int[] MOVINGHEAD_CHANNELS = {145,161};

  //RGB Spots
  for (int i = 0; i<RGBSPOT_CHANNELS.length; i++){
    rgbSpots.add(new RGBSpot(RGBSPOT_CHANNELS[i], ("RGBSPOT"+i+1)));
  }
  
  //CT Spots
  for (int i = 0; i<CTSPOT_CHANNELS.length; i++){
    ctSpots.add(new CTSpot(CTSPOT_CHANNELS[i], ("CTSPOT"+i+1)));
  }
  
  //Cameleon
  for (int i = 0; i<CAMELEON_CHANNELS.length; i++){
    cameleons.add(new Cameleon(CAMELEON_CHANNELS[i], ("CAMELEON"+i+1)));
  }
  
  //CT LED WASHERS
  for (int i = 0; i<CTLEDWASH_CHANNELS.length; i++){
    ctLedWashers.add(new CTLEDWash(CTLEDWASH_CHANNELS[i], ("CTLEDWASH"+i+1)));
  }
  
  //Sunstrips
  for (int i = 0; i<SUNSTRIP_CHANNELS.length; i++){
    sunStrips.add(new SunStrip(SUNSTRIP_CHANNELS[i], ("SUNSTRIP"+i+1)));
  }
  
  //NarrowSpot
  for (int i = 0; i<NARROWSPOT_CHANNELS.length; i++){
    narrowSpots.add(new NarrowSpot(NARROWSPOT_CHANNELS[i], ("SNARROWSPOT"+i+1)));
  }
  
  //Strobes
  for (int i = 0; i<STROBE_CHANNELS.length; i++){
    strobes.add(new Strobe(STROBE_CHANNELS[i], ("STROBE"+i+1)));
  }
  
  //MovingHeads
  for (int i = 0; i<MOVINGHEAD_CHANNELS.length; i++){
    movingheads.add(new MovingHead(MOVINGHEAD_CHANNELS[i], ("MOVINGHEAD"+i+1)));
  }
}

//blackout all lamps
void blackout(boolean bo) {
  for (int i=0;i < rgbSpots.size() ; i++){
       rgbSpots.get(i).blackOut(bo);
    }
    for (int i=0;i < ctSpots.size() ; i++){
      ctSpots.get(i).blackOut(bo);
    }
    for (int i=0;i < cameleons.size() ; i++){
      cameleons.get(i).blackOut(bo);
    }
    for (int i=0;i < ctLedWashers.size() ; i++){
      ctLedWashers.get(i).blackOut(bo);
    }
    for (int i=0;i < sunStrips.size() ; i++){
      sunStrips.get(i).blackOut(bo);
    }
    for (int i=0;i < narrowSpots.size() ; i++){
      narrowSpots.get(i).blackOut(bo);
    }
    for (int i=0;i < strobes.size() ; i++){
      strobes.get(i).blackOut(bo);
    }
     for (int i=0;i < movingheads.size(); i++){
      movingheads.get(i).blackOut(bo);
    }
 }