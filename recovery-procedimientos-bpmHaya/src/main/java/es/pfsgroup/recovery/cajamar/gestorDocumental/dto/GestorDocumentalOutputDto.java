package es.pfsgroup.recovery.cajamar.gestorDocumental.dto;

import java.util.List;

public class GestorDocumentalOutputDto {

	private String descEstado;
	private String estado;
	private String ficheroBase64;
	private String idDocumento;
	private String codError;
	private String txtError;
	private List<GestorDocumentalOutputListDto> lbListadoDocumentos;

	public String getDescEstado() {
		return descEstado;
	}

	public void setDescEstado(String descEstado) {
		this.descEstado = descEstado;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getFicheroBase64() {
		return ficheroBase64;
	}

	public void setFicheroBase64(String ficheroBase64) {
		this.ficheroBase64 = ficheroBase64;
	}

	public String getIdDocumento() {
		return idDocumento;
	}

	public void setIdDocumento(String idDocumento) {
		this.idDocumento = idDocumento;
	}

	public String getCodError() {
		return codError;
	}

	public void setCodError(String codError) {
		this.codError = codError;
	}

	public String getTxtError() {
		return txtError;
	}

	public void setTxtError(String txtError) {
		this.txtError = txtError;
	}

	public List<GestorDocumentalOutputListDto> getLbListadoDocumentos() {
		return lbListadoDocumentos;
	}

	public void setLbListadoDocumentos(
			List<GestorDocumentalOutputListDto> lbListadoDocumentos) {
		this.lbListadoDocumentos = lbListadoDocumentos;
	}

}
