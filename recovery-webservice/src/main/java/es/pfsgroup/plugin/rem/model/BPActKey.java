package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class BPActKey implements Serializable{
	
	private static final long serialVersionUID = 2886183623410450650L;

	@Column(name = "PVE_ID")
	private String id;
	
	@Column(name = "ACT_ID")
	private String idActivo;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
}