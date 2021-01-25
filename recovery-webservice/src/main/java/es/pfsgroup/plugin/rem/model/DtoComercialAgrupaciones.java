package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la pestaña comercial de Agrupación.
 * @author Julian Dolz
 */
public class DtoComercialAgrupaciones extends WebDto {

	private static final long serialVersionUID = 8456858084936661002L;
	
	private Boolean tramitable;
	private String motivoAutorizacionTramitacionCodigo;
	private String observacionesAutoTram;


	public Boolean getTramitable() {
		return tramitable;
	}
	public void setTramitable(Boolean tramitable) {
		this.tramitable = tramitable;
	}
	public String getMotivoAutorizacionTramitacionCodigo() {
		return motivoAutorizacionTramitacionCodigo;
	}
	public void setMotivoAutorizacionTramitacionCodigo(String motivoAutorizacionTramitacionCodigo) {
		this.motivoAutorizacionTramitacionCodigo = motivoAutorizacionTramitacionCodigo;
	}
	public String getObservacionesAutoTram() {
		return observacionesAutoTram;
	}
	public void setObservacionesAutoTram(String observacionesAutoTram) {
		this.observacionesAutoTram = observacionesAutoTram;
	}
}
