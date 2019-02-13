
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

/*
 *
 *  FxN :: mouseReleased
 *
 *  Resets active object
 *  upon mouse release
 */
void mouseReleased(){
  if (mother.activeSwtch != null){
    mother.activeSwtch = null;
  }
  if (mother.activeKnob != null){
    mother.activeKnob = null;
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
  float posX, posY;
  float alarmTime;
  boolean animation, isSet;
  BoundingBox bb;
  //constructor
  Switch(float x,float y){
    //defaults
    float w = 25;//bounding box width
    float h = 25;//bounding box height
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

  float posX, posY; //positions
  float radius; //radius
  float angle;  //degree of rotation
  float currMouse, prevMouse; //controller values
  boolean active;
  BoundingBox bb;
  Knob(float x, float y){
    float w = 50; //bounding box width
    float h = 50; //bounding box height
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
  
  float posX, posY;
  float radius;
  BoundingBox bb;
  Patch(float x, float y){
    float w = 17;
    float h = 17;
    bb = new BoundingBox(x,y,w,h);
    posX = x;
    posY = y;
    radius = 5;
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
    ellipse(this.posX, this.posY, this.radius, this.radius);
  }

}


//===========================================



//===========================================
class Mother{

  private int numSwitches = 9;
  private int numKnobs = 14;
  private int numPatchesX = 4;
  private int numPatchesY = 8;
  private Switch[] switches = new Switch[numSwitches];
  private Knob[] knobs = new Knob[numKnobs];
  private Patch[] patches = new Patch[numPatchesX * numPatchesY];
  Switch activeSwtch;
  Knob activeKnob;

  //constructor
  Mother(){
    activeSwtch = null;
    activeKnob = null;
  }

  void init(){
    
    //hardcoded coordinates.
    float[] switchX = {242,879,242,487,606,727,970,485,720};
    float[] switchY = {87,87,208,208,208,208,208,329,329};
    float[] knobX = {120,363,483,629,775,970,120,363,848,199,364,606,849,970};
    float[] knobY = {85,85,85,85,85,85,205,205,205,327,328,327,325,326};
    float sPatchX = 1082;
    float sPatchY = 77;
    float patchSpace = 57;
    

    for (int i = 0; i < numSwitches; i++){
      this.switches[i] = new Switch(switchX[i], switchY[i]); 
    }

    for (int i = 0; i < numKnobs; i++){
      this.knobs[i] = new Knob(knobX[i], knobY[i]);
    }
  
    for (int i = 0; i < numPatchesY; i++){
      for (int j = 0; j < numPatchesX; j++){
        patches[i * numPatchesX + j] = new Patch(sPatchX, sPatchY);
        sPatchX += patchSpace;
      }
      sPatchX = 1082;
      sPatchY += patchSpace;
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
    }
  }

  void update(){
    updateSwitch();
    updateKnob();
    updatePatch();
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







