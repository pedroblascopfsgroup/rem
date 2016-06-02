package es.pfsgroup.plugin.recovery.config.usuarios.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;

public class ADMDtoBusquedaUsuario extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7113974985774147873L;

	private Long idEntidad;

	private String username;

	private String nombre;

	private String apellido1;

	private String apellido2;

	private Boolean usuarioExterno;

	private String perfiles;

	private String centros;

	private String despachosExternos;

	private Long id;
	
	private String comboGestor;

	public String getComboGestor() {
		return comboGestor;
	}

	public void setComboGestor(String comboGestor) {
		this.comboGestor = comboGestor;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
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

	public Boolean getUsuarioExterno() {
		return usuarioExterno;
	}

	public void setUsuarioExterno(Boolean usuarioExterno) {
		this.usuarioExterno = usuarioExterno;
	}

	public void setDespachosExternos(String despachosExternos) {
		this.despachosExternos = despachosExternos;
	}

	public String getDespachosExternos() {
		return despachosExternos;
	}

	public void setCentros(String centros) {
		this.centros = centros;
	}

	public String getCentros() {
		return centros;
	}

	public void setPerfiles(String perfiles) {
		this.perfiles = perfiles;
	}

	public String getPerfiles() {
		return perfiles;
	}

	public void setIdEntidad(Long entidad) {
		this.idEntidad = entidad;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public String getUsuarioExternoSINO() {
		if (usuarioExterno)
			return DDSiNo.SI;
		else
			return DDSiNo.NO;
	}

	public void setUsuarioExternoSINO(String s) {
		if (!Checks.esNulo(s)) {
			usuarioExterno = DDSiNo.SI.equals(s);
		}
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

}
