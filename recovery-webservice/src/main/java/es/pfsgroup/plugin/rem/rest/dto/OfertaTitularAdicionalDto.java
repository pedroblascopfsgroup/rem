package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.Size;

public class OfertaTitularAdicionalDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	
	@Size(max=60)
	private String nombre;
	@Size(max=20)
	private String codTipoDocumento;
	@Size(max=14)
	private String documento;
	
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getCodTipoDocumento() {
		return codTipoDocumento;
	}
	public void setCodTipoDocumento(String codTipoDocumento) {
		this.codTipoDocumento = codTipoDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
		
	
}
