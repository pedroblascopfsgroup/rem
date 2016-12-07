package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;

import org.codehaus.jackson.map.annotate.JsonDeserialize;

import es.pfsgroup.plugin.rem.rest.dto.deserializers.CustomJsonDateDeserializer;

public class FileSearch implements Serializable {

	private static final long serialVersionUID = 1080314832376365746L;
	private String id;
	@JsonDeserialize(using = CustomJsonDateDeserializer.class)
	private Date since;
	private HashMap<String, String> metadata;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Date getSince() {
		return since;
	}

	public void setSince(Date since) {
		this.since = since;
	}

	public HashMap<String, String> getMetadata() {
		return metadata;
	}

	public void setMetadata(HashMap<String, String> metadata) {
		this.metadata = metadata;
	}

}
