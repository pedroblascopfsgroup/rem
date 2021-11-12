package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.Date;

public class DtoFiltroTasaciones extends WebDto {

	private Long idTasacion;
	private Long idActivo;
	private Long numActivo;
	private Long idTasacionExt;
	private Long codigoFirmaTasacion;
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