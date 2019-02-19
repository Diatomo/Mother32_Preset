
//Assets
PImage overlay;
PImage swUp;
PImage swDown;

Scene scene;


void setup(){
  size(1600,800);//dimension of canvas
  frameRate(120);
  //assets
  overlay = loadImage("overlay.png");
  swUp = loadImage("switch_up.png");
  swDown = loadImage("switch_down.png");
  //main object
  scene = new Scene();
}

/*
 *
 *  FxN :: resizeImages
 *    @param factor :: multiplicative factor
 *
 *  resizes the images (mother32, switch up, switch down);
 *
 */
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
  for (Mother mother : scene.brood){
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
  for (Mother mother : scene.brood){
    if (mother.activeKnob != null){
      mother.activeKnob.turn();
    }
    if (mother.activePatch != null){
      mother.activePatch.hookingUp();
    }
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
 
  //attributes
  float right,left,bot,top;

  /*
   *
   *  Constructor 
   *    right = right side of the box
   *    left = left side of the box
   *    bot = bottom of the box
   *    top = top of the box
   *
   */
  BoundingBox(float x, float y, float w, float h){
    right = x + w;
    left = x - w;
    bot = y + h;
    top = y - h;
  }

  /*
   *  fxn :: resize
   *    resize position values
   *    by multiplicative factor
   */
  public void resize(float x, float y, float w, float h){
    this.right = x + w;
    this.left = x - w;
    this.bot = y + h;
    this.top = y - h;
  }

  /*
   *
   *  fxn :: collision
   *    @param cursorX, cursorY :: mouse position
   *
   *  Determines whether a click made a collision
   *
   */
  public boolean collision(float cursorX, float cursorY){
    boolean collide = false; 
    if (cursorX < this.right && cursorX > this.left && 
        cursorY > this.top && cursorY < this.bot){
        collide = true;
    }
    return collide;
  }
  
  /*
   *
   *  FxN :: render
   *
   *    Renders bounding box
   *
   */
  public void render(){
    line(this.right, this.bot, this.right, this.top); //right side
    line(this.right, this.top, this.left, this.top);  //top side
    line(this.left, this.bot, this.left, this.top); // left side
    line(this.left, this.bot, this.right, this.bot); //bottom side;
  }
}

/*
 *
 *  class :: Button
 *
 *  Buttons to add and remove mothers
 *  also to save the output.
 *
 */
class Button{

  //attributes
  float posX, posY, w, h, gap;
  BoundingBox bb;
  String label;

  /*
   *
   *  Constructor
   *    x = posiion X coord
   *    y = position y coord
   *    w = width of rectangle
   *    h = height of rectangle
   *    gap = distance from text to button.
   *    label = label for button
   *
   */
  Button(float x, float y, String label){
    this.w = 25;
    this.h = 25;
    this.gap = 50;
    this.posX = x;
    this.posY = y;
    this.label = label;
    this.bb = new BoundingBox(x,y,w,h);
  }

  /*
   *  fxn :: resize
   *    resize position values
   *    by multiplicative factor
   */
  public void resize(float factor){
    this.posX = this.posX * factor;
    this.posY = this.posY * factor;
    this.w = this.w * factor;
    this.h = this.h * factor;
    this.bb = new BoundingBox(this.posX,this.posY,this.w,this.h);
  }

  /*
   *
   *  FxN :: render
   *
   *    Renders rectangle and label
   *
   */
  public void render(){
    rect(this.posX, this.posY, this.w, this.h);
    text(this.label, this.posX - this.gap, this.posY);
  }

}

/*
 *
 *  class :: Scene
 *
 *  Controls all elements in the scene.
 *
 */
class Scene{
  
  //attributes
  ArrayList<Mother> brood; //container for mothes
  Mother mother1, mother2, mother3; //mother synthesizer


  /*
   *
   *  Constructor
   *
   */
  Scene(){
    this.brood = new ArrayList<Mother>();
    this.mother1 = new Mother(100, 100);
    this.mother2 = new Mother(0, 0);
    this.mother3 = new Mother(0, 0);
    this.mother1.init();
    this.mother2.init();
    this.mother3.init();
    this.brood.add(this.mother1);
  }

  /*
   *  fxn :: add
   *
   *    add a mother from the container
   *    then scales
   *
   */
  public void add(){
    float factor = 0.75;
    if (this.brood.size() < 3){
      
      if (this.brood.size() == 1){
        this.brood.add(new Mother(100,100));
      }
      else if (this.brood.size() == 2){
        this.brood.add(new Mother(100,100));
      }
      this.scale(factor);
    }
  }

  /*
   *  fxn :: remove
   *
   *    removes a mother from the container
   *    then scales
   *
   */
  public void remove(){
    float factor = 1.25;
    if (this.brood.size() > 1){
      if (this.brood.size() == 3){
        this.brood.remove(this.mother3);
      }
      else if (this.brood.size() == 2){
        this.brood.remove(this.mother2);
      }
    }
    this.scale(factor);
  }

  /*
   *  fxn :: scale
   *    scale position values
   *    by multiplicative factor
   */
  private void scale(float factor){
    resizeImages(factor);
    for (Mother mother : brood){
      mother.resize(factor);
      mother.reposition(); 
    }
  }

  public void render(){
    for (Mother mother : brood){
      mother.render();
      mother.update();
    }
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

  /*
   *  fxn :: resize
   *    resize position values
   *    by multiplicative factor
   */
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

  /*
   *  fxn :: resize
   *    resize position values
   *    by multiplicative factor
   */
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
 
  //attributes
  float posX, posY, w, h;
  float radius;
  BoundingBox bb;
  boolean snapped;
  boolean snapping;
  Patch node;

  /*
   *
   *  Constructor
   *
   */
  Patch(float x, float y){
    w = 17;
    h = 17;
    bb = new BoundingBox(x,y,w,h);
    snapped = false;
    posX = x;
    posY = y;
    radius = 5;
  }



  /*
   *  fxn :: hookingUp
   *
   *    temp render while mouse is held down.
   *
   */
  public void hookingUp(){
    line(this.posX, this.posY, mouseX, mouseY);
  }

  /*
   *  fxn :: hookUp
   *
   *    consumate relationship with
   *    another node
   *
   */
  public void hookUp(Patch node){
    this.node = node;
  }

  /*
   *  fxn :: breakUp
   *
   *    break relationship with another node
   *
   */
  public void breakUp(){
    node = null;
  }

  /*
   *  fxn :: resize
   *    resize position values
   *    by multiplicative factor
   */
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

  //attributes
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

  /*
   *
   *  Constructor
   *
   *
   */
  Mother(float x, float y){
    activeSwtch = null;
    activeKnob = null;
    posX = x;
    posY = y;
    synth = overlay;
  }

  /*
   *
   *  FxN :: init
   *    
   *    Creates components and sets the components
   *    on the canvas.
   *
   */
  void init(){
    
    //init switches
    for (int i = 0; i < numSwitches; i++){
      this.switches[i] = new Switch(switchX[i] + this.posX, switchY[i] + this.posY); 
    }

    //init knobs
    for (int i = 0; i < numKnobs; i++){
      this.knobs[i] = new Knob(knobX[i] + this.posX, knobY[i] + this.posY);
    }

    //init patches
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

  /*
   *
   *  FxN :: resize
   *    @param factor :: multiplicative factor to scale by
   *    
   *  resizes sizes through by a factor
   *
   */
  void resize(float factor){

    //resize switches
    for (int i = 0; i < numSwitches; i++){
      switchX[i] = switchX[i] * factor;
      switchY[i] = switchY[i] * factor;
      switches[i].resize(factor);
    }
    
    //resize knobs
    for (int i = 0; i < numKnobs; i++){
      knobX[i] = knobX[i] * factor;
      knobY[i] = knobY[i] * factor;
      knobs[i].resize(factor);
    }

    //resize patches
    sPatchX = sPatchX * factor;
    sPatchY = sPatchY * factor;
    patchSpace = patchSpace * factor;
    for (int i = 0; i < numPatchesX * numPatchesY; i++){
      patches[i].resize(factor);
    }
    this.posX = this.posX * factor;
    this.posY = this.posY * factor;
  }


  /*
   *
   *  FxN :: reposition
   *    
   *  reposition components on the canvas
   *
   */
  void reposition(){

    //reposition switches
    for (int i = 0; i < numSwitches; i++){
      this.switches[i].posX = switchX[i] + this.posX; 
      this.switches[i].posY = switchY[i] + this.posY; 
    }

    //reposition knobs
    for (int i = 0; i < numKnobs; i++){
      this.knobs[i].posX = knobX[i] + this.posX;
      this.knobs[i].posY = knobY[i] + this.posY;
    }

    //reposition patches
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

  /*
   *
   *  FxN :: updateSwitch
   *    
   *    collision handler
   *    render handler
   *
   */
  private void updateSwitch(){
    imageMode(CENTER);
    for (Switch swtch : switches){
      swtch.render();
      swtch.bb.render();
      if (mousePressed){ //collision handler
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

  /*
   *
   *  FxN :: updateKnob
   *    
   *    collision handler
   *    render handler
   *
   */
  private void updateKnob(){
    for (Knob knob : knobs){
      knob.render();
      knob.bb.render();
      if (mousePressed){ //collision handler
        if(knob.bb.collision(mouseX, mouseY)){
          if (this.activeKnob == null){
            this.activeKnob = knob;
          }
        }
      }
    }
  }

  /*
   *
   *  FxN :: updatePatch
   *    
   *    collision handler
   *    render handler
   *
   */
  private void updatePatch(){
    for (Patch patch : patches){
      patch.render();
      patch.bb.render();
      if (patch == this.activePatch){
        patch.hookingUp();
      }
      if (mousePressed){  //collision handler
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

  /*
   *
   *  FxN :: update
   *    
   *    updates components
   *    
   *
   */
  public void update(){
    updateSwitch();
    updateKnob();
    updatePatch();
  }

  /*
   *  FxN :: render
   *  
   *    Renders image
   *
   */
  public void render(){
    image(overlay,this.posX,this.posY);
  }
}
//===========================================


/*
 *
 *  fxn :: draw
 *
 *    
 *
 */
void draw(){
  background(255,255,255);
  scene.render();
}




