package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;
import es.pfsgroup.plugin.rem.rest.dto.CodigoCarterasDto;

public class ProveedorDto implements WebcomRESTDto {

	@WebcomRequired //No se puede quitar
	private DateDataType fechaAccion;
	@WebcomRequired //No se puede quitar
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
	@MappedColumn("TELFONO_CONTACTO_VISITAS")
	private StringDataType telefonoContactoVisitas;
	private LongDataType numeroDelegaciones;
	private StringDataType nombreComercial;
	private LongDataType idProveedorRemAsociado;

	@WebcomRequired
	@NestedDto(groupBy="idProveedorRem", type=CodigoCarterasDto.class)
	private List<CodigoCarterasDto> arrCodCarteraAmbito;
	
	private StringDataType codOrigenPeticion;
	private StringDataType nombrePeticionario;
	private StringDataType codLineaNegocio;
	private StringDataType arrCodEspecialidad;
	private StringDataType arrCodIdioma;
	private StringDataType codGestionCnr;
	private LongDataType numComerciales;
	private DateDataType fechaUltContrato;
	private StringDataType motivoBaja;

	@NestedDto(groupBy = "idProveedorRem", type = DelegacionDto.class)
	private List<DelegacionDto> delegaciones;
	
	@NestedDto(groupBy = "idProveedorRem", type = ConductasInapropiadasDto.class)
	private List<ConductasInapropiadasDto> conductasInapropiadas;

	private DateDataType fechaAlta;
	private StringDataType codEstado;
	private DateDataType fechaBaja;
	private StringDataType codTipoPersona;
	private StringDataType urlWeb;
	private StringDataType nombreContacto;
	private StringDataType apellido1Contacto;
	private StringDataType apellido2Contacto;

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

	public StringDataType getTelefonoContactoVisitas() {
		return telefonoContactoVisitas;
	}

	public void setTelefonoContactoVisitas(StringDataType telefonoContactoVisitas) {
		this.telefonoContactoVisitas = telefonoContactoVisitas;
	}

	public LongDataType getNumeroDelegaciones() {
		return numeroDelegaciones;
	}

	public void setNumeroDelegaciones(LongDataType numeroDelegaciones) {
		this.numeroDelegaciones = numeroDelegaciones;
	}

	public StringDataType getNombreComercial() {
		return nombreComercial;
	}

	public void setNombreComercial(StringDataType nombreComercial) {
		this.nombreComercial = nombreComercial;
	}

	public List<CodigoCarterasDto> getArrCodCarteraAmbito() {
		return arrCodCarteraAmbito;
	}

	public void setArrCodCarteraAmbito( List<CodigoCarterasDto> arrCodCarteraAmbito) {
		this.arrCodCarteraAmbito = arrCodCarteraAmbito;
	}

	public LongDataType getIdProveedorRemAsociado() {
		return idProveedorRemAsociado;
	}

	public void setIdProveedorRemAsociado(LongDataType idProveedorRemAsociado) {
		this.idProveedorRemAsociado = idProveedorRemAsociado;
	}

	public StringDataType getCodOrigenPeticion() {
		return codOrigenPeticion;
	}

	public void setCodOrigenPeticion(StringDataType codOrigenPeticion) {
		this.codOrigenPeticion = codOrigenPeticion;
	}

	public StringDataType getNombrePeticionario() {
		return nombrePeticionario;
	}

	public void setNombrePeticionario(StringDataType nombrePeticionario) {
		this.nombrePeticionario = nombrePeticionario;
	}

	public StringDataType getCodLineaNegocio() {
		return codLineaNegocio;
	}

	public void setCodLineaNegocio(StringDataType codLineaNegocio) {
		this.codLineaNegocio = codLineaNegocio;
	}

	public StringDataType getArrCodEspecialidad() {
		return arrCodEspecialidad;
	}

	public void setArrCodEspecialidad(StringDataType arrCodEspecialidad) {
		this.arrCodEspecialidad = arrCodEspecialidad;
	}

	public StringDataType getArrCodIdioma() {
		return arrCodIdioma;
	}

	public void setArrCodIdioma(StringDataType arrCodIdioma) {
		this.arrCodIdioma = arrCodIdioma;
	}

	public StringDataType getCodGestionCnr() {
		return codGestionCnr;
	}

	public void setCodGestionCnr(StringDataType codGestionCnr) {
		this.codGestionCnr = codGestionCnr;
	}

	public LongDataType getNumComerciales() {
		return numComerciales;
	}

	public void setNumComerciales(LongDataType numComerciales) {
		this.numComerciales = numComerciales;
	}

	public DateDataType getFechaUltContrato() {
		return fechaUltContrato;
	}

	public void setFechaUltContrato(DateDataType fechaUltContrato) {
		this.fechaUltContrato = fechaUltContrato;
	}

	public StringDataType getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(StringDataType motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public List<ConductasInapropiadasDto> getConductasInapropiadas() {
		return conductasInapropiadas;
	}

	public void setConductasInapropiadas(List<ConductasInapropiadasDto> conductasInapropiadas) {
		this.conductasInapropiadas = conductasInapropiadas;
	}

	public DateDataType getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(DateDataType fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public StringDataType getCodEstado() {
		return codEstado;
	}

	public void setCodEstado(StringDataType codEstado) {
		this.codEstado = codEstado;
	}

	public DateDataType getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(DateDataType fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public StringDataType getCodTipoPersona() {
		return codTipoPersona;
	}

	public void setCodTipoPersona(StringDataType codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}

	public StringDataType getUrlWeb() {
		return urlWeb;
	}

	public void setUrlWeb(StringDataType urlWeb) {
		this.urlWeb = urlWeb;
	}

	public StringDataType getNombreContacto() {
		return nombreContacto;
	}

	public void setNombreContacto(StringDataType nombreContacto) {
		this.nombreContacto = nombreContacto;
	}

	public StringDataType getApellido1Contacto() {
		return apellido1Contacto;
	}

	public void setApellido1Contacto(StringDataType apellido1Contacto) {
		this.apellido1Contacto = apellido1Contacto;
	}

	public StringDataType getApellido2Contacto() {
		return apellido2Contacto;
	}

	public void setApellido2Contacto(StringDataType apellido2Contacto) {
		this.apellido2Contacto = apellido2Contacto;
	}
}
