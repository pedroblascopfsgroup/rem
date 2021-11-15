package es.pfsgroup.plugin.rem.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;


@Entity
@Table(name = "VI_GRID_TASACIONES_GASTOS_BUSQUEDA", schema = "${entity.schema}")
public class VTasacionesGastosBusqueda implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "TAS_ID")
	private Long idTasacion;
	
	@Column(name = "ACT_ID")
	private Long idActivo;

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "TAS_ID_EXTERNO")
	private Long idTasacionExt;
	
	@Column(name = "TAS_CODIGO_FIRMA")
	private Long codigoFirmaTasacion;

	@Column(name = "TAS_FECHA_RECEPCION_TASACION")
	private Date fechaRecepcionTasacion;

	public Long getIdTasacion() {
		return idTasacion;
	}

	public void setIdTasacion(Long idTasacion) {
		this.idTasacion = idTasacion;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getIdTasacionExt() {
		return idTasacionExt;
	}

	public void setIdTasacionExt(Long idTasacionExt) {
		this.idTasacionExt = idTasacionExt;
	}

	public Long getCodigoFirmaTasacion() {
		return codigoFirmaTasacion;
	}

	public void setCodigoFirmaTasacion(Long codigoFirmaTasacion) {
		this.codigoFirmaTasacion = codigoFirmaTasacion;
	}

	public Date getFechaRecepcionTasacion() {
		return fechaRecepcionTasacion;
	}

	public void setFechaRecepcionTasacion(Date fechaRecepcionTasacion) {
		this.fechaRecepcionTasacion = fechaRecepcionTasacion;
	}
}