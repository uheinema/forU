
void
stringize(String fn){
  String[] inp=loadStrings(fn+".txt");
  int f=0;
  println("String [] "+fn+"={");
  for(String l:inp){
    
    if (f!=0) println(",");
    f++;
    print("  \""+escape(l)+"\"");
  }
  println(" };");
}

String escape(String s){
  s.replace("\"","\\\"");
  return s;
}