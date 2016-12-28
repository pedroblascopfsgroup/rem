package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.ArrayList;

public class FileListResponse implements Serializable {

	private static final long serialVersionUID = 1L;
	private String error;
	private ArrayList<File> data;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public ArrayList<File> getData() {
		return data;
	}

	public void setData(ArrayList<File> data) {
		this.data = data;
	}

}
