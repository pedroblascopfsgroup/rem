package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class DICDtoValorDiccionario extends WebDto{


	private static final long serialVersionUID = -1450476171439827199L;
	
	private Long idLineaEnDiccionario;
	
	@NotNull(message="plugin.diccionarios.messages.idDiccionarioNoVacio")
	private Long idDiccionarioEditable;
	
	@NotEmpty(message="plugin.diccionarios.messages.codigoNoVacio")
	private String codigo;
	
	@NotEmpty(message="plugin.diccionarios.messages.descripNoVacio")
	private String descripcion;
	
	@NotEmpty(message="plugin.diccionarios.messages.descripLargaNoVacio")
	private String descripcionLarga;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	public void setIdDiccionarioEditable(Long idDiccionarioEdiatble) {
		this.idDiccionarioEditable = idDiccionarioEdiatble;
	}
	public Long getIdDiccionarioEditable() {
		return idDiccionarioEditable;
	}
	public void setIdLineaEnDiccionario(Long idLineaEnDiccionario) {
		this.idLineaEnDiccionario = idLineaEnDiccionario;
	}
	public Long getIdLineaEnDiccionario() {
		return idLineaEnDiccionario;
	}

}
