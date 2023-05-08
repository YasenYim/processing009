/*
Processing project
 BezierCurves
 by ZzStarSound
 
 Firstly ,we need some UI classes.
 (I've written them under the draw method.They are ANumber(A number box);ASlider(A simple slider)).
 */
int maxStep = 7;
//Then,you can change the max step of bezier curve by modifying this variable.


ANumber num, showNum;
ASlider pro;
ALinePoint alp;
ABezier abg;
void setup() {
  size(1280, 720);
  frameRate(60);
  num = new ANumber(100, 100, "NOP", 2, maxStep, 4);
  showNum = new ANumber(200, 100, "NON", 0, num.getVal()-2, 4);
  pro = new ASlider(150, 200, 100, 0);
  alp = new ALinePoint(4, 15, true);
  abg = new ABezier();
}

void draw() {

  textAlign(CENTER, CENTER);
  background(100);
  alp.setNum(num.getVal());
  alp.show(0, 0, 0);
  abg.setNum(num.getVal()-1);
  abg.calculate(alp, pro.getVal()/100.0);
  abg.pointArray(alp);
  abg.show(showNum.getVal());

  num.show();
  showNum.show();
  pro.update();
}


void mousePressed() {
  num.modify();
  showNum.modify();
  showNum.limitV(0, num.getVal()-2);
  pro.mouseOn();
  alp.mouseOn();
}
void mouseReleased() {
  pro.mouseOff();
  alp.mouseOff();
}

class ABezier {
  ArrayList<ALinePoint> bzG = new ArrayList<ALinePoint>();
  int numOfP = 200;
  PVector[] pt = new PVector[numOfP];
  float process = 0;

  ABezier() {
    for (int i = 0; i<3; i++) {
      bzG.add(new ALinePoint(i+1, 10, false));
    }
    for (int i = 0; i<numOfP; i++) {
      pt[i]=new PVector(0, 0);
    }
  }




  void setNum(int n) {
    if (n!=bzG.size()) {
      int pn = n;
      if (pn>bzG.size()) {
        for (int i = bzG.size(); bzG.size()<pn; i++) {
          bzG.add(i, new ALinePoint(i+1, 10, false));
        }
      } else if (pn<bzG.size()) {
        for (int i = bzG.size()-1; bzG.size()>pn; i--) {
          bzG.remove(i);
        }
      }
    }
  }

  ALinePoint sendValue(ALinePoint input, ALinePoint output, float t) {
    if (input.getSize()-1 == output.getSize()) {
      for (int i = 0; i<output.getSize(); i++) {
        PVector a, b, c;
        a = input.getPosition(i);
        b = input.getPosition(i+1);
        c = new PVector(a.x*(1-t)+b.x*t, a.y*(1-t)+b.y*t);
        output.setPosition(i, floor(c.x), floor(c.y));
      }
    }
    return output;
  }



  void calculate(ALinePoint input, float t) {
    process = t;
    if (bzG.size()>=2) {
      bzG.set(bzG.size()-1, sendValue(input, bzG.get(bzG.size()-1), t));
      for (int i = bzG.size()-2; i>=0; i--) {
        bzG.set(i, sendValue(bzG.get(i+1), bzG.get(i), t));
      }
    } else {
      bzG.set(0, sendValue(input, bzG.get(0), t));
    }
  }



  int stepMult(int in) {
    int out = 1;
    for (int i = in; i>1; i--) {
      out *=i ;
    }
    return out;
  }
  int cnr(int n, int r) {
    return stepMult(n) / ( stepMult(n-r)*stepMult(r)  );
  }




  void pointArray(ALinePoint input) {
    int pn = input.getSize();
    for (int i = 0; i<numOfP; i++) {
      float t = (float)i / (float)numOfP;
      float x = 0;
      float y = 0;
      for (int j = 0; j<pn; j++) {
        x += input.getPosition(j).x *pow((1-t), pn-1-j)*pow(t, j)*cnr(pn-1, j);
        y += input.getPosition(j).y *pow((1-t), pn-1-j)*pow(t, j)*cnr(pn-1, j);
      }
      pt[i].set(x, y);
    }
  }





  void show(int n) {
    for (int i = 0; i<numOfP*process; i++) {
      fill(150+(i+1)*100/numOfP, 150+i*100/numOfP, 250+(bzG.size()-i)*100/numOfP);
      noStroke();
      ellipse(pt[i].x, pt[i].y, 5, 5);
    }
    if (n!=0&&bzG.size()>1) {
      for (int i = bzG.size()-1; i>=0&&bzG.size()-i<=n; i--) {
        ALinePoint solo = bzG.get(i);
        solo.show(150+(i+1)*100/bzG.size(), 150+i*100/bzG.size(), 250+(bzG.size()-i)*100/bzG.size());
      }
      ALinePoint solo = bzG.get(0);
      solo.show(200, 200, 200);
    } else {
      ALinePoint solo = bzG.get(0);
      solo.show(200, 200, 200);
    }
  }
}
class ALinePoint {
  ArrayList<APoint> pointG = new ArrayList<APoint>();
  boolean controlable = false;

  ALinePoint(int n, int size, boolean shT) {
    controlable = shT;
    for (int i = 0; i<n; i++) {
      pointG.add(new APoint(floor(400+i*600/n), floor(height/2), size, i, shT));
    }
  }



  ArrayList<APoint> getList() {
    return pointG;
  }
  PVector getPosition(int id) {
    return pointG.get(id).position;
  }
  int getSize() {
    return pointG.size();
  }



  APoint setId(APoint pt, int id) {
    APoint pt2 = pt;
    pt2.id=id;
    return pt2;
  };
  void setPosition(int id, int x, int y) {
    APoint pur = pointG.get(id);
    pur.setPosition(x, y);
    pointG.set(id, pur);
  }
  void setNum(int n) {
    if (n!=pointG.size()) {
      int pn = n;
      if (pn>pointG.size()) {
        for (int i = pointG.size(); pointG.size()<pn; i++) {
          pointG.add(i, new APoint(0, 0, pointG.get(0).size, i, controlable));
        }
      } else if (pn<pointG.size()) {
        for (int i = pointG.size()-1; pointG.size()>pn; i--) {
          pointG.remove(i);
        }
      }
      for (int i = 0; i<pointG.size(); i++) {
        setPosition(i, floor(400+i*600/pointG.size()), floor(height/2));
      }
    }
  }



  void mouseOn() {
    for (APoint pt : pointG) {
      if (pt.inside()) {
        pt.mouseOn();
        break;
      }
    }
  }
  void mouseOff() {
    for (APoint pt : pointG) {
      pt.mouseOff();
    }
  }


  void show(int r, int g, int b) {

    stroke(r, g, b);

    if (controlable) {
      strokeWeight(5);
    } else {
      strokeWeight(3);
    }
    for (int i = 0; i<pointG.size()-1; i++) {
      line(pointG.get(i).position.x, pointG.get(i).position.y, pointG.get(i+1).position.x, pointG.get(i+1).position.y);
    }
    if (controlable) {
      fill(255);
      strokeWeight(5);
      stroke(r, g, b);
    } else {
      noStroke();
      fill(r, g, b);
    }
    for (APoint pt : pointG) {
      pt.show();
    }
  }
}


class ANumber {
  PVector position = new PVector(0, 0);
  int num = 1;
  int orgNum = 1;
  int max, min;
  String name = "A";
  boolean lockCut = false;
  boolean lockPlus = false;
  PShape tri = createShape();
  PShape tri2 = createShape();

  ANumber(int x, int y, String n, int minV, int maxV, int nm) {
    min = minV;
    max = maxV;
    //type = ty;
    orgNum = nm;
    num = nm;
    position.set(x, y);
    name = n;
    tri.beginShape();
    tri.vertex(0, 0);
    tri.vertex(-10, 10);
    tri.vertex(10, 10);
    tri.fill(255);
    tri.noStroke();
    tri.endShape();
    tri2.beginShape();
    tri2.vertex(0, 0);
    tri2.vertex(-10, -10);
    tri2.vertex(10, -10);
    tri2.fill(255);
    tri2.noStroke();
    tri2.endShape();
    tri.translate(position.x, position.y-30);
    tri2.translate(position.x, position.y+30);
  }




  void reSet() {
    num = orgNum;
  }

  void mmCheck() {
    if (num>max) {
      num = max;
    } else if (num<min) {
      num = min;
    }
    if (num==max) {
      lockPlus = true;
    } else {
      lockPlus = false;
    }
    if (num==min) {
      lockCut = true;
    } else {
      lockCut = false;
    }
  }
  void limitV(int minV, int maxV) {
    min = minV;
    max = maxV;
  }

  int getVal() {
    return num;
  }



  void show() {

    mmCheck();
    if (lockCut == false) {
      shape(tri2);
    }
    if (lockPlus == false) {
      shape(tri);
    }
    textSize(25);
    fill(255);
    text(num, position.x, position.y-5);
    text(name, position.x, position.y-60);
  }


  boolean overRect(float x, float x2, float y, float y2) {
    if (mouseX >= x && mouseX <= x2 && 
      mouseY >= y && mouseY <= y2) {
      return true;
    } else {
      return false;
    }
  }

  void modify() {
    int step = 1;
    if (mouseButton == LEFT) {
      step = 1;
    } else if (mouseButton == RIGHT) {
      step = 5;
    } else {
      step = 20;
    }
    if (overRect(   position.x-10, position.x+10, position.y-35, position.y-15       )&&lockPlus == false) {
      num+=step;
      if (num >max) {
        num = max;
      }
    } else if (overRect(   position.x-10, position.x+10, position.y+15, position.y+35       )&&lockCut == false) {
      num-=step;
      if (num <min) {
        num = min;
      }
    }
  }
}
class APoint {


  PVector position = new PVector(200, 200);
  int id = 0;
  int size = 20;
  boolean showT = true;
  boolean hold = false;


  APoint(int x, int y, int siz, int idi, boolean shT) {
    id = idi;
    position.set(x, y);
    showT = shT;
    size = siz;
  }


  boolean inside() {
    if (dist(mouseX, mouseY, position.x, position.y)<size+5) {
      return true;
    } else {
      return false;
    }
  }
  void setPosition(int x, int y) {
    position.set(x, y);
  }
  void mouseOn() {
    if (inside()) {
      hold = true;
    }
  }
  void mouseOff() {
    hold = false;
  }
  void modify() {
    if (hold) {
      setPosition(mouseX, mouseY);
    }
  }



  void show() {
    modify();
    if (showT) {
      textSize(20);
      text("P"+id, position.x, position.y-size-15);
    }
    ellipse(position.x, position.y, size, size);
  }
}





class ASlider {

  PVector position = new PVector(0, 0);
  PVector size = new PVector(20, 20);
  float lengthOfSlider = 100.0;
  float BValue = 50.0;
  float orgVal = 50.0;
  boolean visiable = true ;
  float centerX = 0;
  float easing = 0.3;
  float positionX = 50.0;



  ASlider(float x, float y, float len, float st) {

    position.set(x, y);
    lengthOfSlider = len;
    orgVal = st;
    BValue = st;
    centerX = (BValue/100.0-0.5)*lengthOfSlider+position.x;
    positionX = centerX;
  }



  boolean overRect(float x, float x2, float y, float y2) {
    if (mouseX >= x && mouseX <= x2 && 
      mouseY >= y && mouseY <= y2) {
      return true;
    } else {
      return false;
    }
  }
  float lock(float val, float minv, float maxv) { 
    return  min(max(val, minv), maxv);
  } 



  void reSet() {
    BValue = orgVal;
  }
  void setVisiable(boolean v) {
    visiable = v;
  }
  float getVal() {
    return BValue;
  }



  void show() {
    centerX = (BValue/100.0-0.5)*lengthOfSlider+position.x;
    positionX += (centerX-positionX)*easing;
    if (visiable) {
      noStroke();
      fill(255);
      rectMode(CENTER);
      rect(position.x, position.y, lengthOfSlider, 2);
      stroke(100);
      strokeWeight(3);
      ellipse(positionX, position.y, size.x, size.y);
      noStroke();
      textSize(15);
      text("0", position.x-lengthOfSlider/2-30, position.y-3);
      text("1", position.x+lengthOfSlider/2+30, position.y-3);
    } else {
      noStroke();
      fill(255, 100);
      rectMode(CENTER);
      rect(position.x, position.y, lengthOfSlider, 2);
      noStroke();
      fill(106, 78, 78);
      ellipse(positionX, position.y, size.x+6, size.y+6);
      stroke(255, 100);
      noFill();
      strokeWeight(2);
      ellipse(positionX, position.y, size.x-2, size.y-2);
      noStroke();
      fill(255, 100);
      textSize(15);
      text("0", position.x-lengthOfSlider/2-30, position.y-3);
      text("1", position.x+lengthOfSlider/2+30, position.y-3);
    }
  }



  boolean mouseP = false;
  void mouseOn() {
    if (overRect(  position.x-lengthOfSlider/2, position.x+lengthOfSlider/2, position.y-size.y, position.y+size.y   ) == false) {
    } else {
      mouseP = true;
    }
  }
  void mouseOff() {
    mouseP = false;
  }
  void modify() {
    if (mouseP) {
      if (visiable) {
        centerX = lock(mouseX, position.x-lengthOfSlider/2, position.x+lengthOfSlider/2);
        BValue = ((centerX-position.x)/lengthOfSlider+0.5)*100.0;
        //sendValue();
      }
    }
  }


  void update() {

    modify();
    show();
  }
}
