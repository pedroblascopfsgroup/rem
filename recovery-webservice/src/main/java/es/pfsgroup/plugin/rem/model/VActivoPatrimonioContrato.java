package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Modelo que gestiona el patrimonio de un activo.
 * 
 * @author Luis Adelantado
 */
@Entity
@Table(name = "VI_CONTRATO_ALQ", schema = "${entity.schema}")
public class VActivoPatrimonioContrato implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private Long activo;
	
	@Column(name = "DD_TPA_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String localizacion;
	
	@Column(name = "DCA_ID_CONTRATO")
	private String idContrato;

	public Long getActivo() {
		return activo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public String getLocalizacion() {
		return localizacion;
	}

	public String getIdContrato() {
		return idContrato;
	}

	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public void setLocalizacion(String localizacion) {
		this.localizacion = localizacion;
	}

	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}
	
	
}
	