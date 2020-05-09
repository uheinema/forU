

class Octo {

  String octoapikey="EF5CE890568F4EE1805B5396BC1ADF8D";

  String octoapi=
    // "http://connect.doodle3d.com/api/list.example";
    "http://octopi/api/";

  HttpURLConnection con ;
  int resultCode;

  void connect() {
    JSONObject cc=new JSONObject()
      .put ("command", "connect");
    JSONObject j=postJSON("connection", cc);
   // if (con.resultCode.. 
    if(j!=null) saveJSONObject(j, sex("connecting"+".json"));
  }

  void get(String q) {

    JSONObject j=getJSON(q);
    saveJSONObject(j, sex(q+".json"));
    toast(j.toString());
  }

  JSONObject getJSON(String filename) {
    return postJSON(filename, null);
  }

  JSONObject postJSON(String filename,JSONObject data) {
    boolean po=data!=null;
    resultCode=0;
    try {
      URL url = new URL(octoapi+filename);
      con = (HttpURLConnection) url.openConnection();
      con.setRequestMethod(po?"POST":"GET");
      con.setRequestProperty("Content-Type", "application/json");
      con.setRequestProperty("X-Api-Key", octoapikey);
      //
      con.setDoInput(true);
      if (po) {
        con.setDoOutput(true);
        OutputStream output = con.getOutputStream();
        output.write(data.toString().getBytes());
        //output.close(); // sjould ee?
      }
      con.connect();
      resultCode=con.getResponseCode();
   
      flash(filename+": "+resultCode
        +" "+con.getResponseMessage());
      InputStream response = con.getInputStream();
      InputStreamReader reader = new InputStreamReader(response, "UTF-8"); 
      return new JSONObject(reader);
      // ...
    } 
    // todo: clean up...when rturn null?
   // catch (MalformedURLException mfue) {
   //   println("malformed");
      // not a url, that's BAD
   // } 
    catch (FileNotFoundException fnfe) {
      println("fnf");
      // no response, see resultCode
      // Java 1.5 likes to throw this when URL not available. (fix for 0119)
      // http://dev.processing.org/bugs/show_bug.cgi?id=403
    } 
    catch (IOException e) {
      // changed for 0117, shouldn't be throwing exception
      printStackTrace(e);
      System.err.println("Error downloading from URL " + filename);
      return null;
      //throw new RuntimeException("Error downloading from URL " + filename);
    }
    return null;
  }
}



