package es.pfsgroup.plugin.rem.model;

import es.pfsgroup.commons.utils.Checks;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;


@Entity
@Table(name = "VI_GRID_TASACIONES_GASTOS", schema = "${entity.schema}")
public class VTasacionesGastos implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="ID")
	private Long id;
	
	@Column(name= "GPV_ID")
	private Long idGasto;
	
	@Column(name = "TAS_ID")
	private Long idTasacion;
	
	@Column(name = "ACT_ID")
	private Long idActivo;

	@Column(name = "GPV_NUM_GASTO_HAYA")
	private Long numGastoHaya;

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "TAS_ID_EXTERNO")
	private Long idTasacionExt;
	
	@Column(name = "TAS_CODIGO_FIRMA")
	private Long codigoFirmaTasacion;

	@Column(name = "TAS_FECHA_RECEPCION_TASACION")
	private Date fechaRecepcionTasacion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

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

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
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