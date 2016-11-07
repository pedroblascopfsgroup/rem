package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el grid de llaves en la pestaña situacion posesoria y llaves del Activo.
 */
public class DtoLlaves extends WebDto {

	private static final long serialVersionUID = 1L;

	private String id;// id LLave
	private String idActivo;
	private String nomCentroLlave;
	private String codCentroLlave;
	private String archivo1;
	private String archivo2;
	private String archivo3;
	private Integer juegoCompleto;
	private String motivoIncompleto;
	private String numLlave;


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public void setIdEntidad(String idEntidad) {
		this.idActivo = idEntidad;
	}
	public String getNomCentroLlave() {
		return nomCentroLlave;
	}
	public void setNomCentroLlave(String nomCentroLlave) {
		this.nomCentroLlave = nomCentroLlave;
	}
	public String getArchivo1() {
		return archivo1;
	}
	public void setArchivo1(String archivo1) {
		this.archivo1 = archivo1;
	}
	public String getArchivo2() {
		return archivo2;
	}
	public void setArchivo2(String archivo2) {
		this.archivo2 = archivo2;
	}
	public String getArchivo3() {
		return archivo3;
	}
	public void setArchivo3(String archivo3) {
		this.archivo3 = archivo3;
	}
	public Integer getJuegoCompleto() {
		return juegoCompleto;
	}
	public void setJuegoCompleto(Integer juegoCompleto) {
		this.juegoCompleto = juegoCompleto;
	}
	public String getMotivoIncompleto() {
		return motivoIncompleto;
	}
	public void setMotivoIncompleto(String motivoIncompleto) {
		this.motivoIncompleto = motivoIncompleto;
	}
	public String getCodCentroLlave() {
		return codCentroLlave;
	}
	public void setCodCentroLlave(String codCentroLlave) {
		this.codCentroLlave = codCentroLlave;
	}
	public String getNumLlave() {
		return numLlave;
	}
	public void setNumLlave(String numLlave) {
		this.numLlave = numLlave;
	}
	
}