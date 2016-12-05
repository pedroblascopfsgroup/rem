package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class FileResponse implements Serializable{

	private static final long serialVersionUID = -8060274120749858608L;
	
	private String error;
	private File data;
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	public File getData() {
		return data;
	}
	public void setData(File data) {
		this.data = data;
	}
	

}
