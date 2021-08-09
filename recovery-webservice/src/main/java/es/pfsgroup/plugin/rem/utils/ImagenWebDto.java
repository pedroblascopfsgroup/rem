package es.pfsgroup.plugin.rem.utils;

import java.io.Serializable;

public class ImagenWebDto implements Serializable {
	
 public String imageName; 
 public String imageDetails;
 public byte[] image;
 
public String getImageName() {
	return imageName;
}
public void setImageName(String imageName) {
	this.imageName = imageName;
}
public String getImageDetails() {
	return imageDetails;
}
public void setImageDetails(String imageDetails) {
	this.imageDetails = imageDetails;
}
public byte[] getImage() {
	return image;
}
public void setImage(byte[] image) {
	this.image = image;
}
	

}
