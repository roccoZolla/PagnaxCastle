// classe per la gestione del timer
class Timer {
  long startTicks;  // clock time quando il timer parte
  long pauseTicks;  // clock timer quando il timer viene messo in pausa
  
  // variabili di stato
  boolean isStarted;
  boolean isPaused;
  
  Timer() {
    startTicks = 0;
    pauseTicks = 0;
    
    isStarted = false;
    isPaused = false;
  }
  
  // avvia il timer
  void timerStart() {
    isStarted = true;
    
    isPaused = false;
    
    // tempo corrente
    startTicks = millis();
    pauseTicks = 0;
  }
  
  // stoppa il timer
  void timerStop() {
    isStarted = false;
    
    isPaused = false;
    
    startTicks = 0;
    pauseTicks = 0;
  }
  
  // mette in pausa il timer
  void timerPause() {
    if (isStarted && !isPaused) {
        // Pause the timer
        isPaused = true;

        // Calculate the paused ticks
        pauseTicks = millis() - startTicks;
        startTicks = 0;
    }
  }
  
  // riprende il timer
  void timerUnpause() {
    //If the timer is running and paused
    if (isStarted && isPaused) {
        //Unpause the timer
        isPaused = false;

        //Reset the starting ticks
        startTicks = millis() - pauseTicks;

        //Reset the paused ticks
        pauseTicks = 0;
    }
  }
  
  void timerReset() {
    timerStop();
    timerStart();
  }
  
  long getTicks() {
    //The actual timer time
    long time = 0;

    // If the timer is running
    if (isStarted) {
        // If the timer is paused
        if (isPaused) {
            // Return the number of ticks when the timer was paused
            time = pauseTicks;
        }

        else {
            // Return the current time minus the start time
            time = millis() - startTicks;
        }
    }

    return time;
  }
  
  // ritorna le variabili di stato
  boolean isStarted() {
    return isStarted;
  }  
  
  boolean isPaused() {
    return isPaused;
  }
}
