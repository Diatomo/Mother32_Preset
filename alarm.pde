
/*
 *  NOT NEEDED FOR THIS SCRIPT BUT SAVE FOR LATER!!
 */
/*
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
*/
