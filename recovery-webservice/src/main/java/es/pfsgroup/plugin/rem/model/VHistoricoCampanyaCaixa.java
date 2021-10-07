package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_HCC_HIST_CAMPANYA_CAIXA", schema = "${entity.schema}")
public class VHistoricoCampanyaCaixa implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;
	
	@Column(name = "ID_CAMPANYA_VENTA")
	private String tokenGmaps;
	
	@Column(name="ID_CAMPANYA_ALQUILER")
	private String latitud;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTokenGmaps() {
		return tokenGmaps;
	}

	public void setTokenGmaps(String tokenGmaps) {
		this.tokenGmaps = tokenGmaps;
	}

	public String getLatitud() {
		return latitud;
	}

	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}

}