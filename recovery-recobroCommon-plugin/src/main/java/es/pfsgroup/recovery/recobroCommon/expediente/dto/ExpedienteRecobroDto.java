package es.pfsgroup.recovery.recobroCommon.expediente.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;

public class ExpedienteRecobroDto extends WebDto{

	private static final long serialVersionUID = 905669434617712563L;
	
	private RecobroCarteraEsquema carteraEsquema;
	private RecobroSubCartera subCartera;
	private RecobroAgencia agencia;
	private Date fechaAsignacion;
	private RecobroItinerarioMetasVolantes itinerarioMV;
	private Date fechaMaxEnAgencia;
	private Date fechaMaxCobroParcial;

	public RecobroCarteraEsquema getCarteraEsquema() {
		return carteraEsquema;
	}
	public void setCarteraEsquema(RecobroCarteraEsquema carteraEsquema) {
		this.carteraEsquema = carteraEsquema;
	}
	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}
	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}
	public RecobroAgencia getAgencia() {
		return agencia;
	}
	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}
	public Date getFechaAsignacion() {
		return fechaAsignacion;
	}
	public void setFechaAsignacion(Date fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
	}
	public RecobroItinerarioMetasVolantes getItinerarioMV() {
		return itinerarioMV;
	}
	public void setItinerarioMV(RecobroItinerarioMetasVolantes itinerarioMV) {
		this.itinerarioMV = itinerarioMV;
	}
	public Date getFechaMaxEnAgencia() {
		return fechaMaxEnAgencia;
	}
	public void setFechaMaxEnAgencia(Date fechaMaxEnAgencia) {
		this.fechaMaxEnAgencia = fechaMaxEnAgencia;
	}
	public Date getFechaMaxCobroParcial() {
		return fechaMaxCobroParcial;
	}
	public void setFechaMaxCobroParcial(Date fechaMaxCobroParcial) {
		this.fechaMaxCobroParcial = fechaMaxCobroParcial;
	}
	
}
