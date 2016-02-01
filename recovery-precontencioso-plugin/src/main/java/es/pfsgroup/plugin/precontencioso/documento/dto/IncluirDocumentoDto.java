package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import es.capgemini.pfs.direccion.model.DDProvincia;

public class IncluirDocumentoDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1042740703163518903L;

	private String protocolo;
	private String tomo;
	private String libro;
	private String folio;
	private String idufir;
	private String asiento;
	private String finca;
	private String notario;
	private String numFinca;
	private String numRegistro;
	private String provinciaNotario;
	
	public String getProtocolo() {
		return protocolo;
	}
	public void setProtocolo(String protocolo) {
		this.protocolo = protocolo;
	}
	public String getTomo() {
		return tomo;
	}
	public void setTomo(String tomo) {
		this.tomo = tomo;
	}
	public String getLibro() {
		return libro;
	}
	public void setLibro(String libro) {
		this.libro = libro;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getIdufir() {
		return idufir;
	}
	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}
	public String getAsiento() {
		return asiento;
	}
	public void setAsiento(String asiento) {
		this.asiento = asiento;
	}
	public String getFinca() {
		return finca;
	}
	public void setFinca(String finca) {
		this.finca = finca;
	}
	public String getNotario() {
		return notario;
	}
	public void setNotario(String notario) {
		this.notario = notario;
	}
	public String getNumFinca() {
		return numFinca;
	}
	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	public String getNumRegistro() {
		return numRegistro;
	}
	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}
	public String getProvinciaNotario() {
		return provinciaNotario;
	}
	public void setProvinciaNotario(String provinciaNotario) {
		this.provinciaNotario = provinciaNotario;
	}
	


}
