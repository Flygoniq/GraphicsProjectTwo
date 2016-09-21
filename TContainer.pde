

class TContainer {
  floatptPair[] Ts;
  int behind, inside, ahead, size;
  floatptPair closestBehind, closestAhead, backInside, frontInside;
  
  TContainer() {
    Ts = new floatptPair[20];
    behind = 0;
    inside = 0;
    ahead = 0;
    size = 0;
    closestBehind = new floatptPair(0);
    closestAhead = new floatptPair(0);
    backInside = new floatptPair(-1);
    frontInside = new floatptPair(1);
  }
  
  void grow () {
    floatptPair[] temp = new floatptPair[Ts.length * 2];
    for (int i = 0; i < Ts.length; i++) {
      temp[i] = Ts[i];
    }
    Ts = temp;
  }
  
  void add(float t, pt p) {
    if (size == Ts.length) {
      grow();
    }
    floatptPair current = new floatptPair(t, p);
    Ts[size++] = current;
    if (t < 0) {
      behind++;
      if (closestBehind.f == 0 || t > closestBehind.f) {
        closestBehind = current;
      }
    } else if (t <= 1) {
      inside++;
      if (backInside.f == -1) {
        backInside = current;
      } else if (frontInside.f == 1) {
        frontInside = current;
      }
    } else {
      ahead++;
      if (closestAhead.f == 0 || t < closestAhead.f) {
        closestAhead = current;
      }
    }
  }
  
  //returns the pair of points to cut at, or throws noSuchElement
  floatptPair[] getTs() {
    if (inside == 0 && ahead % 2 == 1 && behind % 2 == 1) {
      return new floatptPair[] {closestBehind, closestAhead};
    } else if (inside == 2 && ahead % 2 == 0 && behind % 2 == 0) {
      return new floatptPair[] {backInside, frontInside};
    } else if (inside == 1 && ahead % 2 == 1 && behind % 2 == 0) {
      return new floatptPair[] {backInside, closestAhead};
    } else if (inside == 1 && ahead % 2 == 0 && behind % 2 == 1) {
      return new floatptPair[] {closestBehind, backInside};
    } else {
      throw new NoSuchElementException();
    }
  }
}

class floatptPair {
  float f;
  pt p;
  
  floatptPair (float f) {
    this.f = f;
    p = null;
  }
  
  floatptPair (float f, pt p) {
    this.f = f;
    this.p = p;
  }
}