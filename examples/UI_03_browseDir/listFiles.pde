final int DIRSANDFILES=0;
final int NODIRS =1;
final int NOFILES =2;


String [] listFiles(String path, int filter) {
  StringList sl=new StringList();
  listFiles(path, sl, filter);
  //println("la: total "+sl.size());
  return sl.array();
}


void listFiles(String path, StringList sl, int filter) 
{ 
  File f=new File(path);
  File [] contents=f.listFiles();
  if(contents!=null)
  for(File af:contents){
    sl.append(af.getName());
  }
  
}


