import javax.swing.JOptionPane;
import javax.swing.JFileChooser;
import java.io.File;
import java.awt.*;
import java.awt.event.KeyEvent;

PresetManager pm = new PresetManager("presets.xml");

final JFileChooser fc        =  new JFileChooser();

//if key is pressed
void keyPressed(KeyEvent e){
  // CTRL + ...
  if ((e.getModifiers() & KeyEvent.CTRL_MASK) != 0) {
    //CTRL+L to load a preset
    if (e.getKeyCode() == KeyEvent.VK_L){
      loadPresetPane();
    }
    //CTRL+S to save a preset
    else if (e.getKeyCode() == KeyEvent.VK_S){
      saveNewPresetPane();
    } 
    //CTRL+R to remove a preset
    else if (e.getKeyCode() == KeyEvent.VK_R){
      removePresetPane();
    }
  }
}


//try to load the preset pain and to load the selected preset.
void loadPresetPane() {
  //Trow error if it didn't work out
  try {
    XML[] presets = this.getPresetManager().getPresets();
    Object[] possibleValues = new Object[presets.length];
    for (int i = 0; i < possibleValues.length; i++)
    {
      possibleValues[i] = presets[i].getString("name", "Undefined Preset");
    }
    Object selectedValue = JOptionPane.showInputDialog(null, "Choose one", "Input", JOptionPane.INFORMATION_MESSAGE, null, possibleValues, possibleValues[0]);
    
    //if a preset is selected, load that preset. If not, trace error message
    if ( selectedValue == null ){
      traceln("ERROR: no preset selected");
    } else {
      this.loadPreset( (String)selectedValue );
    }
  } catch (Exception err){
    JOptionPane.showMessageDialog(null, "Preset Load Failed \n Did you select the correct grid?", "Preset Load Failed", JOptionPane.ERROR_MESSAGE);
    traceln("ERROR in PRESET LOADING: " + err);
  }
}
//get the preset from the XML document
public void loadPreset ( String name ){
  XML preset = this.getPresetManager().getPreset(name);
  if (preset != null){
    this.applyPreset(preset);
  }
}
//apply the given preset in the Lightlab
public void applyPreset( XML preset ){
  // update the settings of the lights that we found in the preset
  XML rgb[]  =  preset.getChildren("RGBSpot");
  for (int i = 0; i < rgb.length; i++){
    XML currentValues[] = rgb[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<rgbSpots.size()){
      for(int j=0; j<currentValues.length; j++){
        rgbSpots.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML ct[]  =  preset.getChildren("CTSpot");
  for (int i = 0; i < ct.length; i++){
    XML currentValues[] = ct[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<ctSpots.size()){
      for(int j=0; j<currentValues.length; j++){
        ctSpots.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML came[]  =  preset.getChildren("Cameleon");
  for (int i = 0; i < came.length; i++){
    XML currentValues[] = came[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<cameleons.size()){
      for(int j=0; j<currentValues.length; j++){
        cameleons.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML ctled[]  =  preset.getChildren("CTLEDWash");
  for (int i = 0; i < ctled.length; i++){
    XML currentValues[] = ctled[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<ctLedWashers.size()){
      for(int j=0; j<currentValues.length; j++){
        ctLedWashers.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML sun[]  =  preset.getChildren("SunStrip");
  for (int i = 0; i < sun.length; i++){
    XML currentValues[] = sun[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<sunStrips.size()){
      for(int j=0; j<currentValues.length; j++){
        sunStrips.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML nar[]  =  preset.getChildren("NarrowSpot");
  for (int i = 0; i < nar.length; i++){
    XML currentValues[] = nar[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<narrowSpots.size()){
      for(int j=0; j<currentValues.length; j++){
        narrowSpots.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML str[]  =  preset.getChildren("Strobe");
  for (int i = 0; i < str.length; i++){
    XML currentValues[] = str[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<strobes.size()){
      for(int j=0; j<currentValues.length; j++){
        strobes.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }
  XML mh[]  =  preset.getChildren("MovingHead");
  for (int i = 0; i < mh.length; i++){
    XML currentValues[] = mh[i].getChild("currentValues").getChildren("cv");
    if (currentValues != null && i<movingheads.size()){
      for(int j=0; j<currentValues.length; j++){
        movingheads.get(i).writeDmx(currentValues[j].getInt("index"), currentValues[j].getInt("value"));
      }
    }
  }

  traceln("preset loaded");
}


//called when CTRL+S is selected
void saveNewPresetPane() {
  try {
    //load a input window to ask for a preset name 
    String name = JOptionPane.showInputDialog("Enter preset name");
    if ( name != null && name != "" ){
      saveNewPreset( name );
    }else{
      traceln("please put in a preset name");
    }
  } catch (Exception err){
    JOptionPane.showMessageDialog(null, "Preset Save Failed", "Preset Save Failed", JOptionPane.ERROR_MESSAGE);
    traceln("ERROR in PRESET SAVE: " + err);
  }
}
//save a preset at the next available preset id
public void saveNewPreset ( String name ){
  //add a preset to the XML document
  savePreset( name, this.getPresetManager().getFreePresetId() );
}
//save a preset given a preset id
public void savePreset( String name, int id){
  XML presetXML =  new XML("preset");  
  
  presetXML.setInt( "id", this.getPresetManager().getFreePresetId() );
  presetXML.setString( "name", name );
  
  //TODO! add the values of every lamp to the preset
  for (int i=0;i < rgbSpots.size() ; i++){
    XML rgbXML  =  new XML("RGBSpot");
    rgbXML.setString( "name", rgbSpots.get(i).name );
    rgbXML.addChild( createXMLfromArray(rgbSpots.get(i).currentValues) );
    presetXML.addChild( rgbXML );
  }
  for (int i=0;i < ctSpots.size() ; i++){
    XML ctXML  =  new XML("CTSpot");
    ctXML.setString( "name", ctSpots.get(i).name );
    ctXML.addChild( createXMLfromArray(ctSpots.get(i).currentValues) );
    presetXML.addChild( ctXML );
  }
  for (int i=0;i < cameleons.size() ; i++){
    XML cameleonsXML  =  new XML("Cameleon");
    cameleonsXML.setString( "name", cameleons.get(i).name );
    cameleonsXML.addChild( createXMLfromArray(cameleons.get(i).currentValues) );
    presetXML.addChild( cameleonsXML );
  }
  for (int i=0;i < ctLedWashers.size() ; i++){
    XML ctLedWashersXML  =  new XML("CTLEDWash");
    ctLedWashersXML.setString( "name", ctLedWashers.get(i).name );
    ctLedWashersXML.addChild( createXMLfromArray(ctLedWashers.get(i).currentValues) );
    presetXML.addChild( ctLedWashersXML );
  }
  for (int i=0;i < sunStrips.size() ; i++){
    XML sunStripsXML  =  new XML("SunStrip");
    sunStripsXML.setString( "name", sunStrips.get(i).name );
    sunStripsXML.addChild( createXMLfromArray(sunStrips.get(i).currentValues) );
    presetXML.addChild( sunStripsXML );
  }
  for (int i=0;i < narrowSpots.size() ; i++){
    XML narrowSpotsXML  =  new XML("NarrowSpot");
    narrowSpotsXML.setString( "name", narrowSpots.get(i).name );
    narrowSpotsXML.addChild( createXMLfromArray(narrowSpots.get(i).currentValues) );
    presetXML.addChild( narrowSpotsXML );
  }
  for (int i=0;i < strobes.size() ; i++){
    XML strobesXML  =  new XML("Strobe");
    strobesXML.setString( "name", strobes.get(i).name );
    strobesXML.addChild( createXMLfromArray(strobes.get(i).currentValues) );
    presetXML.addChild( strobesXML );
  }
  for (int i=0;i < movingheads.size() ; i++){
    XML movingheadsXML  =  new XML("MovingHead");
    movingheadsXML.setString( "name", movingheads.get(i).name );
    movingheadsXML.addChild( createXMLfromArray(movingheads.get(i).currentValues) );
    presetXML.addChild( movingheadsXML );
  }

  this.getPresetManager().savePreset( presetXML );
  traceln("preset saved");
}

public XML createXMLfromArray(int[] cv){
  XML lightXML = new XML("currentValues");
  for(int i=0; i < cv.length; i++){
      XML cvXML  =  new XML("cv");
      cvXML.setInt("index", i);
      cvXML.setInt("value", cv[i]);
      lightXML.addChild(cvXML);
    }
  return lightXML;
}
  

//TODO: overwrite? (or put standard in SAVE?)
void removePresetPane()
{
  try 
  {
    if (this.getPresetManager().getCurrentPresetId() != PresetManager.NO_PRESET_SELECTED){
      String presetName = this.getPresetManager().getPresetNameByID( this.getPresetManager().getCurrentPresetId() );
      String overWriteQuestion = "Remove " + presetName + "?";
      int overwrite  =  JOptionPane.showConfirmDialog(null, overWriteQuestion, "Remove?", JOptionPane.YES_NO_OPTION);
      if ( overwrite == 0 ){
        this.getPresetManager().removeCurrentPreset();
        JOptionPane.showMessageDialog(null, "Preset Removed", "Removed", JOptionPane.INFORMATION_MESSAGE);
      }
    }else{
      JOptionPane.showMessageDialog(null, "No Preset Selected", "No Preset Selected", JOptionPane.ERROR_MESSAGE);
    }
  }
  catch (Exception err){
    traceln("ERROR in PRESET REMOVE: " + err);
  }
}


//returns the preset manager
public PresetManager getPresetManager(){
  return pm;
}


public class PresetManager{
  public String DEFAULT_PRESET_FILE = "LightPresets.xml";
  
  public static final int     NO_PRESET_SELECTED      = -1;
  private int _currentPresetId = NO_PRESET_SELECTED;
  
  //constructors
  public PresetManager( ){
  }
  public PresetManager( String presetFile ){
    DEFAULT_PRESET_FILE = presetFile;
  }
  
  //save a preset (with or without specifying the destination preset XML file)
  public boolean savePreset( XML lightPreset ){
    return this.savePreset(lightPreset, DEFAULT_PRESET_FILE);
  }
  public boolean savePreset( XML lightPreset, String presetfile ){
    boolean success  =  false;
    traceln( "savePreset(): Writing to file "+presetfile );
        
    // Get the new ID for various tests below
    int presetId = lightPreset.getInt("id", -1);
    
    //if the file exists and is of the correct type...
    if( presetfile != null || !presetfile.equals("") ){  
      if( !( presetfile.endsWith(".xml") || presetfile.endsWith(".XML") ) ){
        presetfile  += ".xml";
      }
      // ...get all the current presets
      XML completeFile  =  loadXML(presetfile);
      // Check if the ID is not yet taken; if it is, overwrite
      if ( presetIdIsFree( presetId ) ){ 
        // Not taken, so append the file
        completeFile.addChild( lightPreset );
      }else{
        // OVERWRITE EXISTING 
        completeFile.removeChild( this.getPresetById( presetId ) );
        completeFile.addChild( lightPreset );
      }
 
      try{
        // Actually write the file
        completeFile.write( createWriter( presetfile ) );
        success  =  true;
      }catch( Exception e ){
        traceln("Something went wrong when trying to save the light preset to XML: "+e);
        success  =  false;
      }
    }
    setCurrentPresetId( presetId );
    return success;
  }
  //remove a preset from the file !!!!!ERROR does not work yet....!!!!
  public boolean removeCurrentPreset(){
    return removePreset(getPresetById(getCurrentPresetId()), DEFAULT_PRESET_FILE);
  }
  public boolean removePreset( XML lightPreset, String presetfile ){
    boolean success  =  false;
    traceln( "removePreset(): Writing to file "+presetfile );
    if( presetfile != null || !presetfile.equals("") ){  
      if( !( presetfile.endsWith(".xml") || presetfile.endsWith(".XML") ) ){
        presetfile  += ".xml";
      }
      // Get the current presets
      XML completeFile  =  loadXML(presetfile );
      // Actually remove it !!!! ERROR IS HERE!!!
      completeFile.removeChild(lightPreset); 
      traceln("remove");
      try{
        // Actually write the file
        completeFile.write( createWriter( presetfile ) );
        success  =  true;
      }catch( Exception e ){
        traceln("Something went wrong when trying to remove the light preset from XML: "+e);
        success  =  false;
      }
    }
    setCurrentPresetId( NO_PRESET_SELECTED );
    return success;
  }
  
  
  public void setCurrentPresetId( int i ){
    _currentPresetId = i;
  }
  public int getCurrentPresetId( ){
    return _currentPresetId;
  }
  
  //return the number of presets in the file (can be called with or wihtout the file name)
  public int getNumberOfPresets( ){
    return this.getNumberOfPresets(DEFAULT_PRESET_FILE);
  }
  public int getNumberOfPresets( String presetfile ){
    XML completeFile  =  loadXML(presetfile );
    return completeFile.getChildCount();
  }
  
  //returns the XML preset (can be called with or without file name)
  public XML getPresetById( int presetNumber ){
    return this.getPresetById( DEFAULT_PRESET_FILE, presetNumber );
  }
  public XML getPresetById( String presetfile, int presetnumber ){
    XML preset = null;
    
    XML completeFile  =  loadXML( presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    for( int i=0; i<allPresets.length; i++ ){
      //Check if the id of the preset matches the presetnumber. If no id is specified in the XML, we return -1.
      if( allPresets[i].getInt("id", -1) == presetnumber ){
        preset = allPresets[i];
        break;
      }
    }
    return preset;
  }
  
  public XML[] getPresets(){
    XML completeFile  =  loadXML( DEFAULT_PRESET_FILE );
    XML allPresets[]  =  completeFile.getChildren("preset");

    return completeFile.getChildren("preset");
  }
  
  public String[] getPresetNames(){
    traceln("Getting list of preset names... ");
    XML allPresets[]  =  this.getPresets();
    String presetNames[] = new String[allPresets.length];
    
    for( int i=0; i<allPresets.length; i++ ){
      presetNames[i] = allPresets[i].getString("name", "Preset " + i);
      traceln("Found preset " + presetNames[i]);
    }
    return presetNames;
  }
  
  public XML getPreset( String presetName ){
    return this.getPreset(DEFAULT_PRESET_FILE, presetName);
  }
  public XML getPreset( String presetfile, String presetName ){
    XML preset = null;
    
    XML completeFile  =  loadXML(  presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    for( int i=0; i<allPresets.length; i++ ){
      //Check if the id of the preset matches the presetnumber. If no id is specified in the XML, we return -1.
      if( allPresets[i].getString("name", "noName").equals( presetName ) )
      {
        traceln("Found a match for preset \""+ presetName +"\" in preset "+i);
        preset = allPresets[i];
        break;
      }
    }
    if(preset != null){   
      setCurrentPresetId( preset.getInt("id", -1) );
    }
    return preset;
  }
  
  public XML getAllPresets( ) {
    return getAllPresets( DEFAULT_PRESET_FILE );
  }
  public XML getAllPresets( String presetfile ){
    XML completeFile  =  loadXML( presetfile );
    return completeFile;
  }

  public String getPresetNameByID( int presetId ){
    return this.getPresetNameByID(DEFAULT_PRESET_FILE, presetId);
  }
  public String getPresetNameByID( String presetfile, int presetId ){
    XML preset = null;
    
    XML completeFile  =  loadXML( presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    for( int i = 0; i < allPresets.length; i++ ){
      //Check if the id of the preset matches the presetnumber. If no id is specified in the XML, we return -1.
      if( allPresets[i].getInt("id", -1) == presetId ) {
        preset = allPresets[i];
        break;
      }
    }
    return preset.getString("name", "Nameless Preset");
  }
  
  public String getPresetName( int presetNumber ){
    return this.getPresetName(DEFAULT_PRESET_FILE, presetNumber);
  }
  
  public String getPresetName( String presetfile, int presetNumber ){
    XML completeFile  =  loadXML( presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    if ( presetNumber >= 0 && presetNumber < allPresets.length ) {
      return allPresets[presetNumber].getString("name", "Nameless Preset");
    }else{
      return "Invalid Presetnumber";
    }
  }
  
  public boolean presetIdIsFree( int presetNumber ){
    return this.presetIdIsFree(DEFAULT_PRESET_FILE, presetNumber);
  }
  public boolean presetIdIsFree( String presetfile, int presetnumber ){
    boolean free = true;
    XML completeFile  =  loadXML( presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    for( int i=0; i<allPresets.length; i++ )
    {
      //Check if the id of the preset matches the presetnumber.
      if( allPresets[i].getInt("id", -1) == presetnumber )
      {
        free = false;
        break;
      }
    }
    return free;
  }
  
  public int getFreePresetId( ){
    return this.getFreePresetId( DEFAULT_PRESET_FILE );
  }
  public int getFreePresetId( String presetfile ){
    boolean foundFreeId = false;
    int freeId = 0;
    XML completeFile  =  loadXML(presetfile );
    XML allPresets[]  =  completeFile.getChildren("preset");
    
    while (!foundFreeId){
      boolean success = true;
      for( int i=0; i<allPresets.length; i++ ){
        if( allPresets[i].getInt("id", -1) == freeId ){
          success = false;
          break;
        }
      }
      if (!success){
        freeId ++;
      }else{
        foundFreeId = true;
      }
    }
    return freeId;
  }
  
}

