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
	private String campanyaVenta;
	
	@Column(name="ID_CAMPANYA_ALQUILER")
	private String campanyaAlquiler;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCampanyaVenta() {
		return campanyaVenta;
	}

	public void setCampanyaVenta(String campanyaVenta) {
		this.campanyaVenta = campanyaVenta;
	}

	public String getCampanyaAlquiler() {
		return campanyaAlquiler;
	}

	public void setCampanyaAlquiler(String campanyaAlquiler) {
		this.campanyaAlquiler = campanyaAlquiler;
	}



}