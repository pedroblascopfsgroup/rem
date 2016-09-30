package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class UsuarioDto implements WebcomRESTDto{

	@WebcomRequired
	private LongDataType id;
	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private LongDataType idProveedorRem;
	@WebcomRequired
	private LongDataType idUsuarioRem;
	private StringDataType usuarioLdap;
	@WebcomRequired
	private StringDataType nombre;
	private StringDataType apellidos;
	private StringDataType telefono1;
	private StringDataType telefono2;
	private StringDataType email;
	@WebcomRequired
	private BooleanDataType activo;
	
	public LongDataType getId() {
		return id;
	}
	public void setId(LongDataType id) {
		this.id = id;
	}
	public DateDataType getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(LongDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}
	public LongDataType getIdUsuarioRem() {
		return idUsuarioRem;
	}
	public void setIdUsuarioRem(LongDataType idUsuarioRem) {
		this.idUsuarioRem = idUsuarioRem;
	}
	public StringDataType getUsuarioLdap() {
		return usuarioLdap;
	}
	public void setUsuarioLdap(StringDataType usuarioLdap) {
		this.usuarioLdap = usuarioLdap;
	}
	public StringDataType getNombre() {
		return nombre;
	}
	public void setNombre(StringDataType nombre) {
		this.nombre = nombre;
	}
	public StringDataType getApellidos() {
		return apellidos;
	}
	public void setApellidos(StringDataType apellidos) {
		this.apellidos = apellidos;
	}
	public StringDataType getTelefono1() {
		return telefono1;
	}
	public void setTelefono1(StringDataType telefono1) {
		this.telefono1 = telefono1;
	}
	public StringDataType getTelefono2() {
		return telefono2;
	}
	public void setTelefono2(StringDataType telefono2) {
		this.telefono2 = telefono2;
	}
	public StringDataType getEmail() {
		return email;
	}
	public void setEmail(StringDataType email) {
		this.email = email;
	}
	public BooleanDataType getActivo() {
		return activo;
	}
	public void setActivo(BooleanDataType activo) {
		this.activo = activo;
	}
}
