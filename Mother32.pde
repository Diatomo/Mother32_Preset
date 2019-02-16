
//Assets
PImage overlay;
PImage swUp;
PImage swDown;
ArrayList<Mother> brood;
Mother mother;


void setup(){
  size(1600,800);//dimension of image
  frameRate(120);
  //assets
  overlay = loadImage("overlay.png");
  swUp = loadImage("switch_up.png");
  swDown = loadImage("switch_down.png");
  //main object
  brood = new ArrayList<Mother>();
  mother = new Mother(100,100);
  mother.init();
  mother.resize(0.5);
  resizeImages(0.5);
  mother.reposition();
  brood.add(mother);

}


void resizeImages(float factor){
    overlay.resize(int(overlay.width * factor), int(overlay.height * factor));
    swUp.resize(int(swUp.width * factor), int(swUp.height * factor));
    swDown.resize(int(swDown.width * factor), int(swDown.height * factor));

}
/*
 *
 *  FxN :: mouseReleased
 *
 *  Resets active object
 *  upon mouse release
 */
void mouseReleased(){
  mother.activeSwtch = null;
  mother.activeKnob = null;
  if (mother.activePatch != null){
    for (Patch patch : mother.patches){
      if (patch.bb.collision(mouseX, mouseY)){
        if (patch != mother.activePatch){
          if (patch.node == null && mother.activePatch.node == null){
            patch.hookUp(mother.activePatch);
            mother.activePatch.hookUp(patch);
          }
        }
      }
    }
    mother.activePatch = null;
  }
}

/*
 *
 *  FxN :: mouseDragged
 *
 *  While mouse is being dragged it will
 *  turn the dial on the knobs.
 *
 */
void mouseDragged(){
  if (mother.activeKnob != null){
    mother.activeKnob.turn();
  }
  if (mother.activePatch != null){
    mother.activePatch.hookingUp(); 
  }
}

//===========================================
//UTILITY 
/*
 *
 *  class :: BoundingBox
 *
 *  Illustrated bounding boxes that collide
 *  with the mouse clicks.
 *
 */
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
  
  public void resize(float x, float y, float w, float h){
    this.right = x + w;
    this.left = x - w;
    this.bot = y + h;
    this.top = y - h;
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
  float posX, posY, w, h;
  float alarmTime;
  boolean animation, isSet;
  BoundingBox bb;
  //constructor
  Switch(float x,float y){
    //defaults
    w = 25;//bounding box width
    h = 25;//bounding box height
    state = false;//sprite toggle {up || down}
    //objects
    bb = new BoundingBox(x,y,w,h);
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

  public void resize(float factor){
    this.posX = this.posX * factor;
    this.posY = this.posY * factor;
    this.w = this.w * factor;
    this.h = this.h * factor;
    this.bb = new BoundingBox(this.posX, this.posY, this.w, this.h);
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

  float posX, posY, w, h; //positions
  float radius; //radius
  float angle;  //degree of rotation
  float currMouse, prevMouse; //controller values
  boolean active;
  BoundingBox bb;
  Knob(float x, float y){
    w = 50; //bounding box width
    h = 50; //bounding box height
    angle = 270; //default angle degrees {0,360}
    radius = 28; //radius length :: hardcoded
    bb = new BoundingBox(x,y,w,h);
    posX = x;
    posY = y;
  }

  /*
   *  fxn :: setMousePos
   *
   *  initializes the currMouse value
   *
   */
  public void setMousePos(){
    this.currMouse = mouseY;
  }
  
  /*
   *  fxn :: turn
   *
   *  when the mouse is dragged
   *  it calls the function to 
   *  increment or decrement
   *  an angle value
   *
   */
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

  public void resize(float factor){
    this.posX = this.posX * factor;
    this.posY = this.posY * factor;
    this.w = this.w * factor;
    this.h = this.h * factor;
    this.radius = this.radius * factor;
    this.bb.resize(this.posX, this.posY, this.w, this.h);
  }
  /*
   *  fxn :: render
   *
   *  renders the line
   *    
   */
  public void render(){
    float posXrot = this.posX + cos(radians(this.angle)) * this.radius;
    float posYrot = this.posY + sin(radians(this.angle)) * this.radius;
    line(this.posX, this.posY, posXrot, posYrot);
  }
}
//===========================================

//===========================================
/*
 *
 *  class : Patch
 *
 *  
 *
 */
class Patch{
  
  float posX, posY, w, h;
  float radius;
  BoundingBox bb;
  boolean snapped;
  boolean snapping;
  Patch node;
  Patch(float x, float y){
    w = 17;
    h = 17;
    bb = new BoundingBox(x,y,w,h);
    snapped = false;
    posX = x;
    posY = y;
    radius = 5;
  }

  public void hookingUp(){
    line(this.posX, this.posY, mouseX, mouseY);
  }

  public void hookUp(Patch node){
    this.node = node;
  }

  public void breakUp(){
    node = null;
  }

  public void resize(float factor){
    this.posX = this.posX * factor;
    this.posY = this.posY * factor;
    this.w = this.w * factor;
    this.h = this.h * factor;
    this.radius = this.radius * factor;
    this.bb.resize(this.posX, this.posY, this.w, this.h);
  }
  /*
   *  fxn :: render
   *
   *  renders the vertex 
   *  or snapping point
   *    
   */
  public void render(){
    fill(255);
    //ellipse(this.posX, this.posY, this.radius, this.radius);
    if(this.node != null){
      strokeWeight(5);
      line(this.posX, this.posY, this.node.posX, this.node.posY);
      strokeWeight(2);
    }
  }
}


//===========================================



//===========================================
class Mother{

  private int numSwitches = 9;
  private int numKnobs = 14;
  private int numPatchesX = 4;
  private int numPatchesY = 8;
  float[] switchX = {242,879,242,487,606,727,970,485,720};
  float[] switchY = {87,87,208,208,208,208,208,329,329};
  float[] knobX = {120,363,483,629,775,970,120,363,848,199,364,606,849,970};
  float[] knobY = {85,85,85,85,85,85,205,205,205,327,328,327,325,326};
  float sPatchX = 1082;
  float sPatchY = 77;
  float patchSpace = 57;
  private Switch[] switches = new Switch[numSwitches];
  private Knob[] knobs = new Knob[numKnobs];
  private Patch[] patches = new Patch[numPatchesX * numPatchesY];
  private PImage synth;
  private float posX, posY;
  Switch activeSwtch;
  Knob activeKnob;
  Patch activePatch;

  //constructor
  Mother(float x, float y){
    activeSwtch = null;
    activeKnob = null;
    posX = x;
    posY = y;
    synth = overlay;
  }

  void init(){
   
    for (int i = 0; i < numSwitches; i++){
      this.switches[i] = new Switch(switchX[i] + this.posX, switchY[i] + this.posY); 
    }

    for (int i = 0; i < numKnobs; i++){
      this.knobs[i] = new Knob(knobX[i] + this.posX, knobY[i] + this.posY);
    }

    float tempX = this.sPatchX;
    float tempY = this.sPatchY;
    for (int i = 0; i < numPatchesY; i++){
      for (int j = 0; j < numPatchesX; j++){
        patches[i * numPatchesX + j] = new Patch(tempX + this.posX, tempY + this.posY);
        tempX += patchSpace;
      }
      tempX = sPatchX;
      tempY += patchSpace;
    }
  }

  void resize(float factor){

    for (int i = 0; i < numSwitches; i++){
      switchX[i] = switchX[i] * factor;
      switchY[i] = switchY[i] * factor;
      switches[i].resize(factor);
    }

    for (int i = 0; i < numKnobs; i++){
      knobX[i] = knobX[i] * factor;
      knobY[i] = knobY[i] * factor;
      knobs[i].resize(factor);
    }

    sPatchX = sPatchX * factor;
    sPatchY = sPatchY * factor;
    patchSpace = patchSpace * factor;
    for (int i = 0; i < numPatchesX * numPatchesY; i++){
      patches[i].resize(factor);
    }
  }


  void reposition(){
    for (int i = 0; i < numSwitches; i++){
      this.switches[i].posX = switchX[i] + this.posX; 
      this.switches[i].posY = switchY[i] + this.posY; 
    }

    for (int i = 0; i < numKnobs; i++){
      this.knobs[i].posX = knobX[i] + this.posX;
      this.knobs[i].posY = knobY[i] + this.posY;
    }

    float tempX = this.sPatchX;
    float tempY = this.sPatchY;
    for (int i = 0; i < numPatchesY; i++){
      for (int j = 0; j < numPatchesX; j++){
        patches[i * numPatchesX + j].posX = tempX + this.posX;
        patches[i * numPatchesX + j].posY = tempY + this.posY;
        tempX += patchSpace;
      }
      tempX = sPatchX;
      tempY += patchSpace;
    }


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

  private void updatePatch(){
    for (Patch patch : patches){
      patch.render();
      patch.bb.renderCollide();
      if (patch == this.activePatch){
        patch.hookingUp();
      }
      if (mousePressed){
        if(patch.bb.collision(mouseX, mouseY)){
          if(this.activePatch == null){
            this.activePatch = patch;
            if (this.activePatch.node != null){
              this.activePatch.node.breakUp();
              this.activePatch.breakUp();
            }
          }
        }
      }
    }
  }

  public void update(){
    updateSwitch();
    updateKnob();
    updatePatch();
  }

  public void render(){
    image(overlay,this.posX,this.posY);
  }


}
//===========================================

void draw(){
  background(255,255,255);
  for (Mother mother : brood){
    mother.render();
    mother.update();
  }
}




