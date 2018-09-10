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
@Table(name = "V_CALCULO_ACTIVO_AGRUPACION", schema = "${entity.schema}")
public class VCalculosActivoAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "NUM_ACTIVOS")
	private Long numActivos;
	
	@Column(name = "ACT_PUBLICADOS")
	private Long numActivosPublicados;

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Long getNumActivos() {
		return numActivos;
	}

	public void setNumActivos(Long numActivos) {
		this.numActivos = numActivos;
	}

	public Long getNumActivosPublicados() {
		return numActivosPublicados;
	}

	public void setNumActivosPublicados(Long numActivosPublicados) {
		this.numActivosPublicados = numActivosPublicados;
	}
	
	
	
}