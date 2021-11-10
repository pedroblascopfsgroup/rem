package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoOfertantesOferta extends WebDto {

	private static final long serialVersionUID = 1L;

	private String ofertaID;
	private String id;
	private String tipoDocumento;
	private String numDocumento;
	private String nombre;
	private String tipoPersona;
	private String estadoCivil;
	private String regimenMatrimonial;
	private Long ADCOMIdDocumentoIdentificativo;
	private Long ADCOMIdDocumentoGDPR;
	private String vinculoCaixaDesc;
	private String aceptacionOferta;



	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOfertaID() {
		return ofertaID;
	}
	public void setOfertaID(String ofertaID) {
		this.ofertaID = ofertaID;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getNumDocumento() {
		return numDocumento;
	}
	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getRegimenMatrimonial() {
		return regimenMatrimonial;
	}
	public void setRegimenMatrimonial(String regimenMatrimonial) {
		this.regimenMatrimonial = regimenMatrimonial;
	}
	public Long getADCOMIdDocumentoIdentificativo() {
		return ADCOMIdDocumentoIdentificativo;
	}
	public void setADCOMIdDocumentoIdentificativo(Long aDCOMIdDocumentoIdentificativo) {
		ADCOMIdDocumentoIdentificativo = aDCOMIdDocumentoIdentificativo;
	}
	public Long getADCOMIdDocumentoGDPR() {
		return ADCOMIdDocumentoGDPR;
	}
	public void setADCOMIdDocumentoGDPR(Long aDCOMIdDocumentoGDPR) {
		ADCOMIdDocumentoGDPR = aDCOMIdDocumentoGDPR;
	}
	public String getVinculoCaixaDesc() {
		return vinculoCaixaDesc;
	}
	public void setVinculoCaixaDesc(String vinculoCaixaDesc) {
		this.vinculoCaixaDesc = vinculoCaixaDesc;
	}
	
	public String getAceptacionOferta() {
		return aceptacionOferta;
	}
	public void setAceptacionOferta(String aceptacionOferta) {
		this.aceptacionOferta = aceptacionOferta;
	}
}