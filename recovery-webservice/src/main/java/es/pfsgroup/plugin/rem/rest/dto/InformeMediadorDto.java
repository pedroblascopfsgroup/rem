package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.rest.validator.Diccionary;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class InformeMediadorDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@NotNull(groups = { Insert.class, Update.class })
	private Long idInformeMediadorWebcom;

	@NotNull(groups = { Update.class })
	private Long idInformeMediadorRem;

	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;

	@NotNull(groups = { Insert.class, Update.class })
	private Long idUsuarioRemAccion;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoActivo.class, message = "El codTipoActivo no existe", groups = { Insert.class,
			Update.class })
	private String codTipoActivo;

	@NotNull(groups = { Insert.class, Update.class })
	private Long idActivoHaya;

	@NotNull(groups = Insert.class)
	private Long idProveedorRemAnterior;

	@NotNull(groups = Insert.class)
	private Long idProveedorRem;

	@NotNull(groups = Insert.class)
	private Boolean posibleInforme;

	@NotNull(groups = Insert.class)
	private String motivoNoPosibleInforme;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDSubtipoActivo.class, message = "El codSubtipoImueble no existe", groups = { Insert.class,
			Update.class })
	private String codSubtipoImueble;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVivienda.class, message = "El codTpoVivienda de activo no existe", groups = {
			Insert.class, Update.class })
	private String codTpoVivienda;

	@NotNull(groups = Insert.class)
	private Date fechaUltimaVisita;

	@Diccionary(clase = DDTipoVia.class, message = "El codTpoVivienda de activo no existe", groups = { Insert.class,
			Update.class })
	private String codTipoVia;

	@NotNull(groups = Insert.class)
	private String nombreCalle;

	@NotNull(groups = Insert.class)
	private String numeroCalle;

	private String escalera;

	private String planta;

	private String puerta;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = Localidad.class, message = "El codMunicipio no existe", groups = { Insert.class, Update.class })
	private String codMunicipio;

	@Diccionary(clase = DDUnidadPoblacional.class, message = "El codPedania no existe", groups = { Insert.class,
			Update.class })
	private String codPedania;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDProvincia.class, message = "El codProvincia no existe", groups = { Insert.class,
			Update.class })
	private String codProvincia;

	@NotNull(groups = Insert.class)
	private String codigoPostal;

	@NotNull(groups = Insert.class)
	private String zona;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDUbicacionActivo.class, message = "El codUbicacion no existe", groups = { Insert.class,
			Update.class })
	private String codUbicacion;

	@NotNull(groups = Insert.class) // <---------------------------------Diccionario???
	private String codDistrito;

	@NotNull(groups = Insert.class)
	private Float lat;

	@NotNull(groups = Insert.class)
	private Float lng;

	@NotNull(groups = Insert.class)
	private Date fechaRecepcionLlavesApi;

	@Diccionary(clase = Localidad.class, message = "El codMunicipioRegistro no existe", groups = { Insert.class,
			Update.class })
	private String codMunicipioRegistro;

	@NotNull(groups = Insert.class)
	private String codRegimenProteccion;// <---------------------------------Diccionario???

	private Float valorMaximoVpo;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoGradoPropiedad.class, message = "El codTipoPropiedad no existe", groups = { Insert.class,
			Update.class })
	private String codTipoPropiedad;// <---------------------------------Diccionario???

	@NotNull(groups = Insert.class)
	private Float porcentajePropiedad;

	@NotNull(groups = Insert.class)
	private Float valorEstimadoVenta;

	@NotNull(groups = Insert.class)
	private Date fechaValorEstimadoVenta;

	@NotNull(groups = Insert.class)
	private String justificacionValorEstimadoVenta;

	@NotNull(groups = Insert.class)
	private Float valorEstimadoRenta;

	@NotNull(groups = Insert.class)
	private Date fechaValorEstimadoRenta;

	@NotNull(groups = Insert.class)
	private String justificacionValorEstimadoRenta;

	private Float utilSuperficie;
	
	private Float construidaSuperficie;
	
	private Float registralSuperficie;
	
	private Float parcelaSuperficie;
	
	@Diccionary(clase = DDEstadoConservacion.class, message = "El codEstadoConservacion no existe", groups = { Insert.class,
			Update.class })
	private String codEstadoConservacion;

	public Long getIdInformeMediadorRem() {
		return idInformeMediadorRem;
	}

	public void setIdInformeMediadorRem(Long idInformeMediadorRem) {
		this.idInformeMediadorRem = idInformeMediadorRem;
	}

	public Long getIdInformeMediadorWebcom() {
		return idInformeMediadorWebcom;
	}

	public void setIdInformeMediadorWebcom(Long idInformeMediadorWebcom) {
		this.idInformeMediadorWebcom = idInformeMediadorWebcom;
	}

	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}

	public Long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

	public Long getIdProveedorRemAnterior() {
		return idProveedorRemAnterior;
	}

	public void setIdProveedorRemAnterior(Long idProveedorRemAnterior) {
		this.idProveedorRemAnterior = idProveedorRemAnterior;
	}

	public Long getIdProveedorRem() {
		return idProveedorRem;
	}

	public void setIdProveedorRem(Long idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}

	public Boolean getPosibleInforme() {
		return posibleInforme;
	}

	public void setPosibleInforme(Boolean posibleInforme) {
		this.posibleInforme = posibleInforme;
	}

	public String getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}

	public void setMotivoNoPosibleInforme(String motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}

	public String getCodSubtipoImueble() {
		return codSubtipoImueble;
	}

	public void setCodSubtipoImueble(String codSubtipoImueble) {
		this.codSubtipoImueble = codSubtipoImueble;
	}

	public String getCodTpoVivienda() {
		return codTpoVivienda;
	}

	public void setCodTpoVivienda(String codTpoVivienda) {
		this.codTpoVivienda = codTpoVivienda;
	}

	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}

	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}

	public String getCodTipoVia() {
		return codTipoVia;
	}

	public void setCodTipoVia(String codTipoVia) {
		this.codTipoVia = codTipoVia;
	}

	public String getNombreCalle() {
		return nombreCalle;
	}

	public void setNombreCalle(String nombreCalle) {
		this.nombreCalle = nombreCalle;
	}

	public String getNumeroCalle() {
		return numeroCalle;
	}

	public void setNumeroCalle(String numeroCalle) {
		this.numeroCalle = numeroCalle;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getCodMunicipio() {
		return codMunicipio;
	}

	public void setCodMunicipio(String codMunicipio) {
		this.codMunicipio = codMunicipio;
	}

	public String getCodPedania() {
		return codPedania;
	}

	public void setCodPedania(String codPedania) {
		this.codPedania = codPedania;
	}

	public String getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getZona() {
		return zona;
	}

	public void setZona(String zona) {
		this.zona = zona;
	}

	public String getCodUbicacion() {
		return codUbicacion;
	}

	public void setCodUbicacion(String codUbicacion) {
		this.codUbicacion = codUbicacion;
	}

	public String getCodDistrito() {
		return codDistrito;
	}

	public void setCodDistrito(String codDistrito) {
		this.codDistrito = codDistrito;
	}

	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

	public Float getLng() {
		return lng;
	}

	public void setLng(Float lng) {
		this.lng = lng;
	}

	public Date getFechaRecepcionLlavesApi() {
		return fechaRecepcionLlavesApi;
	}

	public void setFechaRecepcionLlavesApi(Date fechaRecepcionLlavesApi) {
		this.fechaRecepcionLlavesApi = fechaRecepcionLlavesApi;
	}

	public String getCodMunicipioRegistro() {
		return codMunicipioRegistro;
	}

	public void setCodMunicipioRegistro(String codMunicipioRegistro) {
		this.codMunicipioRegistro = codMunicipioRegistro;
	}

	public String getCodRegimenProteccion() {
		return codRegimenProteccion;
	}

	public void setCodRegimenProteccion(String codRegimenProteccion) {
		this.codRegimenProteccion = codRegimenProteccion;
	}

	public Float getValorMaximoVpo() {
		return valorMaximoVpo;
	}

	public void setValorMaximoVpo(Float valorMaximoVpo) {
		this.valorMaximoVpo = valorMaximoVpo;
	}

	public String getCodTipoPropiedad() {
		return codTipoPropiedad;
	}

	public void setCodTipoPropiedad(String codTipoPropiedad) {
		this.codTipoPropiedad = codTipoPropiedad;
	}

	public Float getPorcentajePropiedad() {
		return porcentajePropiedad;
	}

	public void setPorcentajePropiedad(Float porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}

	public Float getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}

	public void setValorEstimadoVenta(Float valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}

	public Date getFechaValorEstimadoVenta() {
		return fechaValorEstimadoVenta;
	}

	public void setFechaValorEstimadoVenta(Date fechaValorEstimadoVenta) {
		this.fechaValorEstimadoVenta = fechaValorEstimadoVenta;
	}

	public String getJustificacionValorEstimadoVenta() {
		return justificacionValorEstimadoVenta;
	}

	public void setJustificacionValorEstimadoVenta(String justificacionValorEstimadoVenta) {
		this.justificacionValorEstimadoVenta = justificacionValorEstimadoVenta;
	}

	public Float getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}

	public void setValorEstimadoRenta(Float valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}

	public Date getFechaValorEstimadoRenta() {
		return fechaValorEstimadoRenta;
	}

	public void setFechaValorEstimadoRenta(Date fechaValorEstimadoRenta) {
		this.fechaValorEstimadoRenta = fechaValorEstimadoRenta;
	}

	public String getJustificacionValorEstimadoRenta() {
		return justificacionValorEstimadoRenta;
	}

	public void setJustificacionValorEstimadoRenta(String justificacionValorEstimadoRenta) {
		this.justificacionValorEstimadoRenta = justificacionValorEstimadoRenta;
	}

	public Float getUtilSuperficie() {
		return utilSuperficie;
	}

	public void setUtilSuperficie(Float utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
	}

	public Float getConstruidaSuperficie() {
		return construidaSuperficie;
	}

	public void setConstruidaSuperficie(Float construidaSuperficie) {
		this.construidaSuperficie = construidaSuperficie;
	}

	public Float getRegistralSuperficie() {
		return registralSuperficie;
	}

	public void setRegistralSuperficie(Float registralSuperficie) {
		this.registralSuperficie = registralSuperficie;
	}

	public Float getParcelaSuperficie() {
		return parcelaSuperficie;
	}

	public void setParcelaSuperficie(Float parcelaSuperficie) {
		this.parcelaSuperficie = parcelaSuperficie;
	}

	public String getCodEstadoConservacion() {
		return codEstadoConservacion;
	}

	public void setCodEstadoConservacion(String codEstadoConservacion) {
		this.codEstadoConservacion = codEstadoConservacion;
	}
	
	

}
