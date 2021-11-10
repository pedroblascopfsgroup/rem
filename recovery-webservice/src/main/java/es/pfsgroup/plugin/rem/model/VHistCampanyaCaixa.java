package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;


@Entity
@Table(name = "V_HCC_HIST_CAMPANYA_CAIXA", schema = "${entity.schema}")
public class VHistCampanyaCaixa implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "ID_CAMPANYA_VENTA")
	private String idCampanyaVenta;
	
	@Column(name = "ID_CAMPANYA_ALQUILER")
	private String idCampanyaAlquiler;

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getIdCampanyaVenta() {
		return idCampanyaVenta;
	}

	public void setIdCampanyaVenta(String idCampanyaVenta) {
		this.idCampanyaVenta = idCampanyaVenta;
	}

	public String getIdCampanyaAlquiler() {
		return idCampanyaAlquiler;
	}

	public void setIdCampanyaAlquiler(String idCampanyaAlquiler) {
		this.idCampanyaAlquiler = idCampanyaAlquiler;
	}

	

	
	
	
}