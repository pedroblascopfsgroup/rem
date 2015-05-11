package es.pfsgroup.plugin.recovery.config.usuarios.dto;

public class ADMDtoGuardarDespachoSupervisor {
	
	private Long idusuario;
	
	private Boolean usuarioExterno;
	
	private Long despachoExterno;

	public void setIdusuario(Long idusuario) {
		this.idusuario = idusuario;
	}

	public Long getIdusuario() {
		return idusuario;
	}

	public void setUsuarioExterno(Boolean usuarioExterno) {
		this.usuarioExterno = usuarioExterno;
	}

	public Boolean getUsuarioExterno() {
		return usuarioExterno;
	}

	public void setDespachoExterno(Long despachoExterno) {
		this.despachoExterno = despachoExterno;
	}

	public Long getDespachoExterno() {
		return despachoExterno;
	}
	

}
