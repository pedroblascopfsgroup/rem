package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.ArrayList;

public class WebHookRequest implements Serializable {

	private static final long serialVersionUID = 8505243709971217606L;
	private ArrayList<File> modified;
	private ArrayList<File> deleted;

	public ArrayList<File> getModified() {
		return modified;
	}

	public void setModified(ArrayList<File> modified) {
		this.modified = modified;
	}

	public ArrayList<File> getDeleted() {
		return deleted;
	}

	public void setDeleted(ArrayList<File> deleted) {
		this.deleted = deleted;
	}

}
