package es.pfsgroup.plugin.recovery.masivo.utils;

import org.springframework.web.multipart.MultipartFile;
//TODO: comprobar si esta clase se utiliza, parece ser que no.
public class FileUpload {
	MultipartFile file;

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public MultipartFile getFile() {
		return file;
	}
}
