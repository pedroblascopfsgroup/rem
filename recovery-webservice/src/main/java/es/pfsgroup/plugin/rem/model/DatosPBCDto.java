package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class DatosPBCDto implements Serializable {
	String codigoOferta;
    Boolean of_sospechosa;
    String medioPago;
    String entidadFinanciera;
    Boolean ocultaIdentidadTitular;
    Boolean actitudIncoherente;
    Boolean pagoIntermediario;
    Boolean titulosPortador;
    String paisTranferencia;
    String finalidadOperacion;
    String motivoCompra;
    Double ori_fondosPropios;
    Double ori_fondosBanco;
    String proc_fondosPropios;
    Boolean deteccionIndicio;
    String sancionPBCHRE;
    Date fch_sancionPBCHRE;
    String informePBCHRE;
    String riesgoOperacion;
    List<InterlocutoresDto> interlocutores;
    List<InterlocutorOfertaDto> Interlocutor_oferta;
    String validarDocumentacion;
    Boolean replicarOferta;
    String otro_proc_fondosPropios;
    String cuentaBancaria;
    String otraEntidadBancaria;
    String otra_finalidadOperacion;
    String otra_entidadfinanciera;
	public String getCodigoOferta() {
		return codigoOferta;
	}
	public void setCodigoOferta(String codigoOferta) {
		this.codigoOferta = codigoOferta;
	}
	public Boolean getOf_sospechosa() {
		return of_sospechosa;
	}
	public void setOf_sospechosa(Boolean of_sospechosa) {
		this.of_sospechosa = of_sospechosa;
	}
	public String getMedioPago() {
		return medioPago;
	}
	public void setMedioPago(String medioPago) {
		this.medioPago = medioPago;
	}
	public String getEntidadFinanciera() {
		return entidadFinanciera;
	}
	public void setEntidadFinanciera(String entidadFinanciera) {
		this.entidadFinanciera = entidadFinanciera;
	}
	public Boolean getOcultaIdentidadTitular() {
		return ocultaIdentidadTitular;
	}
	public void setOcultaIdentidadTitular(Boolean ocultaIdentidadTitular) {
		this.ocultaIdentidadTitular = ocultaIdentidadTitular;
	}
	public Boolean getActitudIncoherente() {
		return actitudIncoherente;
	}
	public void setActitudIncoherente(Boolean actitudIncoherente) {
		this.actitudIncoherente = actitudIncoherente;
	}
	public Boolean getPagoIntermediario() {
		return pagoIntermediario;
	}
	public void setPagoIntermediario(Boolean pagoIntermediario) {
		this.pagoIntermediario = pagoIntermediario;
	}
	public Boolean getTitulosPortador() {
		return titulosPortador;
	}
	public void setTitulosPortador(Boolean titulosPortador) {
		this.titulosPortador = titulosPortador;
	}
	public String getPaisTranferencia() {
		return paisTranferencia;
	}
	public void setPaisTranferencia(String paisTranferencia) {
		this.paisTranferencia = paisTranferencia;
	}
	public String getFinalidadOperacion() {
		return finalidadOperacion;
	}
	public void setFinalidadOperacion(String finalidadOperacion) {
		this.finalidadOperacion = finalidadOperacion;
	}
	public String getMotivoCompra() {
		return motivoCompra;
	}
	public void setMotivoCompra(String motivoCompra) {
		this.motivoCompra = motivoCompra;
	}
	public Double getOri_fondosPropios() {
		return ori_fondosPropios;
	}
	public void setOri_fondosPropios(Double ori_fondosPropios) {
		this.ori_fondosPropios = ori_fondosPropios;
	}
	public Double getOri_fondosBanco() {
		return ori_fondosBanco;
	}
	public void setOri_fondosBanco(Double ori_fondosBanco) {
		this.ori_fondosBanco = ori_fondosBanco;
	}
	public String getProc_fondosPropios() {
		return proc_fondosPropios;
	}
	public void setProc_fondosPropios(String proc_fondosPropios) {
		this.proc_fondosPropios = proc_fondosPropios;
	}
	public Boolean getDeteccionIndicio() {
		return deteccionIndicio;
	}
	public void setDeteccionIndicio(Boolean deteccionIndicio) {
		this.deteccionIndicio = deteccionIndicio;
	}
	public String getSancionPBCHRE() {
		return sancionPBCHRE;
	}
	public void setSancionPBCHRE(String sancionPBCHRE) {
		this.sancionPBCHRE = sancionPBCHRE;
	}
	public Date getFch_sancionPBCHRE() {
		return fch_sancionPBCHRE;
	}
	public void setFch_sancionPBCHRE(Date fch_sancionPBCHRE) {
		this.fch_sancionPBCHRE = fch_sancionPBCHRE;
	}
	public String getInformePBCHRE() {
		return informePBCHRE;
	}
	public void setInformePBCHRE(String informePBCHRE) {
		this.informePBCHRE = informePBCHRE;
	}
	public String getRiesgoOperacion() {
		return riesgoOperacion;
	}
	public void setRiesgoOperacion(String riesgoOperacion) {
		this.riesgoOperacion = riesgoOperacion;
	}
	public List<InterlocutoresDto> getInterlocutores() {
		return interlocutores;
	}
	public void setInterlocutores(List<InterlocutoresDto> interlocutores) {
		this.interlocutores = interlocutores;
	}
	public List<InterlocutorOfertaDto> getInterlocutor_oferta() {
		return Interlocutor_oferta;
	}
	public void setInterlocutor_oferta(List<InterlocutorOfertaDto> interlocutor_oferta) {
		Interlocutor_oferta = interlocutor_oferta;
	}
	public String getValidarDocumentacion() {
		return validarDocumentacion;
	}
	public void setValidarDocumentacion(String validarDocumentacion) {
		this.validarDocumentacion = validarDocumentacion;
	}
	public Boolean getReplicarOferta() {
		return replicarOferta;
	}
	public void setReplicarOferta(Boolean replicarOferta) {
		this.replicarOferta = replicarOferta;
	}
	public String getOtro_proc_fondosPropios() {
		return otro_proc_fondosPropios;
	}
	public void setOtro_proc_fondosPropios(String otro_proc_fondosPropios) {
		this.otro_proc_fondosPropios = otro_proc_fondosPropios;
	}
	public String getCuentaBancaria() {
		return cuentaBancaria;
	}
	public void setCuentaBancaria(String cuentaBancaria) {
		this.cuentaBancaria = cuentaBancaria;
	}
	public String getOtraEntidadBancaria() {
		return otraEntidadBancaria;
	}
	public void setOtraEntidadBancaria(String otraEntidadBancaria) {
		this.otraEntidadBancaria = otraEntidadBancaria;
	}
	public String getOtra_finalidadOperacion() {
		return otra_finalidadOperacion;
	}
	public void setOtra_finalidadOperacion(String otra_finalidadOperacion) {
		this.otra_finalidadOperacion = otra_finalidadOperacion;
	}
	public String getOtra_entidadfinanciera() {
		return otra_entidadfinanciera;
	}
	public void setOtra_entidadfinanciera(String otra_entidadfinanciera) {
		this.otra_entidadfinanciera = otra_entidadfinanciera;
	}
    
	
    
}