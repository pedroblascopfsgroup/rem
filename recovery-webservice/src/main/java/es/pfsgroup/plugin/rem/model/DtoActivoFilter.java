package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Activos
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private String numActivo;
	private String numActivoRem;
	private String idProp;
	private String idUvem;
	private String idRecovery;
	private String estadoActivoCodigo;
	private String tipoUsoDestinoCodigo;
	private String fechaInmo;
	private String agrupacion;
	private String refCatastral;
	private String finca;
	private String fincaAvanzada;
	private String idufir;
	private String propietario;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String localidadCodigo;
	private String localidadDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
    private String tipoTituloActivoCodigo;
    private String tipoTituloActivoDescripcion;
	private String subtipoTituloActivoCodigo;
	private String subtipoTituloActivoDescripcion;
    private String entidadPropietariaCodigo;
    private String entidadPropietariaDescripcion;
    private String subcarteraCodigo;
	private String subcarteraDescripcion;
	private String tipoViaCodigo;
	private String localidadRegistroDescripcion;
	private String tipoActivoDescripcion;
	private String nombreVia;
	private String codPostal;
	private String provinciaAvanzada;
	private String municipio;
	private String paisCodigo;
	private String paisDescripcion;
	private String unidadInferior;
	private String numRegistro;
	private Integer ocupado;
	private Integer conTitulo;
	private Integer inscrito;
	private Integer conPosesion;
	private Integer conCargas;
	private String tipoComercializacion;
	private Integer conOfertaAprobada;
	private Integer conReserva;
	private Integer tieneMediador;
	private Integer tieneLLavesMediador;
	private String estadoInformeComercial;
	private Integer conTasacion;
	private Integer conFsvVenta;
	private Integer conFsvRenta;
	private Integer conBloqueo;
	private String tipoPropuestaCodigo;
	private Boolean checkTodosActivos;

	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getFechaInmo() {
		return fechaInmo;
	}
	public void setFechaInmo(String fechaInmo) {
		this.fechaInmo = fechaInmo;
	}
	public String getAgrupacion() {
		return agrupacion;
	}
	public void setAgrupacion(String agrupacion) {
		this.agrupacion = agrupacion;
	}
	public String getRefCatastral() {
		return refCatastral;
	}
	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}
	public String getFinca() {
		return finca;
	}
	public void setFinca(String finca) {
		this.finca = finca;
	}
	public String getIdufir() {
		return idufir;
	}
	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}

	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public String getIdProp() {
		return idProp;
	}
	public void setIdProp(String idProp) {
		this.idProp = idProp;
	}
	public String getIdUvem() {
		return idUvem;
	}
	public void setIdUvem(String idUvem) {
		this.idUvem = idUvem;
	}
	public String getEstadoActivoCodigo() {
		return estadoActivoCodigo;
	}
	public void setEstadoActivoCodigo(String estadoActivoCodigo) {
		this.estadoActivoCodigo = estadoActivoCodigo;
	}
	public String getIdRecovery() {
		return idRecovery;
	}
	public void setIdRecovery(String idRecovery) {
		this.idRecovery = idRecovery;
	}

	public String getNombreVia() {
		return nombreVia;
	}
	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	public String getCodPostal() {
		return codPostal;
	}
	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}
	public String getProvinciaAvanzada() {
		return provinciaAvanzada;
	}
	public void setProvinciaAvanzada(String provinciaAvanzada) {
		this.provinciaAvanzada = provinciaAvanzada;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getUnidadInferior() {
		return unidadInferior;
	}
	public void setUnidadInferior(String unidadInferior) {
		this.unidadInferior = unidadInferior;
	}
	public String getNumRegistro() {
		return numRegistro;
	}
	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public Integer getOcupado() {
		return ocupado;
	}
	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}
	public Integer getConTitulo() {
		return conTitulo;
	}
	public void setConTitulo(Integer conTitulo) {
		this.conTitulo = conTitulo;
	}
	public String getFincaAvanzada() {
		return fincaAvanzada;
	}
	public void setFincaAvanzada(String fincaAvanzada) {
		this.fincaAvanzada = fincaAvanzada;
	}
	public String getTipoUsoDestinoCodigo() {
		return tipoUsoDestinoCodigo;
	}
	public void setTipoUsoDestinoCodigo(String tipoUsoDestinoCodigo) {
		this.tipoUsoDestinoCodigo = tipoUsoDestinoCodigo;
	}
	public String getPaisCodigo() {
		return paisCodigo;
	}
	public void setPaisCodigo(String paisCodigo) {
		this.paisCodigo = paisCodigo;
	}
	public String getPaisDescripcion() {
		return paisDescripcion;
	}
	public void setPaisDescripcion(String paisDescripcion) {
		this.paisDescripcion = paisDescripcion;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public String getLocalidadCodigo() {
		return localidadCodigo;
	}
	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}
	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}
	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}
	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}
	public String getTipoTituloActivoCodigo() {
		return tipoTituloActivoCodigo;
	}
	public void setTipoTituloActivoCodigo(String tipoTituloActivoCodigo) {
		this.tipoTituloActivoCodigo = tipoTituloActivoCodigo;
	}
	public String getTipoTituloActivoDescripcion() {
		return tipoTituloActivoDescripcion;
	}
	public void setTipoTituloActivoDescripcion(String tipoTituloActivoDescripcion) {
		this.tipoTituloActivoDescripcion = tipoTituloActivoDescripcion;
	}
	public String getSubtipoTituloActivoCodigo() {
		return subtipoTituloActivoCodigo;
	}
	public void setSubtipoTituloActivoCodigo(String subtipoTituloActivoCodigo) {
		this.subtipoTituloActivoCodigo = subtipoTituloActivoCodigo;
	}
	public String getSubtipoTituloActivoDescripcion() {
		return subtipoTituloActivoDescripcion;
	}
	public void setSubtipoTituloActivoDescripcion(
			String subtipoTituloActivoDescripcion) {
		this.subtipoTituloActivoDescripcion = subtipoTituloActivoDescripcion;
	}
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}
	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}
	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}
	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}
    public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}
	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}
	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}
	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getLocalidadRegistroDescripcion() {
		return localidadRegistroDescripcion;
	}
	public void setLocalidadRegistroDescripcion(String localidadRegistroDescripcion) {
		this.localidadRegistroDescripcion = localidadRegistroDescripcion;
	}
	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}
	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	public Integer getInscrito() {
		return inscrito;
	}
	public void setInscrito(Integer inscrito) {
		this.inscrito = inscrito;
	}
	public Integer getConPosesion() {
		return conPosesion;
	}
	public void setConPosesion(Integer conPosesion) {
		this.conPosesion = conPosesion;
	}
	public Integer getConCargas() {
		return conCargas;
	}
	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}
	public String getTipoComercializacion() {
		return tipoComercializacion;
	}
	public void setTipoComercializacion(String tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}
	public Integer getConOfertaAprobada() {
		return conOfertaAprobada;
	}
	public void setConOfertaAprobada(Integer conOfertaAprobada) {
		this.conOfertaAprobada = conOfertaAprobada;
	}
	public Integer getConReserva() {
		return conReserva;
	}
	public void setConReserva(Integer conReserva) {
		this.conReserva = conReserva;
	}
	public Integer getTieneMediador() {
		return tieneMediador;
	}
	public void setTieneMediador(Integer tieneMediador) {
		this.tieneMediador = tieneMediador;
	}
	public Integer getTieneLLavesMediador() {
		return tieneLLavesMediador;
	}
	public void setTieneLLavesMediador(Integer tieneLLavesMediador) {
		this.tieneLLavesMediador = tieneLLavesMediador;
	}
	public String getEstadoInformeComercial() {
		return estadoInformeComercial;
	}
	public void setEstadoInformeComercial(String estadoInformeComercial) {
		this.estadoInformeComercial = estadoInformeComercial;
	}
	public Integer getConTasacion() {
		return conTasacion;
	}
	public void setConTasacion(Integer conTasacion) {
		this.conTasacion = conTasacion;
	}
	public Integer getConFsvVenta() {
		return conFsvVenta;
	}
	public void setConFsvVenta(Integer conFsvVenta) {
		this.conFsvVenta = conFsvVenta;
	}
	public Integer getConFsvRenta() {
		return conFsvRenta;
	}
	public void setConFsvRenta(Integer conFsvRenta) {
		this.conFsvRenta = conFsvRenta;
	}
	public Integer getConBloqueo() {
		return conBloqueo;
	}
	public void setConBloqueo(Integer conBloqueo) {
		this.conBloqueo = conBloqueo;
	}
	public String getTipoPropuestaCodigo() {
		return tipoPropuestaCodigo;
	}
	public void setTipoPropuestaCodigo(String tipoPropuestaCodigo) {
		this.tipoPropuestaCodigo = tipoPropuestaCodigo;
	}
	public Boolean getCheckTodosActivos() {
		return checkTodosActivos;
	}
	public void setCheckTodosActivos(Boolean checkTodosActivos) {
		this.checkTodosActivos = checkTodosActivos;
	}
	
}