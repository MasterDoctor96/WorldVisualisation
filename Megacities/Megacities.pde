// Daniel Shiffman
// http://codingtra.in
// Earthquake Data Viz
// Video: https://youtu.be/ZiYdOwOrGyc

PImage mapimg;

int clat = 0;
int clon = 0;

int ww = 1024;
int hh = 512;

int zoom = 1;
String[] earthquakes;
String[] cities;

int megacity=1000000;
int max_population = 0;

float mercX(float lon) {
  lon = radians(lon);
  float a = (256 / PI) * pow(2, zoom);
  float b = lon + PI;
  return a * b;
}

float mercY(float lat) {
  lat = radians(lat);
  float a = (256 / PI) * pow(2, zoom);
  float b = tan(PI / 4 + lat / 2);
  float c = PI - log(b);
  return a * c;
}


void setup() {
  size(1024, 512);
  // The clon and clat in this url are edited to be in the correct order.
  String url = "https://api.mapbox.com/styles/v1/mapbox/dark-v9/static/" +
    clon + "," + clat + "," + zoom + "/" +
    ww + "x" + hh +
    "?access_token=pk.eyJ1IjoiY29kaW5ndHJhaW4iLCJhIjoiY2l6MGl4bXhsMDRpNzJxcDh0a2NhNDExbCJ9.awIfnl6ngyHoB3Xztkzarw";
  mapimg = loadImage(url, "jpg");
  println(url);
  // earthquakes = loadStrings("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv");
  //earthquakes = loadStrings("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv");
  cities = loadStrings("https://masterdoctor96.github.io/WorldVisualisation/Data/worldcities.csv");

  translate(width / 2, height / 2);
  imageMode(CENTER);
  image(mapimg, 0, 0);

  float cx = mercX(clon);
  float cy = mercY(clat);
  
  for (int i =1; i< cities.length; i++){
  String[] data = cities[i].split(",");
  max_population = max(max_population, int (data[9]));
  }

  for (int i = 1; i < cities.length; i++) {
    String[] data = cities[i].split(",");
    float lat = float(data[2]);
    float lon = float(data[3]);
    float population = float(data[9]);
    float x = mercX(lon) - cx;
    float y = mercY(lat) - cy;
    // This addition fixes the case where the longitude is non-zero and
    // points can go off the screen.
    if(x < - width/2) {
      x += width;
    } else if(x > width / 2) {
      x -= width;
    }
    //mag = pow(10, mag);
    //float magmax = sqrt(pow(10, 10));
    if (Float.isNaN(population)|| population < megacity) {
      continue;
    }
    float d = map(population, megacity, max_population, 0, 15);
    stroke(255, 0, 255);
    fill(255, 0, 255, 200);
    ellipse(x, y, d, d);
  }
}
