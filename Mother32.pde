

PImage overlay;
PImage swUp;
PImage swDown;
Mother mother;

void setup(){
  size(1312,559);
  frameRate(120);
  overlay = loadImage("overlay.png");
  swUp = loadImage("switch_up.png");
  swDown = loadImage("switch_down.png");
  mother = new Mother();
  mother.init();
}

/*
 *  INPUT CONTROL HANDLER
 */

void mousePressed(){
  if (mouseButton == LEFT){

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

  //constructor
  Switch(float x,float y){
        state = false;
        img = swDown;
        posX = x;
        posY = y;
  }

  /*
   *  fxn :: switchState
   *    When left click it changes the state
   *    and renders a different image
   */
  void switchState(){
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
  void render(){
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
  Knob(float x, float y){
    posX = x;
    posY = y;
    radius = 25;
  }

  void render(){
    line(this.posX, this.posY, this.posX, this.posY - this.radius);
  }
}
//===========================================

//===========================================
class Mother{

  Switch vcoWave, vcoModSrc, vcoModDest, vcfMode, vcfModSrc, polarity, vcaMode, lfoWave, sustain;
  Knob frequency, pulseWidth, mix, cutoff, resonance, volume, glide, vcoMod, vcfMod, tempo, lfoRate, attack, decay, vcMix;
  //constructor
  Mother(){

  }

  void init(){
    //switches row 1
    this.vcoWave = new Switch(242, 87);
    this.vcaMode = new Switch(879, 87);
    
    //switches row 2
    this.vcoModSrc = new Switch(242, 208);
    this.vcoModDest = new Switch(487, 208);
    this.vcfMode = new Switch(606, 208);
    this.vcfModSrc = new Switch(727, 208);
    this.polarity = new Switch(970, 208);

    //switches row 3
    this.lfoWave = new Switch(485, 329);
    this.sustain = new Switch(728, 328);

    //knob row 1
    this.frequency = new Knob(120, 85);
    this.pulseWidth = new Knob(363, 85);
    this.mix = new Knob(483, 85);
    this.cutoff = new Knob(629, 85);
    this.resonance = new Knob(775, 85);
    this.volume = new Knob(970, 85);

    //knob row 2
    this.glide = new Knob(120, 205);
    this.vcoMod = new Knob(363, 205);
    this.vcfMod = new Knob(848, 205);

    //knob row 3
    this.tempo = new Knob(199, 327);
    this.lfoRate = new Knob(364, 328);
    this.attack = new Knob(606, 327);
    this.decay = new Knob(849, 325);
    this.vcMix = new Knob(970, 326);
  }

  void render(){
    imageMode(CENTER);
    this.vcoWave.render();
    this.vcaMode.render();
    
    //switches row 2
    this.vcoModSrc.render();
    this.vcoModDest.render();
    this.vcfMode.render();
    this.vcfModSrc.render();
    this.polarity.render();

    //switches row 3
    this.lfoWave.render();
    this.sustain.render();
    imageMode(CORNER);

    //knob row 1
    this.frequency.render();
    this.pulseWidth.render();
    this.mix.render();
    this.cutoff.render();
    this.resonance.render();
    this.volume.render();

    //knob row 2
    this.glide.render();
    this.vcoMod.render();
    this.vcfMod.render();

    //knob row 3
    this.tempo.render();
    this.lfoRate.render();
    this.attack.render();
    this.decay.render();
    this.vcMix.render();

  }
}
//===========================================

void draw(){
  background(255,255,255);
  stroke(1);
  strokeWeight(4);
  ellipse(200,200,100,100);
  image(overlay,0,0);
  mother.render();
}







