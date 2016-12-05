package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.HashMap;

public class FileUpload implements Serializable {

	private static final long serialVersionUID = 8761637017935985517L;
	private Integer id;
	private String file_base64;
	private String basename;
	private HashMap<String, String> metadata;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getFile_base64() {
		return file_base64;
	}

	public void setFile_base64(String file_base64) {
		this.file_base64 = file_base64;
	}

	public String getBasename() {
		return basename;
	}

	public void setBasename(String basename) {
		this.basename = basename;
	}

	public HashMap<String, String> getMetadata() {
		return metadata;
	}

	public void setMetadata(HashMap<String, String> metadata) {
		this.metadata = metadata;
	}

}
