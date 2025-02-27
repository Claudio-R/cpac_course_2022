// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Evolution EcoSystem

// Creature class


class Bloop {
  float health;     // Life timer 

  PVector position; // position
  DNA dna;          // DNA   FILL THE CODE
  float xoff;       // For perlin noise
  float yoff;
  // DNA will determine size and maxspeed
  float r = 10;
  float new_r;
  float maxspeed;
  
  
  
  

  // Create a "bloop" creature
  Bloop(PVector l, DNA dna_) { 
    position = l.get();
    health = 100; //FILL THE CODE
    xoff = random(1000);
    yoff = random(1000);
    dna = dna_; //UNCOMMENT
    // Gene 0 determines maxspeed and r
    // The bigger the bloop, the slower it is
    maxspeed = map(dna.genes[0], 0, 1, 15, 0);
    r = map(dna.genes[0], 0, 1, 0, 50);
    
  }

  void run() {
    update();
    borders();
    display();
  }

  //UNCOMMENT
  // A bloop can find food and eat it
  void eat(Food f) {
    ArrayList<PVector> food = f.getFood();
    // Are we touching any food objects?
    for (int i = food.size()-1; i >= 0; i--) {
      PVector foodposition = food.get(i);
      float d = PVector.dist(position, foodposition);
      // If we are, juice up our strength!
//      if (d < new_r/2) {
      if (d < r/2) {
        // FILL THE CODE: increase health by 100
        float increase_health_rate = 100;
        health += increase_health_rate;
        new_r = r + 0.1*health;

        food.remove(i);

        // SONIFICATION: we are going to deal with it at the end
        OscMessage msg = new OscMessage("/synth_control");
        
        // map idx of the scale
        msg.add(int(map(dna.genes[0], 0, 1, 0, 7)));
        
        // map reverb mix
        msg.add(dna.genes[0]);
        // map reverb room
        msg.add(dna.genes[0]);
        
        oscP5.send(msg, location);
            
      }
    }
  }

  // At any moment there is a teeny, tiny chance a bloop will reproduce
  Bloop reproduce() {
    // asexual reproduction
    if (random(0,1) < 0.001) {
      
      // Child is exact copy of single parent
      DNA childDNA = dna.copy();
      
      // Child DNA can mutate
      childDNA.mutate(0.01);
      
      return new Bloop(position, childDNA);
    } 
    else {
      return null;
    }
  }
  
  

  // Method to update position
  void update() {
    // Simple movement based on perlin noise
    float vx = map(noise(xoff),0,1,-maxspeed,maxspeed);
    float vy = map(noise(yoff),0,1,-maxspeed,maxspeed);
    PVector velocity = new PVector(vx,vy);
    xoff += 0.01;
    yoff += 0.01;

    position.add(velocity);
    // Death always looming
    float health_decrease_rate = 0.2;
    health -= health_decrease_rate;
    new_r = r + 0.1*health;
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);
    stroke(0, health);
    fill(0, health);
    //ellipse(position.x, position.y, new_r, new_r);
    ellipse(position.x, position.y, r, r);

}

//FILL THE CODE
  // Death
  boolean dead() {
    if (health < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }

}
