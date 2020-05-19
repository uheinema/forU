import android.content.res.*; //getAssrt
import android.app.Activity; 

// empty dirs become files!
final int DIRSANDFILES=0;
final int NODIRS =1;
final int NOFILES =2;


String [] listAssets(String path, int filter) {
  StringList sl=new StringList();
  listAssets(path, sl, filter);
  return sl.array();
}

void listAssets(String path, StringList sl, int ignore) 
{ 
  String[] contents =null;
  try {
    contents= getActivity().getAssets().list(path);
  }
  catch (IOException io) {
    return;
  }
  if (contents == null)
    return;
  for (String entry : contents) 
  {  
    sl.append(entry);
  }
}

void recursiveListAssets(String path, StringList sl, int filter) 
{ 
  String[] contents =null;
  try {
    contents= getActivity().getAssets().list(path);
  }
  catch (IOException io) {
    contents=null; // or just return?
  }
  if (contents == null || contents.length == 0)
  { 
    if ((filter&NOFILES)==0)
      sl.append(path);
  } else {
    if ((filter&NODIRS)==0)
      sl.append(""+path +"/");
    for (String entry : contents) 
    {  
      if (path.equals("")) {
        listAssets(entry, sl, filter);
      } else listAssets(path + "/" + entry, sl, filter);
    }
  }
}
