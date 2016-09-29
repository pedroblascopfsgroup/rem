package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUsosActivo;
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

	@Diccionary(clase = DDEstadoConservacion.class, message = "El codEstadoConservacion no existe", groups = {
			Insert.class, Update.class })
	private String codEstadoConservacion;

	//@EntityDefinition(entityName = "es.pfsgroup.plugin.rem.model.ActivoInfoComercial", propertyName = "anyoConstruccion")
	private Integer anyoConstruccion;

	private Long anyoRehabilitacion;

	private Boolean ultimaPlanta;

	private Boolean ocupado;

	private Long numeroPlantas;

	@Diccionary(clase = DDTipoOrientacion.class, message = "El codOrientacion no existe", groups = { Insert.class,
			Update.class })
	private String codOrientacion;

	@Diccionary(clase = DDTipoRenta.class, message = "El codNivelRenta no existe", groups = { Insert.class,
			Update.class })
	private String codNivelRenta;

	private List<PlantaDto> plantas;

	private Long numeroTerrazasDescubiertas;

	private String descripcionTerrazasDescubiertas;

	private Long numeroTerrazasCubiertas;

	private String descripcionTerrazasCubiertas;

	private Boolean despensaOtrasDependencias;

	private Boolean lavaderoOtrasDependencias;

	private Boolean azoteaOtrasDependencias;

	private String otrosOtrasDependencias;

	private Boolean instalacionElectricidadInstalaciones;

	private Boolean contadorElectricidadInstalaciones;

	private Boolean instalacionAguaInstalaciones;

	private Boolean contadorAguaInstalaciones;

	private Boolean gasInstalaciones;

	private Boolean contadorGasInstalacion;

	private Boolean exteriorCarpinteriaReformasNecesarias;

	private Boolean interiorCarpinteriaReformasNecesarias;

	private Boolean cocinaReformasNecesarias;

	private Boolean suelosReformasNecesarias;

	private Boolean pinturaReformasNecesarias;

	private Boolean integralReformasNecesarias;

	private Boolean banyosReformasNecesarias;

	private String otrasReformasNecesarias;

	private Float otrasReformasNecesariasImporteAproximado;

	private List<Long> activosVinculados;

	private String distribucionInterior;

	private Boolean divisible;

	private Boolean ascensor;

	private Long numeroAscensores;

	private String descripcionPlantas;

	private String otrasCaracteristicas;

	private Boolean fachadaReformasNecesarias;

	private Boolean escaleraReformasNecesarias;

	private Boolean portalReformasNecesarias;

	private Boolean ascensorReformasNecesarias;

	private Boolean cubierta;

	private Boolean otrasZonasComunesReformasNecesarias;

	private String otrosReformasNecesarias;

	private String descripcionEdificio;

	private String infraestructurasEntorno;

	private String comunicacionesEntorno;

	private String idoneoUso;

	private Boolean existeAnteriorUso;

	private String anteriorUso;

	private Long numeroEstancias;

	private Long numeroBanyos;

	private long numeroAseos;

	private Float metrosLinealesFachadaPrincipal;

	private Float altura;

	private Long numeroPlazasGaraje;

	private Float superficiePlazasGaraje;

	private String codSubtipoPlazasGaraje;// <-------------------------------------diccionario?

	private Boolean salidaHumosOtrasCaracteristicas;

	private Boolean salidaEmergenciaOtrasCaracteristicas;

	private Boolean accesoMinusvalidosOtrasCaracteristicas;

	private String otrosOtrasCaracteristicas;

	private String codTipoVario;// <-------------------------------------diccionario?

	private Float ancho;

	private Float alto;

	private Float largo;

	@Diccionary(clase = DDUsosActivo.class, message = "El codUso no existe", groups = { Insert.class, Update.class })
	private String codUso;

	private String codManiobrabilidad;// <-------------------------------------diccionario?

	private Boolean licenciaOtrasCaracteristicas;

	private Boolean servidumbreOtrasCaracteristicas;

	private Boolean ascensorOMontacargasOtrasCaracteristicas;

	private Boolean columnasOtrasCaracteristicas;

	private Boolean seguridadOtrasCaracteristicas;

	private Boolean buenEstadoInstalacionElectricidadInstalaciones;

	private Boolean buenEstadoContadorElectricidadInstalaciones;

	private Boolean buenEstadoInstalacionAguaInstalaciones;

	private Boolean buenEstadoContadorAguaInstalaciones;

	private Boolean buenEstadoGasInstalaciones;

	private Boolean buenEstadoContadorGasInstalacion;

	private Boolean buenEstadoConservacionEdificio;

	private Date anyoRehabilitacionEdificio;

	private Long numeroPlantasEdificio;

	private Boolean ascensorEdificio;

	private Long numeroAscensoresEdificio;

	private Boolean existeComunidadEdificio;

	private Float cuotaComunidadEdificio;

	private String nombrePresidenteComunidadEdificio;

	private String telefonoPresidenteComunidadEdificio;

	private String nombreAdministradorComunidadEdificio;

	private String telefonoAdministradorComunidadEdificio;

	private String descripcionDerramaComunidadEdificio;

	private Boolean ascensorReformasNecesariasEdificio;

	private Boolean cubiertaReformasNecesariasEdificio;

	private Boolean otrasZonasComunesReformasNecesariasEdificio;

	private String otrosReformasNecesariasEdificio;

	private String infraestructurasEntornoEdificio;

	private String comunicacionesEntornoEdificio;

	private Boolean existeOcio;

	private Boolean existenHoteles;

	private String hoteles;

	private Boolean existenTeatros;

	private String teatros;

	private Boolean existenSalasDeCine;

	private String salasDeCine;

	private Boolean existenInstalacionesDeportivas;

	private String instalacionesDeportivas;

	private Boolean existenCentrosComerciales;

	private String centrosComerciales;

	private String otrosOcio;

	private Boolean existenCentrosEducativos;

	private Boolean existenEscuelasInfantiles;

	private String escuelasInfantiles;

	private Boolean existenColegios;

	private String colegios;

	private Boolean existenInstitutos;

	private String institutos;

	private Boolean existenUniversidades;

	private String universidades;

	private String otrosCentrosEducativos;

	private Boolean existenCentrosSanitarios;

	private Boolean existenCentrosDeSalud;

	private String centrosDeSalud;

	private Boolean existenClinicas;

	private String clinicas;

	private Boolean existenHospitales;

	private String hospitales;

	private Boolean existenOtrosCentrosSanitarios;

	private String otrosCentrosSanitarios;

	private String codTipoAparcamientoEnSuperficie;// <-------------------------dicionario??

	private Boolean existenComunicaciones;

	private Boolean existeFacilAccesoPorCarretera;

	private String facilAccesoPorCarretera;

	private Boolean existeLineasDeAutobus;

	private String lineasDeAutobus;

	private Boolean existeMetro;

	private String metro;

	private Boolean existeEstacionesDeTren;

	private String estacionesDeTren;

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

	public Integer getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(Integer anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public Long getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}

	public void setAnyoRehabilitacion(Long anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}

	public String getCodOrientacion() {
		return codOrientacion;
	}

	public void setCodOrientacion(String codOrientacion) {
		this.codOrientacion = codOrientacion;
	}

	public Boolean getUltimaPlanta() {
		return ultimaPlanta;
	}

	public void setUltimaPlanta(Boolean ultimaPlanta) {
		this.ultimaPlanta = ultimaPlanta;
	}

	public Boolean getOcupado() {
		return ocupado;
	}

	public void setOcupado(Boolean ocupado) {
		this.ocupado = ocupado;
	}

	public Long getNumeroPlantas() {
		return numeroPlantas;
	}

	public void setNumeroPlantas(Long numeroPlantas) {
		this.numeroPlantas = numeroPlantas;
	}

	public String getCodNivelRenta() {
		return codNivelRenta;
	}

	public void setCodNivelRenta(String codNivelRenta) {
		this.codNivelRenta = codNivelRenta;
	}

	public List<PlantaDto> getPlantas() {
		return plantas;
	}

	public void setPlantas(List<PlantaDto> plantas) {
		this.plantas = plantas;
	}

	public Long getNumeroTerrazasDescubiertas() {
		return numeroTerrazasDescubiertas;
	}

	public void setNumeroTerrazasDescubiertas(Long numeroTerrazasDescubiertas) {
		this.numeroTerrazasDescubiertas = numeroTerrazasDescubiertas;
	}

	public String getDescripcionTerrazasDescubiertas() {
		return descripcionTerrazasDescubiertas;
	}

	public void setDescripcionTerrazasDescubiertas(String descripcionTerrazasDescubiertas) {
		this.descripcionTerrazasDescubiertas = descripcionTerrazasDescubiertas;
	}

	public Long getNumeroTerrazasCubiertas() {
		return numeroTerrazasCubiertas;
	}

	public void setNumeroTerrazasCubiertas(Long numeroTerrazasCubiertas) {
		this.numeroTerrazasCubiertas = numeroTerrazasCubiertas;
	}

	public String getDescripcionTerrazasCubiertas() {
		return descripcionTerrazasCubiertas;
	}

	public void setDescripcionTerrazasCubiertas(String descripcionTerrazasCubiertas) {
		this.descripcionTerrazasCubiertas = descripcionTerrazasCubiertas;
	}

	public Boolean getDespensaOtrasDependencias() {
		return despensaOtrasDependencias;
	}

	public void setDespensaOtrasDependencias(Boolean despensaOtrasDependencias) {
		this.despensaOtrasDependencias = despensaOtrasDependencias;
	}

	public Boolean getLavaderoOtrasDependencias() {
		return lavaderoOtrasDependencias;
	}

	public void setLavaderoOtrasDependencias(Boolean lavaderoOtrasDependencias) {
		this.lavaderoOtrasDependencias = lavaderoOtrasDependencias;
	}

	public Boolean getAzoteaOtrasDependencias() {
		return azoteaOtrasDependencias;
	}

	public void setAzoteaOtrasDependencias(Boolean azoteaOtrasDependencias) {
		this.azoteaOtrasDependencias = azoteaOtrasDependencias;
	}

	public String getOtrosOtrasDependencias() {
		return otrosOtrasDependencias;
	}

	public void setOtrosOtrasDependencias(String otrosOtrasDependencias) {
		this.otrosOtrasDependencias = otrosOtrasDependencias;
	}

	public Boolean getInstalacionElectricidadInstalaciones() {
		return instalacionElectricidadInstalaciones;
	}

	public void setInstalacionElectricidadInstalaciones(Boolean instalacionElectricidadInstalaciones) {
		this.instalacionElectricidadInstalaciones = instalacionElectricidadInstalaciones;
	}

	public Boolean getContadorElectricidadInstalaciones() {
		return contadorElectricidadInstalaciones;
	}

	public void setContadorElectricidadInstalaciones(Boolean contadorElectricidadInstalaciones) {
		this.contadorElectricidadInstalaciones = contadorElectricidadInstalaciones;
	}

	public Boolean getInstalacionAguaInstalaciones() {
		return instalacionAguaInstalaciones;
	}

	public void setInstalacionAguaInstalaciones(Boolean instalacionAguaInstalaciones) {
		this.instalacionAguaInstalaciones = instalacionAguaInstalaciones;
	}

	public Boolean getContadorAguaInstalaciones() {
		return contadorAguaInstalaciones;
	}

	public void setContadorAguaInstalaciones(Boolean contadorAguaInstalaciones) {
		this.contadorAguaInstalaciones = contadorAguaInstalaciones;
	}

	public Boolean getGasInstalaciones() {
		return gasInstalaciones;
	}

	public void setGasInstalaciones(Boolean gasInstalaciones) {
		this.gasInstalaciones = gasInstalaciones;
	}

	public Boolean getContadorGasInstalacion() {
		return contadorGasInstalacion;
	}

	public void setContadorGasInstalacion(Boolean contadorGasInstalacion) {
		this.contadorGasInstalacion = contadorGasInstalacion;
	}

	public Boolean getExteriorCarpinteriaReformasNecesarias() {
		return exteriorCarpinteriaReformasNecesarias;
	}

	public void setExteriorCarpinteriaReformasNecesarias(Boolean exteriorCarpinteriaReformasNecesarias) {
		this.exteriorCarpinteriaReformasNecesarias = exteriorCarpinteriaReformasNecesarias;
	}

	public Boolean getInteriorCarpinteriaReformasNecesarias() {
		return interiorCarpinteriaReformasNecesarias;
	}

	public void setInteriorCarpinteriaReformasNecesarias(Boolean interiorCarpinteriaReformasNecesarias) {
		this.interiorCarpinteriaReformasNecesarias = interiorCarpinteriaReformasNecesarias;
	}

	public Boolean getCocinaReformasNecesarias() {
		return cocinaReformasNecesarias;
	}

	public void setCocinaReformasNecesarias(Boolean cocinaReformasNecesarias) {
		this.cocinaReformasNecesarias = cocinaReformasNecesarias;
	}

	public Boolean getSuelosReformasNecesarias() {
		return suelosReformasNecesarias;
	}

	public void setSuelosReformasNecesarias(Boolean suelosReformasNecesarias) {
		this.suelosReformasNecesarias = suelosReformasNecesarias;
	}

	public Boolean getPinturaReformasNecesarias() {
		return pinturaReformasNecesarias;
	}

	public void setPinturaReformasNecesarias(Boolean pinturaReformasNecesarias) {
		this.pinturaReformasNecesarias = pinturaReformasNecesarias;
	}

	public Boolean getIntegralReformasNecesarias() {
		return integralReformasNecesarias;
	}

	public void setIntegralReformasNecesarias(Boolean integralReformasNecesarias) {
		this.integralReformasNecesarias = integralReformasNecesarias;
	}

	public Boolean getBanyosReformasNecesarias() {
		return banyosReformasNecesarias;
	}

	public void setBanyosReformasNecesarias(Boolean banyosReformasNecesarias) {
		this.banyosReformasNecesarias = banyosReformasNecesarias;
	}

	public String getOtrasReformasNecesarias() {
		return otrasReformasNecesarias;
	}

	public void setOtrasReformasNecesarias(String otrasReformasNecesarias) {
		this.otrasReformasNecesarias = otrasReformasNecesarias;
	}

	public Float getOtrasReformasNecesariasImporteAproximado() {
		return otrasReformasNecesariasImporteAproximado;
	}

	public void setOtrasReformasNecesariasImporteAproximado(Float otrasReformasNecesariasImporteAproximado) {
		this.otrasReformasNecesariasImporteAproximado = otrasReformasNecesariasImporteAproximado;
	}

	public List<Long> getActivosVinculados() {
		return activosVinculados;
	}

	public void setActivosVinculados(List<Long> activosVinculados) {
		this.activosVinculados = activosVinculados;
	}

	public String getDistribucionInterior() {
		return distribucionInterior;
	}

	public void setDistribucionInterior(String distribucionInterior) {
		this.distribucionInterior = distribucionInterior;
	}

	public Boolean getDivisible() {
		return divisible;
	}

	public void setDivisible(Boolean divisible) {
		this.divisible = divisible;
	}

	public Boolean getAscensor() {
		return ascensor;
	}

	public void setAscensor(Boolean ascensor) {
		this.ascensor = ascensor;
	}

	public Long getNumeroAscensores() {
		return numeroAscensores;
	}

	public void setNumeroAscensores(Long numeroAscensores) {
		this.numeroAscensores = numeroAscensores;
	}

	public String getDescripcionPlantas() {
		return descripcionPlantas;
	}

	public void setDescripcionPlantas(String descripcionPlantas) {
		this.descripcionPlantas = descripcionPlantas;
	}

	public String getOtrasCaracteristicas() {
		return otrasCaracteristicas;
	}

	public void setOtrasCaracteristicas(String otrasCaracteristicas) {
		this.otrasCaracteristicas = otrasCaracteristicas;
	}

	public Boolean getFachadaReformasNecesarias() {
		return fachadaReformasNecesarias;
	}

	public void setFachadaReformasNecesarias(Boolean fachadaReformasNecesarias) {
		this.fachadaReformasNecesarias = fachadaReformasNecesarias;
	}

	public Boolean getEscaleraReformasNecesarias() {
		return escaleraReformasNecesarias;
	}

	public void setEscaleraReformasNecesarias(Boolean escaleraReformasNecesarias) {
		this.escaleraReformasNecesarias = escaleraReformasNecesarias;
	}

	public Boolean getPortalReformasNecesarias() {
		return portalReformasNecesarias;
	}

	public void setPortalReformasNecesarias(Boolean portalReformasNecesarias) {
		this.portalReformasNecesarias = portalReformasNecesarias;
	}

	public Boolean getAscensorReformasNecesarias() {
		return ascensorReformasNecesarias;
	}

	public void setAscensorReformasNecesarias(Boolean ascensorReformasNecesarias) {
		this.ascensorReformasNecesarias = ascensorReformasNecesarias;
	}

	public Boolean getCubierta() {
		return cubierta;
	}

	public void setCubierta(Boolean cubierta) {
		this.cubierta = cubierta;
	}

	public Boolean getOtrasZonasComunesReformasNecesarias() {
		return otrasZonasComunesReformasNecesarias;
	}

	public void setOtrasZonasComunesReformasNecesarias(Boolean otrasZonasComunesReformasNecesarias) {
		this.otrasZonasComunesReformasNecesarias = otrasZonasComunesReformasNecesarias;
	}

	public String getOtrosReformasNecesarias() {
		return otrosReformasNecesarias;
	}

	public void setOtrosReformasNecesarias(String otrosReformasNecesarias) {
		this.otrosReformasNecesarias = otrosReformasNecesarias;
	}

	public String getDescripcionEdificio() {
		return descripcionEdificio;
	}

	public void setDescripcionEdificio(String descripcionEdificio) {
		this.descripcionEdificio = descripcionEdificio;
	}

	public String getInfraestructurasEntorno() {
		return infraestructurasEntorno;
	}

	public void setInfraestructurasEntorno(String infraestructurasEntorno) {
		this.infraestructurasEntorno = infraestructurasEntorno;
	}

	public String getComunicacionesEntorno() {
		return comunicacionesEntorno;
	}

	public void setComunicacionesEntorno(String comunicacionesEntorno) {
		this.comunicacionesEntorno = comunicacionesEntorno;
	}

	public String getIdoneoUso() {
		return idoneoUso;
	}

	public void setIdoneoUso(String idoneoUso) {
		this.idoneoUso = idoneoUso;
	}

	public Boolean getExisteAnteriorUso() {
		return existeAnteriorUso;
	}

	public void setExisteAnteriorUso(Boolean existeAnteriorUso) {
		this.existeAnteriorUso = existeAnteriorUso;
	}

	public String getAnteriorUso() {
		return anteriorUso;
	}

	public void setAnteriorUso(String anteriorUso) {
		this.anteriorUso = anteriorUso;
	}

	public Long getNumeroEstancias() {
		return numeroEstancias;
	}

	public void setNumeroEstancias(Long numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}

	public Long getNumeroBanyos() {
		return numeroBanyos;
	}

	public void setNumeroBanyos(Long numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}

	public long getNumeroAseos() {
		return numeroAseos;
	}

	public void setNumeroAseos(long numeroAseos) {
		this.numeroAseos = numeroAseos;
	}

	public Float getMetrosLinealesFachadaPrincipal() {
		return metrosLinealesFachadaPrincipal;
	}

	public void setMetrosLinealesFachadaPrincipal(Float metrosLinealesFachadaPrincipal) {
		this.metrosLinealesFachadaPrincipal = metrosLinealesFachadaPrincipal;
	}

	public Float getAltura() {
		return altura;
	}

	public void setAltura(Float altura) {
		this.altura = altura;
	}

	public Long getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}

	public void setNumeroPlazasGaraje(Long numeroPlazasGaraje) {
		this.numeroPlazasGaraje = numeroPlazasGaraje;
	}

	public Float getSuperficiePlazasGaraje() {
		return superficiePlazasGaraje;
	}

	public void setSuperficiePlazasGaraje(Float superficiePlazasGaraje) {
		this.superficiePlazasGaraje = superficiePlazasGaraje;
	}

	public String getCodSubtipoPlazasGaraje() {
		return codSubtipoPlazasGaraje;
	}

	public void setCodSubtipoPlazasGaraje(String codSubtipoPlazasGaraje) {
		this.codSubtipoPlazasGaraje = codSubtipoPlazasGaraje;
	}

	public Boolean getSalidaHumosOtrasCaracteristicas() {
		return salidaHumosOtrasCaracteristicas;
	}

	public void setSalidaHumosOtrasCaracteristicas(Boolean salidaHumosOtrasCaracteristicas) {
		this.salidaHumosOtrasCaracteristicas = salidaHumosOtrasCaracteristicas;
	}

	public Boolean getSalidaEmergenciaOtrasCaracteristicas() {
		return salidaEmergenciaOtrasCaracteristicas;
	}

	public void setSalidaEmergenciaOtrasCaracteristicas(Boolean salidaEmergenciaOtrasCaracteristicas) {
		this.salidaEmergenciaOtrasCaracteristicas = salidaEmergenciaOtrasCaracteristicas;
	}

	public Boolean getAccesoMinusvalidosOtrasCaracteristicas() {
		return accesoMinusvalidosOtrasCaracteristicas;
	}

	public void setAccesoMinusvalidosOtrasCaracteristicas(Boolean accesoMinusvalidosOtrasCaracteristicas) {
		this.accesoMinusvalidosOtrasCaracteristicas = accesoMinusvalidosOtrasCaracteristicas;
	}

	public String getOtrosOtrasCaracteristicas() {
		return otrosOtrasCaracteristicas;
	}

	public void setOtrosOtrasCaracteristicas(String otrosOtrasCaracteristicas) {
		this.otrosOtrasCaracteristicas = otrosOtrasCaracteristicas;
	}

	public String getCodTipoVario() {
		return codTipoVario;
	}

	public void setCodTipoVario(String codTipoVario) {
		this.codTipoVario = codTipoVario;
	}

	public Float getAncho() {
		return ancho;
	}

	public void setAncho(Float ancho) {
		this.ancho = ancho;
	}

	public Float getAlto() {
		return alto;
	}

	public void setAlto(Float alto) {
		this.alto = alto;
	}

	public Float getLargo() {
		return largo;
	}

	public void setLargo(Float largo) {
		this.largo = largo;
	}

	public String getCodUso() {
		return codUso;
	}

	public void setCodUso(String codUso) {
		this.codUso = codUso;
	}

	public String getCodManiobrabilidad() {
		return codManiobrabilidad;
	}

	public void setCodManiobrabilidad(String codManiobrabilidad) {
		this.codManiobrabilidad = codManiobrabilidad;
	}

	public Boolean getLicenciaOtrasCaracteristicas() {
		return licenciaOtrasCaracteristicas;
	}

	public void setLicenciaOtrasCaracteristicas(Boolean licenciaOtrasCaracteristicas) {
		this.licenciaOtrasCaracteristicas = licenciaOtrasCaracteristicas;
	}

	public Boolean getServidumbreOtrasCaracteristicas() {
		return servidumbreOtrasCaracteristicas;
	}

	public void setServidumbreOtrasCaracteristicas(Boolean servidumbreOtrasCaracteristicas) {
		this.servidumbreOtrasCaracteristicas = servidumbreOtrasCaracteristicas;
	}

	public Boolean getAscensorOMontacargasOtrasCaracteristicas() {
		return ascensorOMontacargasOtrasCaracteristicas;
	}

	public void setAscensorOMontacargasOtrasCaracteristicas(Boolean ascensorOMontacargasOtrasCaracteristicas) {
		this.ascensorOMontacargasOtrasCaracteristicas = ascensorOMontacargasOtrasCaracteristicas;
	}

	public Boolean getColumnasOtrasCaracteristicas() {
		return columnasOtrasCaracteristicas;
	}

	public void setColumnasOtrasCaracteristicas(Boolean columnasOtrasCaracteristicas) {
		this.columnasOtrasCaracteristicas = columnasOtrasCaracteristicas;
	}

	public Boolean getSeguridadOtrasCaracteristicas() {
		return seguridadOtrasCaracteristicas;
	}

	public void setSeguridadOtrasCaracteristicas(Boolean seguridadOtrasCaracteristicas) {
		this.seguridadOtrasCaracteristicas = seguridadOtrasCaracteristicas;
	}

	public Boolean getBuenEstadoInstalacionElectricidadInstalaciones() {
		return buenEstadoInstalacionElectricidadInstalaciones;
	}

	public void setBuenEstadoInstalacionElectricidadInstalaciones(
			Boolean buenEstadoInstalacionElectricidadInstalaciones) {
		this.buenEstadoInstalacionElectricidadInstalaciones = buenEstadoInstalacionElectricidadInstalaciones;
	}

	public Boolean getBuenEstadoContadorElectricidadInstalaciones() {
		return buenEstadoContadorElectricidadInstalaciones;
	}

	public void setBuenEstadoContadorElectricidadInstalaciones(Boolean buenEstadoContadorElectricidadInstalaciones) {
		this.buenEstadoContadorElectricidadInstalaciones = buenEstadoContadorElectricidadInstalaciones;
	}

	public Boolean getBuenEstadoInstalacionAguaInstalaciones() {
		return buenEstadoInstalacionAguaInstalaciones;
	}

	public void setBuenEstadoInstalacionAguaInstalaciones(Boolean buenEstadoInstalacionAguaInstalaciones) {
		this.buenEstadoInstalacionAguaInstalaciones = buenEstadoInstalacionAguaInstalaciones;
	}

	public Boolean getBuenEstadoContadorAguaInstalaciones() {
		return buenEstadoContadorAguaInstalaciones;
	}

	public void setBuenEstadoContadorAguaInstalaciones(Boolean buenEstadoContadorAguaInstalaciones) {
		this.buenEstadoContadorAguaInstalaciones = buenEstadoContadorAguaInstalaciones;
	}

	public Boolean getBuenEstadoGasInstalaciones() {
		return buenEstadoGasInstalaciones;
	}

	public void setBuenEstadoGasInstalaciones(Boolean buenEstadoGasInstalaciones) {
		this.buenEstadoGasInstalaciones = buenEstadoGasInstalaciones;
	}

	public Boolean getBuenEstadoContadorGasInstalacion() {
		return buenEstadoContadorGasInstalacion;
	}

	public void setBuenEstadoContadorGasInstalacion(Boolean buenEstadoContadorGasInstalacion) {
		this.buenEstadoContadorGasInstalacion = buenEstadoContadorGasInstalacion;
	}

	public Boolean getBuenEstadoConservacionEdificio() {
		return buenEstadoConservacionEdificio;
	}

	public void setBuenEstadoConservacionEdificio(Boolean buenEstadoConservacionEdificio) {
		this.buenEstadoConservacionEdificio = buenEstadoConservacionEdificio;
	}

	public Date getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}

	public void setAnyoRehabilitacionEdificio(Date anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}

	public Long getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}

	public void setNumeroPlantasEdificio(Long numeroPlantasEdificio) {
		this.numeroPlantasEdificio = numeroPlantasEdificio;
	}

	public Boolean getAscensorEdificio() {
		return ascensorEdificio;
	}

	public void setAscensorEdificio(Boolean ascensorEdificio) {
		this.ascensorEdificio = ascensorEdificio;
	}

	public Long getNumeroAscensoresEdificio() {
		return numeroAscensoresEdificio;
	}

	public void setNumeroAscensoresEdificio(Long numeroAscensoresEdificio) {
		this.numeroAscensoresEdificio = numeroAscensoresEdificio;
	}

	public Boolean getExisteComunidadEdificio() {
		return existeComunidadEdificio;
	}

	public void setExisteComunidadEdificio(Boolean existeComunidadEdificio) {
		this.existeComunidadEdificio = existeComunidadEdificio;
	}

	public Float getCuotaComunidadEdificio() {
		return cuotaComunidadEdificio;
	}

	public void setCuotaComunidadEdificio(Float cuotaComunidadEdificio) {
		this.cuotaComunidadEdificio = cuotaComunidadEdificio;
	}

	public String getNombrePresidenteComunidadEdificio() {
		return nombrePresidenteComunidadEdificio;
	}

	public void setNombrePresidenteComunidadEdificio(String nombrePresidenteComunidadEdificio) {
		this.nombrePresidenteComunidadEdificio = nombrePresidenteComunidadEdificio;
	}

	public String getTelefonoPresidenteComunidadEdificio() {
		return telefonoPresidenteComunidadEdificio;
	}

	public void setTelefonoPresidenteComunidadEdificio(String telefonoPresidenteComunidadEdificio) {
		this.telefonoPresidenteComunidadEdificio = telefonoPresidenteComunidadEdificio;
	}

	public String getNombreAdministradorComunidadEdificio() {
		return nombreAdministradorComunidadEdificio;
	}

	public void setNombreAdministradorComunidadEdificio(String nombreAdministradorComunidadEdificio) {
		this.nombreAdministradorComunidadEdificio = nombreAdministradorComunidadEdificio;
	}

	public String getTelefonoAdministradorComunidadEdificio() {
		return telefonoAdministradorComunidadEdificio;
	}

	public void setTelefonoAdministradorComunidadEdificio(String telefonoAdministradorComunidadEdificio) {
		this.telefonoAdministradorComunidadEdificio = telefonoAdministradorComunidadEdificio;
	}

	public String getDescripcionDerramaComunidadEdificio() {
		return descripcionDerramaComunidadEdificio;
	}

	public void setDescripcionDerramaComunidadEdificio(String descripcionDerramaComunidadEdificio) {
		this.descripcionDerramaComunidadEdificio = descripcionDerramaComunidadEdificio;
	}

	public Boolean getAscensorReformasNecesariasEdificio() {
		return ascensorReformasNecesariasEdificio;
	}

	public void setAscensorReformasNecesariasEdificio(Boolean ascensorReformasNecesariasEdificio) {
		this.ascensorReformasNecesariasEdificio = ascensorReformasNecesariasEdificio;
	}

	public Boolean getCubiertaReformasNecesariasEdificio() {
		return cubiertaReformasNecesariasEdificio;
	}

	public void setCubiertaReformasNecesariasEdificio(Boolean cubiertaReformasNecesariasEdificio) {
		this.cubiertaReformasNecesariasEdificio = cubiertaReformasNecesariasEdificio;
	}

	public Boolean getOtrasZonasComunesReformasNecesariasEdificio() {
		return otrasZonasComunesReformasNecesariasEdificio;
	}

	public void setOtrasZonasComunesReformasNecesariasEdificio(Boolean otrasZonasComunesReformasNecesariasEdificio) {
		this.otrasZonasComunesReformasNecesariasEdificio = otrasZonasComunesReformasNecesariasEdificio;
	}

	public String getOtrosReformasNecesariasEdificio() {
		return otrosReformasNecesariasEdificio;
	}

	public void setOtrosReformasNecesariasEdificio(String otrosReformasNecesariasEdificio) {
		this.otrosReformasNecesariasEdificio = otrosReformasNecesariasEdificio;
	}

	public String getInfraestructurasEntornoEdificio() {
		return infraestructurasEntornoEdificio;
	}

	public void setInfraestructurasEntornoEdificio(String infraestructurasEntornoEdificio) {
		this.infraestructurasEntornoEdificio = infraestructurasEntornoEdificio;
	}

	public String getComunicacionesEntornoEdificio() {
		return comunicacionesEntornoEdificio;
	}

	public void setComunicacionesEntornoEdificio(String comunicacionesEntornoEdificio) {
		this.comunicacionesEntornoEdificio = comunicacionesEntornoEdificio;
	}

	public Boolean getExisteOcio() {
		return existeOcio;
	}

	public void setExisteOcio(Boolean existeOcio) {
		this.existeOcio = existeOcio;
	}

	public Boolean getExistenHoteles() {
		return existenHoteles;
	}

	public void setExistenHoteles(Boolean existenHoteles) {
		this.existenHoteles = existenHoteles;
	}

	public String getHoteles() {
		return hoteles;
	}

	public void setHoteles(String hoteles) {
		this.hoteles = hoteles;
	}

	public Boolean getExistenTeatros() {
		return existenTeatros;
	}

	public void setExistenTeatros(Boolean existenTeatros) {
		this.existenTeatros = existenTeatros;
	}

	public String getTeatros() {
		return teatros;
	}

	public void setTeatros(String teatros) {
		this.teatros = teatros;
	}

	public Boolean getExistenSalasDeCine() {
		return existenSalasDeCine;
	}

	public void setExistenSalasDeCine(Boolean existenSalasDeCine) {
		this.existenSalasDeCine = existenSalasDeCine;
	}

	public String getSalasDeCine() {
		return salasDeCine;
	}

	public void setSalasDeCine(String salasDeCine) {
		this.salasDeCine = salasDeCine;
	}

	public Boolean getExistenInstalacionesDeportivas() {
		return existenInstalacionesDeportivas;
	}

	public void setExistenInstalacionesDeportivas(Boolean existenInstalacionesDeportivas) {
		this.existenInstalacionesDeportivas = existenInstalacionesDeportivas;
	}

	public String getInstalacionesDeportivas() {
		return instalacionesDeportivas;
	}

	public void setInstalacionesDeportivas(String instalacionesDeportivas) {
		this.instalacionesDeportivas = instalacionesDeportivas;
	}

	public Boolean getExistenCentrosComerciales() {
		return existenCentrosComerciales;
	}

	public void setExistenCentrosComerciales(Boolean existenCentrosComerciales) {
		this.existenCentrosComerciales = existenCentrosComerciales;
	}

	public String getCentrosComerciales() {
		return centrosComerciales;
	}

	public void setCentrosComerciales(String centrosComerciales) {
		this.centrosComerciales = centrosComerciales;
	}

	public String getOtrosOcio() {
		return otrosOcio;
	}

	public void setOtrosOcio(String otrosOcio) {
		this.otrosOcio = otrosOcio;
	}

	public Boolean getExistenCentrosEducativos() {
		return existenCentrosEducativos;
	}

	public void setExistenCentrosEducativos(Boolean existenCentrosEducativos) {
		this.existenCentrosEducativos = existenCentrosEducativos;
	}

	public Boolean getExistenEscuelasInfantiles() {
		return existenEscuelasInfantiles;
	}

	public void setExistenEscuelasInfantiles(Boolean existenEscuelasInfantiles) {
		this.existenEscuelasInfantiles = existenEscuelasInfantiles;
	}

	public String getEscuelasInfantiles() {
		return escuelasInfantiles;
	}

	public void setEscuelasInfantiles(String escuelasInfantiles) {
		this.escuelasInfantiles = escuelasInfantiles;
	}

	public Boolean getExistenColegios() {
		return existenColegios;
	}

	public void setExistenColegios(Boolean existenColegios) {
		this.existenColegios = existenColegios;
	}

	public String getColegios() {
		return colegios;
	}

	public void setColegios(String colegios) {
		this.colegios = colegios;
	}

	public Boolean getExistenInstitutos() {
		return existenInstitutos;
	}

	public void setExistenInstitutos(Boolean existenInstitutos) {
		this.existenInstitutos = existenInstitutos;
	}

	public String getInstitutos() {
		return institutos;
	}

	public void setInstitutos(String institutos) {
		this.institutos = institutos;
	}

	public Boolean getExistenUniversidades() {
		return existenUniversidades;
	}

	public void setExistenUniversidades(Boolean existenUniversidades) {
		this.existenUniversidades = existenUniversidades;
	}

	public String getUniversidades() {
		return universidades;
	}

	public void setUniversidades(String universidades) {
		this.universidades = universidades;
	}

	public String getOtrosCentrosEducativos() {
		return otrosCentrosEducativos;
	}

	public void setOtrosCentrosEducativos(String otrosCentrosEducativos) {
		this.otrosCentrosEducativos = otrosCentrosEducativos;
	}

	public Boolean getExistenCentrosSanitarios() {
		return existenCentrosSanitarios;
	}

	public void setExistenCentrosSanitarios(Boolean existenCentrosSanitarios) {
		this.existenCentrosSanitarios = existenCentrosSanitarios;
	}

	public Boolean getExistenCentrosDeSalud() {
		return existenCentrosDeSalud;
	}

	public void setExistenCentrosDeSalud(Boolean existenCentrosDeSalud) {
		this.existenCentrosDeSalud = existenCentrosDeSalud;
	}

	public String getCentrosDeSalud() {
		return centrosDeSalud;
	}

	public void setCentrosDeSalud(String centrosDeSalud) {
		this.centrosDeSalud = centrosDeSalud;
	}

	public Boolean getExistenClinicas() {
		return existenClinicas;
	}

	public void setExistenClinicas(Boolean existenClinicas) {
		this.existenClinicas = existenClinicas;
	}

	public String getClinicas() {
		return clinicas;
	}

	public void setClinicas(String clinicas) {
		this.clinicas = clinicas;
	}

	public Boolean getExistenHospitales() {
		return existenHospitales;
	}

	public void setExistenHospitales(Boolean existenHospitales) {
		this.existenHospitales = existenHospitales;
	}

	public String getHospitales() {
		return hospitales;
	}

	public void setHospitales(String hospitales) {
		this.hospitales = hospitales;
	}

	public Boolean getExistenOtrosCentrosSanitarios() {
		return existenOtrosCentrosSanitarios;
	}

	public void setExistenOtrosCentrosSanitarios(Boolean existenOtrosCentrosSanitarios) {
		this.existenOtrosCentrosSanitarios = existenOtrosCentrosSanitarios;
	}

	public String getOtrosCentrosSanitarios() {
		return otrosCentrosSanitarios;
	}

	public void setOtrosCentrosSanitarios(String otrosCentrosSanitarios) {
		this.otrosCentrosSanitarios = otrosCentrosSanitarios;
	}

	public String getCodTipoAparcamientoEnSuperficie() {
		return codTipoAparcamientoEnSuperficie;
	}

	public void setCodTipoAparcamientoEnSuperficie(String codTipoAparcamientoEnSuperficie) {
		this.codTipoAparcamientoEnSuperficie = codTipoAparcamientoEnSuperficie;
	}

	public Boolean getExistenComunicaciones() {
		return existenComunicaciones;
	}

	public void setExistenComunicaciones(Boolean existenComunicaciones) {
		this.existenComunicaciones = existenComunicaciones;
	}

	public Boolean getExisteFacilAccesoPorCarretera() {
		return existeFacilAccesoPorCarretera;
	}

	public void setExisteFacilAccesoPorCarretera(Boolean existeFacilAccesoPorCarretera) {
		this.existeFacilAccesoPorCarretera = existeFacilAccesoPorCarretera;
	}

	public String getFacilAccesoPorCarretera() {
		return facilAccesoPorCarretera;
	}

	public void setFacilAccesoPorCarretera(String facilAccesoPorCarretera) {
		this.facilAccesoPorCarretera = facilAccesoPorCarretera;
	}

	public Boolean getExisteLineasDeAutobus() {
		return existeLineasDeAutobus;
	}

	public void setExisteLineasDeAutobus(Boolean existeLineasDeAutobus) {
		this.existeLineasDeAutobus = existeLineasDeAutobus;
	}

	public String getLineasDeAutobus() {
		return lineasDeAutobus;
	}

	public void setLineasDeAutobus(String lineasDeAutobus) {
		this.lineasDeAutobus = lineasDeAutobus;
	}

	public Boolean getExisteMetro() {
		return existeMetro;
	}

	public void setExisteMetro(Boolean existeMetro) {
		this.existeMetro = existeMetro;
	}

	public String getMetro() {
		return metro;
	}

	public void setMetro(String metro) {
		this.metro = metro;
	}

	public Boolean getExisteEstacionesDeTren() {
		return existeEstacionesDeTren;
	}

	public void setExisteEstacionesDeTren(Boolean existeEstacionesDeTren) {
		this.existeEstacionesDeTren = existeEstacionesDeTren;
	}

	public String getEstacionesDeTren() {
		return estacionesDeTren;
	}

	public void setEstacionesDeTren(String estacionesDeTren) {
		this.estacionesDeTren = estacionesDeTren;
	}

}
