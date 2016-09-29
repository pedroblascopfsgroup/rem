package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class ProveedorDto implements WebcomRESTDto {

	private DateDataType fechaAccion;
	private LongDataType idUsuarioRemAccion;

	@WebcomRequired
	private StringDataType codTipoProveedor;
	@WebcomRequired
	private LongDataType idProveedorRem;
	@WebcomRequired
	private StringDataType codigoProveedor;
	private StringDataType nombre;
	private StringDataType apellidos;
	private StringDataType codTipoVia;
	private StringDataType nombreCalle;
	private StringDataType numeroCalle;
	private StringDataType escalera;
	private StringDataType planta;
	private StringDataType puerta;
	private StringDataType codMunicipio;
	private StringDataType codPedania;
	private StringDataType codProvincia;
	private StringDataType codigoPostal;
	private StringDataType telefono1;
	private StringDataType telefono2;
	private StringDataType email;
	private StringDataType dd;
	private StringDataType dz;
	private StringDataType dt;
	private BooleanDataType modificarInformes;
	private BooleanDataType activo;
	private BooleanDataType abierta;

	@NestedDto(groupBy = "idProveedorRem", type = DelegacionDto.class)
	private List<DelegacionDto> delegaciones;

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

	public StringDataType getCodTipoProveedor() {
		return codTipoProveedor;
	}

	public void setCodTipoProveedor(StringDataType codTipoProveedor) {
		this.codTipoProveedor = codTipoProveedor;
	}

	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}

	public void setIdProveedorRem(LongDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}

	public StringDataType getCodigoProveedor() {
		return codigoProveedor;
	}

	public void setCodigoProveedor(StringDataType codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
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

	public StringDataType getCodTipoVia() {
		return codTipoVia;
	}

	public void setCodTipoVia(StringDataType codTipoVia) {
		this.codTipoVia = codTipoVia;
	}

	public StringDataType getNombreCalle() {
		return nombreCalle;
	}

	public void setNombreCalle(StringDataType nombreCalle) {
		this.nombreCalle = nombreCalle;
	}

	public StringDataType getNumeroCalle() {
		return numeroCalle;
	}

	public void setNumeroCalle(StringDataType numeroCalle) {
		this.numeroCalle = numeroCalle;
	}

	public StringDataType getEscalera() {
		return escalera;
	}

	public void setEscalera(StringDataType escalera) {
		this.escalera = escalera;
	}

	public StringDataType getPlanta() {
		return planta;
	}

	public void setPlanta(StringDataType planta) {
		this.planta = planta;
	}

	public StringDataType getPuerta() {
		return puerta;
	}

	public void setPuerta(StringDataType puerta) {
		this.puerta = puerta;
	}

	public StringDataType getCodMunicipio() {
		return codMunicipio;
	}

	public void setCodMunicipio(StringDataType codMunicipio) {
		this.codMunicipio = codMunicipio;
	}

	public StringDataType getCodPedania() {
		return codPedania;
	}

	public void setCodPedania(StringDataType codPedania) {
		this.codPedania = codPedania;
	}

	public StringDataType getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(StringDataType codProvincia) {
		this.codProvincia = codProvincia;
	}

	public StringDataType getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(StringDataType codigoPostal) {
		this.codigoPostal = codigoPostal;
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

	public StringDataType getDd() {
		return dd;
	}

	public void setDd(StringDataType dd) {
		this.dd = dd;
	}

	public StringDataType getDz() {
		return dz;
	}

	public void setDz(StringDataType dz) {
		this.dz = dz;
	}

	public StringDataType getDt() {
		return dt;
	}

	public void setDt(StringDataType dt) {
		this.dt = dt;
	}

	public BooleanDataType getModificarInformes() {
		return modificarInformes;
	}

	public void setModificarInformes(BooleanDataType modificarInformes) {
		this.modificarInformes = modificarInformes;
	}

	public BooleanDataType getActivo() {
		return activo;
	}

	public void setActivo(BooleanDataType activo) {
		this.activo = activo;
	}

	public BooleanDataType getAbierta() {
		return abierta;
	}

	public void setAbierta(BooleanDataType abierta) {
		this.abierta = abierta;
	}

	public List<DelegacionDto> getDelegaciones() {
		return delegaciones;
	}

	public void setDelegaciones(List<DelegacionDto> delegaciones) {
		this.delegaciones = delegaciones;
	}
}
