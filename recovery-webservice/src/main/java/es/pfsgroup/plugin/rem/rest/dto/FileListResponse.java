package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class FileListResponse implements Serializable {

	private static final long serialVersionUID = 1L;
	private String error;
	private FileList data;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public FileList getData() {
		return data;
	}

	public void setData(FileList data) {
		this.data = data;
	}

}
