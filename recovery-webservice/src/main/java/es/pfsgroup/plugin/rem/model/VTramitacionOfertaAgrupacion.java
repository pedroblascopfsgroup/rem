package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Modelo que gestiona la tramitación automatica de ofertas de una agrupación.
 * 
 * @author Álvaro Valero
 */
@Entity
@Table(name = "VI_TRAMITACION_OFR_AGR", schema = "${entity.schema}")
public class VTramitacionOfertaAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "APU_FECHA_CAMB_PUBL_VENTA")
	private Date fechaPublicacion;


	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}

	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
}
	
