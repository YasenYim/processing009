
float rad=300;
float angle1, angle2;
PVector pos1, pos2;

void setup() {
  size(700, 700);
  reset();
}

void draw() {
  background(0);
  translate(width/2, height/2);

  float factor=map(mouseX, 0, width, 0, 1);

  noFill();
  strokeWeight(1);
  stroke(150);

  ellipse(0, 0, rad*2, rad*2);



  line(0, 0, pos1.x, pos1.y);
  line(0, 0, pos2.x, pos2.y);


  PVector center=new PVector(0, 0);
  PVector control1=PVector.lerp(center, pos1, factor);
  PVector control2=PVector.lerp(center, pos2, factor);

  stroke(255, 255, 0);
  strokeWeight(4);
  //fill(255,255,0);
  bezier(pos1.x, pos1.y, control1.x, control1.y, control2.x, control2.y, pos2.x, pos2.y);

  fill(0,255,0);
  arc(0, 0, rad*2, rad*2, angle1, angle2, OPEN);


  strokeWeight(10);
  stroke(255);
  point(control1.x, control1.y);
  point(control2.x, control2.y);  
  point(pos1.x, pos1.y);
  point(pos2.x, pos2.y);
}

void mousePressed() {
  reset();
}

void reset() {

  angle1=random(TWO_PI);
  pos1=new PVector(cos(angle1)*rad, sin(angle1)*rad);

  angle2=angle1+random(PI/12,PI*0.6);
  pos2=new PVector(cos(angle2)*rad, sin(angle2)*rad);
}
