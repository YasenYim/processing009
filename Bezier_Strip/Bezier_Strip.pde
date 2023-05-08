int num=100;

void setup(){
  
  size(1000,600,P2D);
  colorMode(HSB);
  
}

void draw(){
  background(0);
  noFill();
  
  float endThk=100;
  float midThk=50;
  
  strokeWeight(8);
  float c1y=map(sin(frameCount*0.06),-1,1,height*0.,height*1);
  float c2y=map(sin(frameCount*0.085),-1,1,height*0.,height*1);
  for(int i=0;i<num;i++){
    stroke(map(i,0,num,0,125),255,255,20);
    bezier(0,map(i,0,num,height/2-endThk/2,height/2+endThk/2),
    width*0.33,c1y+map(i,0,num,-midThk/2,midThk/2),
    width*0.67,c2y+map(i,0,num,midThk/2,midThk/2),
    width,map(i,0,num,height/2-endThk/2,height/2+endThk/2));
  }
  
  surface.setTitle(nf(frameRate,0,2));
}
