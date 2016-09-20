

class TContainer {
  float[] Ts;
  int behind, inside, ahead, size;
  float closestBehind, closestAhead, backInside, frontInside;
  
  TContainer() {
    Ts = new float[20];
    behind = 0;
    inside = 0;
    ahead = 0;
    size = 0;
    closestBehind = 0;
    closestAhead = 0;
    backInside = -1;
    frontInside = 1;
  }
  
  void grow () {
    float[] temp = new float[Ts.length * 2];
    for (int i = 0; i < Ts.length; i++) {
      temp[i] = Ts[i];
    }
    Ts = temp;
  }
  
  void add(float t) {
    if (size == Ts.length) {
      grow();
    }
    Ts[size++] = t;
    if (t < 0) {
      behind++;
      if (closestBehind == 0 || t > closestBehind) {
        closestBehind = t;
      }
    } else if (t <= 1) {
      inside++;
      if (backInside == -1) {
        backInside = t;
      } else if (frontInside == 1) {
        frontInside = t;
      }
    } else {
      ahead++;
      if (closestAhead == 0 || t < closestAhead) {
        closestAhead = t;
      }
    }
  }
  
  //returns the pair of points to cut at, or throws noSuchElement
  float[] getTs() {
    float[] ans = new float[2];
    if (inside == 0 && ahead % 2 == 1 && behind % 2 == 1) {
      return new float[] {closestBehind, closestAhead};
    } else if (inside == 2 && ahead % 2 == 0 && behind % 2 == 0) {
      return new float[] {backInside, frontInside};
    } else if (inside == 1 && ahead % 2 == 1 && behind % 2 == 0) {
      return new float[] {backInside, closestAhead};
    } else if (inside == 1 && ahead % 2 == 0 && behind % 2 == 1) {
      return new float[] {closestBehind, backInside};
    } else {
      throw new NoSuchElementException();
    }
  }
}