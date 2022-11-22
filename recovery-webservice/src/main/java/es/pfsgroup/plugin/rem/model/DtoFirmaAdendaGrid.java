package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoFirmaAdendaGrid extends WebDto {

	private static final long serialVersionUID = 1L;

	private String firmado;
	private Date fecha;
	private String motivo;
	
	public String getFirmado() {
		return firmado;
	}
	public void setFirmado(String firmado) {
		this.firmado = firmado;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
}
