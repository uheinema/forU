

  private class Tokenizer {
    int i;
    String s;
    int l;
    Tokenizer(String s) {
      this.s=s;
      this.i=0;
      this.l=s.length();
    }

    private char ci() {
      if(i>=l) throw
       new IllegalArgumentException("murks mit '"+s+"'");
      return s. charAt(i);
    }

    String scanned="";

    void consume() {
      scanned+=ci();
      i++;
    }

    void scanto(char c) {
      
      while (ci()!=c) {
        consume();
        if (end()) return;
      }
    }
    boolean end() {
      return i>= l;
    }

    String next() {

      scanned="";
      //  if(i>=l) return null;
      for (; i<l; i++) {
        if (ci()!=' ') break;
      }
      if (i>=l) return null;
      switch(ci()) {
      case '.': // verbatim up to space
        scanto(' ');
        return scanned;
      case '/':
        consume();
        if(i<l&&ci()=='/') {
          i=l;
          return null;
        }
        scanto(' ');
        return scanned;
      default:
        scanto(' ');
        return scanned;
      }
    }
  } // Tokenizer
