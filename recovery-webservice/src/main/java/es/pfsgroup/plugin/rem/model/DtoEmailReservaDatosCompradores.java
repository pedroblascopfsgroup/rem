package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoEmailReservaDatosCompradores extends WebDto {

	private static final long serialVersionUID = 0L;

	private String nombreCompleto;
	private String tipoDocumento;
	private String documento;
	
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
}