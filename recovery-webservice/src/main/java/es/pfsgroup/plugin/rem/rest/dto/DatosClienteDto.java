package es.pfsgroup.plugin.rem.rest.dto;

import es.capgemini.pfs.persona.model.DDTipoDocumento;

public class DatosClienteDto {
	
    private String nombre;
    private String apellidos;
	private DDTipoDocumento tipoDocumento;
    private String documento;
    
    
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellidos() {
		return apellidos;
	}
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	public DDTipoDocumento getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(DDTipoDocumento tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}

}
