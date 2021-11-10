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
	private String necesidadArras;
	private String canalVentaBc;
	private String canalAlquilerBc;
	private String codCartera;
	private String codAgrupacion;


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
	public String getNecesidadArras() {
		return necesidadArras;
	}
	public void setNecesidadArras(String necesidadArras) {
		this.necesidadArras = necesidadArras;
	}
	public String getCanalVentaBc() {
		return canalVentaBc;
	}
	public void setCanalVentaBc(String canalVentaBc) {
		this.canalVentaBc = canalVentaBc;
	}
	public String getCanalAlquilerBc() {
		return canalAlquilerBc;
	}
	public void setCanalAlquilerBc(String canalAlquilerBc) {
		this.canalAlquilerBc = canalAlquilerBc;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getCodAgrupacion() {
		return codAgrupacion;
	}
	public void setCodAgrupacion(String codAgrupacion) {
		this.codAgrupacion = codAgrupacion;
	}
}
