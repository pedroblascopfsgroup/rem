package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class CampanyaObrasNuevasDto implements WebcomRESTDto{

	@WebcomRequired
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired
	private StringDataType codTipoAgrupacion;
	@WebcomRequired
	private LongDataType idAgrupacionRem;
	private StringDataType codCartera;
	private StringDataType nombre;
	private DateDataType fechaAlta;
	private DateDataType desde;
	private DateDataType hasta;
	private StringDataType codEstadoAgrupacion;
	private StringDataType codMunicipio;
	private StringDataType codigoPostal;
	private StringDataType codProvincia;	
	@MappedColumn("ID_GESTOR_COMERCIAL")
	private LongDataType idProveedorRemGestorComercial;
	private LongDataType idProveedorRem;
	private StringDataType descripcion;
	private LongDataType asociadosActivos;
	
	//Petición HREOS-1551
	private StringDataType codSubCartera;

	
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
	public StringDataType getCodTipoAgrupacion() {
		return codTipoAgrupacion;
	}
	public void setCodTipoAgrupacion(StringDataType codTipoAgrupacion) {
		this.codTipoAgrupacion = codTipoAgrupacion;
	}
	public LongDataType getIdAgrupacionRem() {
		return idAgrupacionRem;
	}
	public void setIdAgrupacionRem(LongDataType idAgrupacionRem) {
		this.idAgrupacionRem = idAgrupacionRem;
	}
	public StringDataType getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(StringDataType codCartera) {
		this.codCartera = codCartera;
	}
	public StringDataType getNombre() {
		return nombre;
	}
	public void setNombre(StringDataType nombre) {
		this.nombre = nombre;
	}
	public DateDataType getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(DateDataType fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public DateDataType getDesde() {
		return desde;
	}
	public void setDesde(DateDataType desde) {
		this.desde = desde;
	}
	public DateDataType getHasta() {
		return hasta;
	}
	public void setHasta(DateDataType hasta) {
		this.hasta = hasta;
	}
	public StringDataType getCodEstadoAgrupacion() {
		return codEstadoAgrupacion;
	}
	public void setCodEstadoAgrupacion(StringDataType codEstadoAgrupacion) {
		this.codEstadoAgrupacion = codEstadoAgrupacion;
	}
	public StringDataType getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(StringDataType codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public StringDataType getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(StringDataType codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public StringDataType getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(StringDataType codProvincia) {
		this.codProvincia = codProvincia;
	}
	public LongDataType getIdProveedorRemGestorComercial() {
		return idProveedorRemGestorComercial;
	}
	public void setIdProveedorRemGestorComercial(LongDataType idProveedorRemGestorComercial) {
		this.idProveedorRemGestorComercial = idProveedorRemGestorComercial;
	}
	public LongDataType getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(LongDataType idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}
	public StringDataType getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(StringDataType descripcion) {
		this.descripcion = descripcion;
	}
	public LongDataType getAsociadosActivos() {
		return asociadosActivos;
	}
	public void setAsociadosActivos(LongDataType asociadosActivos) {
		this.asociadosActivos = asociadosActivos;
	}
	public StringDataType getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(StringDataType codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
}
