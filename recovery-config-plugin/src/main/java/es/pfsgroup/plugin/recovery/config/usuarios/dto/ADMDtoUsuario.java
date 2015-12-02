package es.pfsgroup.plugin.recovery.config.usuarios.dto;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class ADMDtoUsuario extends WebDto {

	private static final long serialVersionUID = 5571649487824502752L;

	private Long id;

	@NotEmpty(message = "plugin.config.usuarios.alta.message.usernameEmpty")
	@NotNull(message = "plugin.config.usuarios.alta.message.usernameEmpty")
	@Size(max = 50, message = "plugin.config.usuarios.alta.message.usernameSize")
	private String username;

	private String password;
	
	@NotEmpty(message = "plugin.config.usuarios.alta.message.nombreEmpty")
	@NotNull(message = "plugin.config.usuarios.alta.message.nombreEmpty")
	private String nombre;

	private String apellido1;

	private String apellido2;

	private String email;

	private String telefono;

	private Boolean usuarioExterno;

	private Boolean usuarioGrupo;
	
	private Long despachoExterno;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public Boolean getUsuarioExterno() {
		return usuarioExterno;
	}

	public void setUsuarioExterno(Boolean usuarioExterno) {
		this.usuarioExterno = usuarioExterno;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setDespachoExterno(Long despachoExterno) {
		this.despachoExterno = despachoExterno;
	}

	public Long getDespachoExterno() {
		return despachoExterno;
	}

	public Boolean getUsuarioGrupo() {
		return usuarioGrupo;
	}

	public void setUsuarioGrupo(Boolean usuarioGrupo) {
		this.usuarioGrupo = usuarioGrupo;
	}

}
