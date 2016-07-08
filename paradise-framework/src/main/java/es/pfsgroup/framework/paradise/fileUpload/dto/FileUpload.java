package es.pfsgroup.framework.paradise.fileUpload.dto;

import org.springframework.web.multipart.MultipartFile;

public class FileUpload{
	
	MultipartFile fileUpload;

	public MultipartFile getFileUpload() {
		return fileUpload;
	}

	public void setFileUpload(MultipartFile fileUpload) {
		this.fileUpload = fileUpload;
	}

}