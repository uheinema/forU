

String [] listFiles(String path) {
  StringList sl=new StringList();
  listFiles(path, sl);
  return sl.array();
}


void listFiles(String path, StringList sl) 
{ 
  File f=new File(path);
  File [] contents=f.listFiles();
  if(contents!=null)
  for(File af:contents){
    sl.append(af.getName());
  }
  
}


