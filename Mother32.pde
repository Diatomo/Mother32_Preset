
//Assets
PImage overlay;
PImage swUp;
PImage swDown;
Mother mother;

void setup(){
  size(1312,559);//dimension of image
  frameRate(120);
  //assets
  overlay = loadImage("overlay.png");
  swUp = loadImage("switch_up.png");
  swDown = loadImage("switch_down.png");
  //main object
  mother = new Mother();
  mother.init();
}


void mouseReleased(){
  if (mother.activeSwtch != null){
    mother.activeSwtch = null;
  }
  if (mother.activeKnob != null){
    mother.activeKnob = null;
  }
}

void mouseDragged(){
  if (mother.activeKnob != null){
    mother.activeKnob.turn();
  } 
}



//===========================================
//UTILITY CLASSES 
class BoundingBox{
  
  float right,left,bot,top;
  BoundingBox(float x, float y, float w, float h){
    right = x + w;
    left = x - w;
    bot = y + h;
    top = y - h;
  }

  public void renderCollide(){
    line(this.right, this.bot, this.right, this.top); //right side
    line(this.right, this.top, this.left, this.top);  //top side
    line(this.left, this.bot, this.left, this.top); // left side
    line(this.left, this.bot, this.right, this.bot); //bottom side;
  }

  public boolean collision(float cursorX, float cursorY){
    boolean collide = false;
    
    if (cursorX < this.right && cursorX > this.left && 
        cursorY > this.top && cursorY < this.bot){
        collide = true;
    }
   
    return collide;
  }

}

class Chrono{

  private boolean active;
  private float alarm, counter;
  Chrono(){
    active = false;
    alarm = 0;
    counter = 0;
  }

  public boolean isSet(){
    return active; 
  }

  public void setAlarm(float time){
    if (!this.active){
      alarm = time;
      counter = millis();
      active = true;
    }
  }

  public boolean poll(){
    boolean trigger = false;
    if (this.active){
      float currTime = millis();
      if (currTime - counter > alarm){
        trigger = true;
        this.resetClk();
      }
    }
    return trigger;
  }

  private void resetClk(){
    active = false;
    alarm = 0;
    counter = 0;
  }
}

//===========================================
/*
 *
 *  class :: Switches
 *
 *  container class for the switch images
 *  and asset animations
 */
class Switch{

  //attributes
  PImage img;
  boolean state;
  float posX, posY;
  float alarmTime;
  boolean animation, isSet;
  BoundingBox bb;
  Chrono alarm;
  //constructor
  Switch(float x,float y){
    //defaults
    float w = 25;//bounding box width
    float h = 25;//bounding box height
    state = false;//sprite toggle {up || down}
    //objects
    bb = new BoundingBox(x,y,w,h);
    alarm = new Chrono();
    //attributes
    img = swDown;
    posX = x;
    posY = y;
  }

  /*
   *  fxn :: switchState
   *    When left click it changes the state
   *    and renders a different image
   */
  private void switchState(){
      state = !state;
      if (state){
        img = swUp;
      }
      else{
        img = swDown;
      }
    }

  /*
   *  fxn :: render
   *    renders the image
   *    assigned by the state
   */
  public void render(){
    image(img, this.posX, this.posY);
  }
}
//===========================================

//===========================================
/*
 *
 *  class : Knobs 
 *
 *  Container class for the knobs
 *  renders a line that can spin around
 *  the center.
 */
class Knob{

  float posX, posY;
  float radius;
  float angle;
  float currMouse, prevMouse;
  boolean active;
  BoundingBox bb;
  Knob(float x, float y){
    float w = 50; //bounding box width
    float h = 50; //bounding box height
    angle = 270;//default angle degrees {0,360}
    radius = 28;//radius length :: hardcoded
    bb = new BoundingBox(x,y,w,h);
    posX = x;
    posY = y;
  }

  public void setMousePos(){
    this.currMouse = mouseY;
  }
  
  public void turn(){
    float incr = 5;
    this.setMousePos();
    if (currMouse - prevMouse > 0){
      angle += incr % 360;
      prevMouse = currMouse;
    }
    else if (currMouse - prevMouse < 0){
      angle -= incr % 360;
      prevMouse = currMouse;

    }
  }

  public void render(){
    float posXrot = this.posX + cos(radians(this.angle)) * this.radius;
    float posYrot = this.posY + sin(radians(this.angle)) * this.radius;
    line(this.posX, this.posY, posXrot, posYrot);
  }
}
//===========================================

//===========================================



//===========================================



//===========================================
class Mother{

  ArrayList<Switch> switches = new ArrayList<Switch>();
  ArrayList<Knob> knobs = new ArrayList<Knob>();
  Switch vcoWave, vcoModSrc, vcoModDest, vcfMode, vcfModSrc, polarity, vcaMode, lfoWave, sustain;
  Knob frequency, pulseWidth, mix, cutoff, resonance, volume, glide, vcoMod, vcfMod, tempo, lfoRate, attack, decay, vcMix;
  Switch activeSwtch;
  Knob activeKnob;

  //constructor
  Mother(){
    activeSwtch = null;
    activeKnob = null;
  }

  void init(){

    int numSwitches = 9;
    int numKnob = 14;
    float[] switchX = {242,879,242,487,606,727,970,485,720};
    float[] switchY = {87,87,208,208,208,208,208,329,329};
    float[] knobX = {120,363,483,629,775,970,120,363,848,199,364,606,849,970};
    float[] knobY = {85,85,85,85,85,85,205,205,205,327,328,327,325,326};
    

    for (int i = 0; i < numSwitches; i++){
      Switch temp = new Switch(switchX[i], switchY[i]);
      this.switches.add(temp);  
    }

    /*
    //switches row 1 :: hardcoded coordinates
    this.vcoWave = new Switch(242, 87);
    this.vcaMode = new Switch(879, 87);
    //switches row 2 :: hardcoded coordinates
    this.vcoModSrc = new Switch(242, 208);
    this.vcoModDest = new Switch(487, 208);
    this.vcfMode = new Switch(606, 208);
    this.vcfModSrc = new Switch(727, 208);
    this.polarity = new Switch(970, 208);
    //switches row 3 :: hardcoded coordinates
    this.lfoWave = new Switch(485, 329);
    this.sustain = new Switch(728, 328);
    
    //knob row 1 :: hardcoded coordinates
    this.frequency = new Knob(120, 85);
    this.pulseWidth = new Knob(363, 85);
    this.mix = new Knob(483, 85);
    this.cutoff = new Knob(629, 85);
    this.resonance = new Knob(775, 85);
    this.volume = new Knob(970, 85);
    //knob row 2 :: hardcoded coordinates
    this.glide = new Knob(120, 205);
    this.vcoMod = new Knob(363, 205);
    this.vcfMod = new Knob(848, 205);
    //knob row 3 :: hardcoded coordinates
    this.tempo = new Knob(199, 327);
    this.lfoRate = new Knob(364, 328);
    this.attack = new Knob(606, 327);
    this.decay = new Knob(849, 325);
    this.vcMix = new Knob(970, 326);
    */

    //switches
    this.switches.add(this.vcoWave);
    this.switches.add(this.vcaMode);
    this.switches.add(this.vcoModSrc);
    this.switches.add(this.vcoModDest);
    this.switches.add(this.vcfMode);
    this.switches.add(this.vcfModSrc); 
    this.switches.add(this.polarity);
    this.switches.add(this.lfoWave);
    this.switches.add(this.sustain);
    //knobs
    this.knobs.add(this.frequency);
    this.knobs.add(this.pulseWidth);
    this.knobs.add(this.mix);
    this.knobs.add(this.cutoff);
    this.knobs.add(this.resonance);
    this.knobs.add(this.volume);
    this.knobs.add(this.glide);
    this.knobs.add(this.vcoMod);
    this.knobs.add(this.vcfMod);
    this.knobs.add(this.tempo);
    this.knobs.add(this.lfoRate);
    this.knobs.add(this.attack);
    this.knobs.add(this.decay);
    this.knobs.add(this.vcMix);
  }

  private void updateSwitch(){
    imageMode(CENTER);
    for (Switch swtch : switches){
      swtch.render();
      swtch.bb.renderCollide();
      if (mousePressed){
        if(swtch.bb.collision(mouseX, mouseY)){
          if (this.activeSwtch == null){
            this.activeSwtch = swtch;
            swtch.switchState();
          }
        }
      }
    }
  imageMode(CORNER);
  }

  private void updateKnob(){
    for (Knob knob : knobs){
      knob.render();
      knob.bb.renderCollide();
      if (mousePressed){
        if(knob.bb.collision(mouseX, mouseY)){
          if (this.activeKnob == null){
            this.activeKnob = knob;
          }
        }
      }
    }
  }

  void update(){
    updateSwitch();
    updateKnob();
  }
}
//===========================================

void draw(){
  background(255,255,255);
  stroke(1);
  strokeWeight(2);
  ellipse(200,200,100,100);
  image(overlay,0,0);
  mother.update();
  println("mouseX :: " + mouseX);
  println("mouseY :: " + mouseY);
}







