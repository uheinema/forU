

String [] listFiles(String path,String filter) {
  // is it a regex?
  StringList sl=new StringList();
  listFiles(path, sl,filter);
  return sl.array();
}


void listFiles(String path, StringList sl,String filter) 
{ 
  File f=new File(path);
  File [] contents=f.listFiles();
  if(contents!=null)
  for(File af:contents){
    String fn=af.getName();
    if(fn.contains(filter))
      sl.append(fn);
  }
  
}


