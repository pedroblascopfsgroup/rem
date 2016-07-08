package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

import es.capgemini.devon.files.FileItem;

public class ExcelFileBean implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5584986150374292063L;
	
	private FileItem fileItem;
	
	public FileItem getFileItem() {
		return fileItem;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
	}



}
