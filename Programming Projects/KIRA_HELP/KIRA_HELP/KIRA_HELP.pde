//Color = 163,73,164

import java.io.File;

String image_dir_string;
File image_dir;
File[] files;

ArrayList<PVector> posAdjs;
float adjScl;

ArrayList<Float> rotAdjs;
float adjRotScl;

int n;

ArrayList<PImage> images;

void setup()
{
  	fullScreen();


	image_dir_string = "C:/Users/danlo/OneDrive/Desktop/Programming Projects/KIRA_HELP/KIRA_HELP/data";
	image_dir        = new File(image_dir_string); 

	files = image_dir.listFiles();

  // Load the images
	images = new ArrayList<PImage>();
	for( int i=0; i < files.length; i++ ){ 
		String path = files[i].getAbsolutePath();

		// check the file type and work with jpg/png files
		if( path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png") ) {

			PImage image = loadImage( path );
			images.add( image );

			println(path);
		}
	}

	println(images.size());
}

void draw()
{
	addAlphaToAll();
	image(images.get(0),0,0);
}


void addAlphaToAll()
{
	for (int i = 0; i < images.size(); i++)
	{
		PImage c_image = images.get(i);
		addAlpha(c_image);
		c_image.save(files[i].getAbsolutePath());
	}
}

void addAlpha(PImage image)
{
	image.loadPixels();
	for (int i = 0; i < image.pixels.length; i++)
	{
		if (image.pixels[i] == color(163,73,164))
		{
			color col = color(0,0,0, 0);
			image.pixels[i] = col;
		}
	}
	image.updatePixels();
}