//https://www.douban.com/photos/photo/1075545764/

void setup() { 
  size(700, 700); 
  smooth(); 
  background(0); 
  noLoop();
} 

void draw() { 
  translate(350, 350); 
  for (int an=1; an<360; an++) { 
    rotate(2*PI/an); 
    fl();
  }
} 

void fl() { 
  noFill(); 
  beginShape(); 
  vertex(0, 0); 
  int c1 = int(random(40, 250)); 
  int c2 = int(random(-10, 250)); 
  stroke(212, 212, 101, 100); 
  bezierVertex(c2, c2, c1, c2, c1, c2); 
  bezierVertex(c1, c2, c1, c2, c1, c2); 
  endShape(); 
  fill(240, 240, 63, 200); 
  noStroke(); 
  ellipse(c1, c2, 5, 5);
} 
