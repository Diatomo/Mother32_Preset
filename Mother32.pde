

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
  float right,left,bot,top;
  float time;
  boolean animation, isSet;
  //constructor
  Switch(float x,float y){
    float w = 25;
    float h = 25;
    animation = true;
    isSet = false;
    state = false;
    img = swDown;
    posX = x;
    posY = y;
    right = x + w;
    left = x - w;
    bot = y + h;
    top = y - h;
  }

  /*
   *  fxn :: switchState
   *    When left click it changes the state
   *    and renders a different image
   */
  public void switchState(){
    if (!this.isSet){
      this.isSet = true;
      this.animation = false;
      state = !state;
      if (state){
        img = swUp;
      }
      else{
        img = swDown;
      }
      this.startAlarm();
    }
  }

  public boolean collision(float cursorX, float cursorY){
    boolean collide = false;
    
    if (cursorX < this.right && cursorX > this.left && 
        cursorY > this.top && cursorY < this.bot){
        collide = true;
    }
   
    return collide;
  }

  public void renderCollide(){
    line(this.right, this.bot, this.right, this.top); //right side
    line(this.right, this.top, this.left, this.top);  //top side
    line(this.left, this.bot, this.left, this.top); // left side
    line(this.left, this.bot, this.right, this.bot); //bottom side;
  }

  void startAlarm(){
    if (!this.animation){
      this.time = millis();
      this.isSet = true;
    }
  }

  void cooldown(){
    float alarm = 500;
    if (this.isSet){
      if (millis() - this.time > alarm){
        this.isSet = false;
        this.animation = true;
      }
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
  float right,left,bot,top;
  Knob(float x, float y){
    float w = 50;
    float h = 50;
    right = x + w;
    left = x - w;
    bot = y + h;
    top = y - h;
    posX = x;
    posY = y;
    radius = 25;
  }

  public boolean collision(float cursorX, float cursorY){
    boolean collide = false;
    
    if (cursorX < this.right && cursorX > this.left && 
        cursorY > this.top && cursorY < this.bot){
        collide = true;
    }
   
    return collide;
  }

  public void renderCollide(){
    line(this.right, this.bot, this.right, this.top); //right side
    line(this.right, this.top, this.left, this.top);  //top side
    line(this.left, this.bot, this.left, this.top); // left side
    line(this.left, this.bot, this.right, this.bot); //bottom side;
  }

  public void render(){
    line(this.posX, this.posY, this.posX, this.posY - this.radius);
  }
}
//===========================================

//===========================================
class Mother{

  ArrayList<Switch> switches = new ArrayList<Switch>();
  Switch vcoWave, vcoModSrc, vcoModDest, vcfMode, vcfModSrc, polarity, vcaMode, lfoWave, sustain;
  ArrayList<Knob> knobs = new ArrayList<Knob>();
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

    switches.add(this.vcoWave);
    switches.add(this.vcaMode);
    //switches row 
    switches.add(this.vcoModSrc);
    switches.add(this.vcoModDest);
    switches.add(this.vcfMode);
    switches.add(this.vcfModSrc); 
    switches.add(this.polarity);
                    
    //switches row 3
    switches.add(this.lfoWave);
    switches.add(this.sustain);

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

   this.knobs.add(this.frequency);
   this.knobs.add(this.pulseWidth);
   this.knobs.add(this.mix);
   this.knobs.add(this.cutoff);
   this.knobs.add(this.resonance);
   this.knobs.add(this.volume);
                  
   //knob row 2
   this.knobs.add(this.glide);
   this.knobs.add(this.vcoMod);
   this.knobs.add(this.vcfMod);
                  
   //knob row 3
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
      swtch.renderCollide();
      swtch.cooldown();
      if (mousePressed){
        if(swtch.collision(mouseX, mouseY)){
          swtch.switchState();
        }
      }
    }
  imageMode(CORNER);
  }

  private void updateKnob(){
    for (Knob knob : knobs){
      knob.render();
      knob.renderCollide();
      if (mousePressed){
        if(knob.collision(mouseX, mouseY)){
          //delay(1000);
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
}







