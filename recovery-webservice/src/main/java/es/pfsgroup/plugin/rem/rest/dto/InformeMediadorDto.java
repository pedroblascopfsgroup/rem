package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.dd.DDAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacion;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacionEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeMediador;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMobiliario;
import es.pfsgroup.plugin.rem.model.dd.DDExteriorInterior;
import es.pfsgroup.plugin.rem.model.dd.DDRatingCocina;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalefaccion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoClimatizacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPuerta;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUsoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDValoracionUbicacion;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class InformeMediadorDto implements Serializable {

	@EntityDefinition(procesar = false)
	private static final long serialVersionUID = 1L;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "idWebcom")
	private Long idInformeMediadorWebcom;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Activo.class, message = "El activo no existe", foreingField = "numActivo", groups = {
			Insert.class, Update.class })
	@EntityDefinition(procesar = false)
	private Long idActivoHaya;
	
	@NotNull(groups = Update.class)
	@EntityDefinition(procesar = false)
	@Diccionary(clase = ActivoInfoComercial.class, foreingField="id",
			message = "El idInformeMediadorRem no existe", groups = { Update.class })
	private Long idInformeMediadorRem;
	
	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "fechaEmisionInforme")
	private Date fechaAccion;
	
	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(procesar = false)
	private Long idUsuarioRemAccion;
	
	@Diccionary(clase = DDTipoComercializacion.class,foreingField="codigo", 
				message = "El codTipoVenta no existe", groups = { Insert.class, Update.class })
	private String codTipoVenta;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDEstadoInformeMediador.class,foreingField="codigo", 
				message = "El codEstadoInforme no existe", groups = { Insert.class, Update.class })
	private String estadoInforme;
	
	@NotNull(groups = { Insert.class, Update.class })
	private Float lat;

	@NotNull(groups = { Insert.class, Update.class })
	private Float lng;
	
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaUltimaVisita;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoActivo.class, foreingField="codigo", message = "El codTipoActivo no existe",
				groups = { Insert.class,Update.class })
	@EntityDefinition(propertyName = "tipoActivo", classObj = DDTipoActivo.class)
	private String codTipoActivo;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDSubtipoActivo.class,foreingField="codigo",  message = "El codSubtipoInmueble no existe",
				groups = { Insert.class,Update.class })
	@EntityDefinition(propertyName = "subtipoActivo", classObj = DDSubtipoActivo.class)
	private String codSubtipoInmueble;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoVia.class,foreingField="codigo",  message = "El codTipoVia de activo no existe", 
				groups = { Insert.class,Update.class })
	@EntityDefinition(propertyName = "tipoVia", classObj = DDTipoVia.class)
	private String codTipoVia;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "nombreVia")
	private String nombreCalle;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "numeroVia")
	private String numeroCalle;

	private String escalera;

	private String planta;

	private String puerta;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Localidad.class, message = "El codMunicipio no existe",foreingField="codigo", 
				groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "localidad", classObj = Localidad.class)
	private String codMunicipio;
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDProvincia.class, message = "El codProvincia no existe",foreingField="codigo", 
				groups = { Insert.class,Update.class })
	@EntityDefinition(propertyName = "provincia", classObj = DDProvincia.class)
	private String codProvincia;

	@NotNull(groups = { Insert.class, Update.class })
	private String codigoPostal;
	
	private Integer numeroDormitorios;
	
	@EntityDefinition(propertyName = "comercialNumBanyos")
	private Integer numeroBanyos;

	@EntityDefinition(propertyName = "comercialNumAseos")
	private Integer numeroAseos;
	
	@EntityDefinition(procesar = false)
	private Integer numeroPlazasGaraje;
	
	private Boolean terraza;
	
	private Boolean patio;
	
	private Boolean ascensor;
	
	@EntityDefinition(procesar = false)
	private Float utilSuperficie;

	private Boolean rehabilitado;
	
	@EntityDefinition(propertyName = "anyoRehabilitacion")
	private Integer anyoRehabilitacion;

	private Boolean licenciaApertura;
	
	private Boolean licenciaObra;
	
	@NotNull(groups = { Insert.class, Update.class })
	private String descripcionComercial;
	
	@Diccionary(clase = DDEstadoConservacion.class, foreingField="codigo", message = "El codEstadoConservacion no existe", 
				groups = {Insert.class, Update.class })
	@EntityDefinition(propertyName = "estadoConservacion", classObj = DDEstadoConservacion.class)
	private String codEstadoConservacion;
	
	@EntityDefinition(procesar = false)
	private Boolean anejoTrastero;
	
	@EntityDefinition(procesar = false)
	private Boolean anejoGaraje;
	
	@Diccionary(clase = DDRatingCocina.class,foreingField="codigo", 
				message = "El cocinaRating no existe", groups = { Insert.class, Update.class })
	private String cocinaRating;
	
	private Boolean cocinaAmueblada;
	
	private List<String> codesOrientacion;
	
	@Diccionary(clase = DDTipoClimatizacion.class,foreingField="codigo",  message = "El codCalefaccion no existe", 
	groups = { Insert.class,Update.class })
	private String codCalefaccion;
	
	@Diccionary(clase = DDTipoCalefaccion.class,foreingField="codigo",  message = "El codTipoCalefaccion no existe", 
				groups = { Insert.class,Update.class })
	private String codTipoCalefaccion;
	
	@Diccionary(clase = DDTipoClimatizacion.class,foreingField="codigo",  message = "El codTipoCalefaccion no existe", 
				groups = { Insert.class,Update.class })
	private String codAireAcondicionado;

	public Boolean existenArmariosEmpotrados;
	
	private Float superficieTerraza;
	
	private Float superficiePatio;
	
	@Diccionary(clase = DDExteriorInterior.class,foreingField="codigo",  message = "El codTipoCalefaccion no existe", 
				groups = { Insert.class,Update.class })
	private String exteriorInterior;
	
	public Boolean existenZonasVerdes;
	
	public Boolean existeConserjeVigilancia;
	
	@Diccionary(clase = DDDisponibilidad.class,foreingField="codigo",  message = "El jardin no existe", 
				groups = { Insert.class,Update.class })
	private String jardin;
	
	@Diccionary(clase = DDDisponibilidad.class,foreingField="codigo",  message = "El piscina no existe", 
				groups = { Insert.class,Update.class })
	private String piscina;
	
	private Boolean existenInstalacionesDeportivas;
	
	@Diccionary(clase = DDDisponibilidad.class,foreingField="codigo",  message = "El piscina no existe", 
				groups = { Insert.class,Update.class })
	public String gimnasio;
	
	private Boolean accesoMinusvalidosOtrasCaracteristicas;

	@Diccionary(clase = DDEstadoConservacionEdificio.class, message = "El codEstadoConservacionEdificio no existe", groups = {
			Insert.class, Update.class })
	@EntityDefinition(propertyName = "estadoConservacionEdificio", classObj = DDEstadoConservacionEdificio.class)
	private String codEstadoConservacionEdificio;

	@EntityDefinition(propertyName = "numPlantas")
	private Integer numeroPlantasEdificio;
	
	@Diccionary(clase = DDTipoPuerta.class,foreingField="codigo",  message = "El codTipoPuertaAcceso no existe", 
				groups = { Insert.class,Update.class })
	private String codTipoPuertaAcceso;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoPuertasInteriores no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoPuertasInteriores;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoVentanas no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoVentanas;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoPersianas no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoPersianas;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoPintura no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoPintura;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoSolados no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoSolados;
	
	@Diccionary(clase = DDAdmision.class,foreingField="codigo",  message = "El codAdmiteMascota no existe", 
				groups = { Insert.class,Update.class })
	private String codAdmiteMascota;
	
	@Diccionary(clase = DDEstadoMobiliario.class,foreingField="codigo",  message = "El codEstadoBanyos no existe", 
				groups = { Insert.class,Update.class })
	private String codEstadoBanyos;
	
	@Diccionary(clase = DDValoracionUbicacion.class,foreingField="codigo",  message = "El codValoracionUbicacion no existe", 
				groups = { Insert.class,Update.class })
	private String codValoracionUbicacion;
	
	@Diccionary(clase = DDUbicacionActivo.class,foreingField="codigo",  message = "El codUbicacion no existe",
				groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "ubicacionActivo", classObj = DDUbicacionActivo.class)
	private String codUbicacion;
	
	private Boolean salidaHumosOtrasCaracteristicas;
	
	private Boolean aptoUsoEnBruto;
	
	private String codAccesibilidad;
	
	private Float edificabilidadSuperficieTecho;
	
	@EntityDefinition(procesar = false)
	private Float parcelaSuperficie;
	
	private Float porcentajeUrbanizacionEjecutado;
	
	@Diccionary(clase = DDClasificacion.class,foreingField="codigo",  message = "El clasificacion no existe",
				groups = { Insert.class, Update.class })
	private String clasificacion;
	
	@Diccionary(clase = DDUsoActivo.class,foreingField="codigo",  message = "El codUso no existe",
				groups = { Insert.class, Update.class })
	private String codUso;
	
	private Float metrosLinealesFachadaPrincipal;
	
	private Boolean almacen;
	
	private Float almacenSuperficie;
	
	private Boolean superficieVentaExposicion;
	
	private Float superficieVentaExposicionConstruido;
	
	private Boolean entreplanta;
	
	private Float altura;
	
	private Float porcentajeEdificacionEjecutada;
	
	private Boolean ocupado;
	
	private Boolean visitableFechaVisita;
	
	private Float valorEstimadoMaxVenta;
	
	private Float valorEstimadoMinVenta;
	
	private Float valorEstimadoVenta;
	
	private Float valorEstimadoMaxRenta;
	
	private Float valorEstimadoMinRenta;

	private Float valorEstimadoRenta;
	
	private Integer numeroSalones;
	
	private Integer numeroEstancias;
	
	private Integer numeroPlantas;
	
	private List<TestigosOpcionalesDto> testigos;

	
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

	public Long getIdInformeMediadorWebcom() {
		return idInformeMediadorWebcom;
	}

	public void setIdInformeMediadorWebcom(Long idInformeMediadorWebcom) {
		this.idInformeMediadorWebcom = idInformeMediadorWebcom;
	}

	public Long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

	public Long getIdInformeMediadorRem() {
		return idInformeMediadorRem;
	}

	public void setIdInformeMediadorRem(Long idInformeMediadorRem) {
		this.idInformeMediadorRem = idInformeMediadorRem;
	}

	public String getCodTipoVenta() {
		return codTipoVenta;
	}

	public void setCodTipoVenta(String codTipoVenta) {
		this.codTipoVenta = codTipoVenta;
	}

	public String getEstadoInforme() {
		return estadoInforme;
	}

	public void setEstadoInforme(String estadoInforme) {
		this.estadoInforme = estadoInforme;
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

	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}

	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}

	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public String getCodSubtipoInmueble() {
		return codSubtipoInmueble;
	}

	public void setCodSubtipoInmueble(String codSubtipoInmueble) {
		this.codSubtipoInmueble = codSubtipoInmueble;
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

	public Integer getNumeroDormitorios() {
		return numeroDormitorios;
	}

	public void setNumeroDormitorios(Integer numeroDormitorios) {
		this.numeroDormitorios = numeroDormitorios;
	}

	public Integer getNumeroBanyos() {
		return numeroBanyos;
	}

	public void setNumeroBanyos(Integer numeroBanyos) {
		this.numeroBanyos = numeroBanyos;
	}

	public Integer getNumeroAseos() {
		return numeroAseos;
	}

	public void setNumeroAseos(Integer numeroAseos) {
		this.numeroAseos = numeroAseos;
	}

	public Integer getNumeroPlazasGaraje() {
		return numeroPlazasGaraje;
	}

	public void setNumeroPlazasGaraje(Integer numeroPlazasGaraje) {
		this.numeroPlazasGaraje = numeroPlazasGaraje;
	}

	public Boolean getTerraza() {
		return terraza;
	}

	public void setTerraza(Boolean terraza) {
		this.terraza = terraza;
	}

	public Boolean getPatio() {
		return patio;
	}

	public void setPatio(Boolean patio) {
		this.patio = patio;
	}

	public Boolean getAscensor() {
		return ascensor;
	}

	public void setAscensor(Boolean ascensor) {
		this.ascensor = ascensor;
	}

	public Float getUtilSuperficie() {
		return utilSuperficie;
	}

	public void setUtilSuperficie(Float utilSuperficie) {
		this.utilSuperficie = utilSuperficie;
	}

	public Boolean getRehabilitado() {
		return rehabilitado;
	}

	public void setRehabilitado(Boolean rehabilitado) {
		this.rehabilitado = rehabilitado;
	}

	public Integer getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}

	public void setAnyoRehabilitacion(Integer anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}

	public Boolean getLicenciaApertura() {
		return licenciaApertura;
	}

	public void setLicenciaApertura(Boolean licenciaApertura) {
		this.licenciaApertura = licenciaApertura;
	}
	
	public Boolean getLicenciaObra() {
		return licenciaObra;
	}

	public void setLicenciaObra(Boolean licenciaObra) {
		this.licenciaObra = licenciaObra;
	}

	public String getDescripcionComercial() {
		return descripcionComercial;
	}

	public void setDescripcionComercial(String descripcionComercial) {
		this.descripcionComercial = descripcionComercial;
	}

	public String getCodEstadoConservacion() {
		return codEstadoConservacion;
	}

	public void setCodEstadoConservacion(String codEstadoConservacion) {
		this.codEstadoConservacion = codEstadoConservacion;
	}

	public Boolean getAnejoTrastero() {
		return anejoTrastero;
	}

	public void setAnejoTrastero(Boolean anejoTrastero) {
		this.anejoTrastero = anejoTrastero;
	}

	public Boolean getAnejoGaraje() {
		return anejoGaraje;
	}

	public void setAnejoGaraje(Boolean anejoGaraje) {
		this.anejoGaraje = anejoGaraje;
	}

	public String getCocinaRating() {
		return cocinaRating;
	}

	public void setCocinaRating(String cocinaRating) {
		this.cocinaRating = cocinaRating;
	}

	public Boolean getCocinaAmueblada() {
		return cocinaAmueblada;
	}

	public void setCocinaAmueblada(Boolean cocinaAmueblada) {
		this.cocinaAmueblada = cocinaAmueblada;
	}

	public List<String> getCodesOrientacion() {
		return codesOrientacion;
	}

	public void setCodesOrientacion(List<String> codesOrientacion) {
		this.codesOrientacion = codesOrientacion;
	}

	public String getCodCalefaccion() {
		return codCalefaccion;
	}

	public void setCodesCalefaccion(String codCalefaccion) {
		this.codCalefaccion = codCalefaccion;
	}

	public String getCodTipoCalefaccion() {
		return codTipoCalefaccion;
	}

	public void setCodTipoCalefaccion(String codTipoCalefaccion) {
		this.codTipoCalefaccion = codTipoCalefaccion;
	}

	public String getCodAireAcondicionado() {
		return codAireAcondicionado;
	}

	public void setCodAireAcondicionado(String codAireAcondicionado) {
		this.codAireAcondicionado = codAireAcondicionado;
	}

	public Boolean getExistenArmariosEmpotrados() {
		return existenArmariosEmpotrados;
	}

	public void setExistenArmariosEmpotrados(Boolean existenArmariosEmpotrados) {
		this.existenArmariosEmpotrados = existenArmariosEmpotrados;
	}

	public Float getSuperficieTerraza() {
		return superficieTerraza;
	}

	public void setSuperficieTerraza(Float superficieTerraza) {
		this.superficieTerraza = superficieTerraza;
	}

	public Float getSuperficiePatio() {
		return superficiePatio;
	}

	public void setSuperficiePatio(Float superficiePatio) {
		this.superficiePatio = superficiePatio;
	}

	public String getExteriorInterior() {
		return exteriorInterior;
	}

	public void setExteriorInterior(String exteriorInterior) {
		this.exteriorInterior = exteriorInterior;
	}

	public Boolean getExistenZonasVerdes() {
		return existenZonasVerdes;
	}

	public void setExistenZonasVerdes(Boolean existenZonasVerdes) {
		this.existenZonasVerdes = existenZonasVerdes;
	}

	public Boolean getExisteConserjeVigilancia() {
		return existeConserjeVigilancia;
	}

	public void setExisteConserjeVigilancia(Boolean existeConserjeVigilancia) {
		this.existeConserjeVigilancia = existeConserjeVigilancia;
	}

	public String getJardin() {
		return jardin;
	}

	public void setJardin(String jardin) {
		this.jardin = jardin;
	}

	public String getPiscina() {
		return piscina;
	}

	public void setPiscina(String piscina) {
		this.piscina = piscina;
	}

	public Boolean getExistenInstalacionesDeportivas() {
		return existenInstalacionesDeportivas;
	}

	public void setExistenInstalacionesDeportivas(Boolean existenInstalacionesDeportivas) {
		this.existenInstalacionesDeportivas = existenInstalacionesDeportivas;
	}

	public String getGimnasio() {
		return gimnasio;
	}

	public void setGimnasio(String gimnasio) {
		this.gimnasio = gimnasio;
	}

	public Boolean getAccesoMinusvalidosOtrasCaracteristicas() {
		return accesoMinusvalidosOtrasCaracteristicas;
	}

	public void setAccesoMinusvalidosOtrasCaracteristicas(Boolean accesoMinusvalidosOtrasCaracteristicas) {
		this.accesoMinusvalidosOtrasCaracteristicas = accesoMinusvalidosOtrasCaracteristicas;
	}

	public String getCodEstadoConservacionEdificio() {
		return codEstadoConservacionEdificio;
	}

	public void setCodEstadoConservacionEdificio(String codEstadoConservacionEdificio) {
		this.codEstadoConservacionEdificio = codEstadoConservacionEdificio;
	}

	public Integer getNumeroPlantasEdificio() {
		return numeroPlantasEdificio;
	}

	public void setNumeroPlantasEdificio(Integer numeroPlantasEdificio) {
		this.numeroPlantasEdificio = numeroPlantasEdificio;
	}

	public String getCodTipoPuertaAcceso() {
		return codTipoPuertaAcceso;
	}

	public void setCodTipoPuertaAcceso(String codTipoPuertaAcceso) {
		this.codTipoPuertaAcceso = codTipoPuertaAcceso;
	}

	public String getCodEstadoPuertasInteriores() {
		return codEstadoPuertasInteriores;
	}

	public void setCodEstadoPuertasInteriores(String codEstadoPuertasInteriores) {
		this.codEstadoPuertasInteriores = codEstadoPuertasInteriores;
	}

	public String getCodEstadoVentanas() {
		return codEstadoVentanas;
	}

	public void setCodEstadoVentanas(String codEstadoVentanas) {
		this.codEstadoVentanas = codEstadoVentanas;
	}

	public String getCodEstadoPersianas() {
		return codEstadoPersianas;
	}

	public void setCodEstadoPersianas(String codEstadoPersianas) {
		this.codEstadoPersianas = codEstadoPersianas;
	}

	public String getCodEstadoPintura() {
		return codEstadoPintura;
	}

	public void setCodEstadoPintura(String codEstadoPintura) {
		this.codEstadoPintura = codEstadoPintura;
	}

	public String getCodEstadoSolados() {
		return codEstadoSolados;
	}

	public void setCodEstadoSolados(String codEstadoSolados) {
		this.codEstadoSolados = codEstadoSolados;
	}

	public String getCodAdmiteMascota() {
		return codAdmiteMascota;
	}

	public void setCodAdmiteMascota(String codAdmiteMascota) {
		this.codAdmiteMascota = codAdmiteMascota;
	}

	public String getCodEstadoBanyos() {
		return codEstadoBanyos;
	}

	public void setCodEstadoBanyos(String codEstadoBanyos) {
		this.codEstadoBanyos = codEstadoBanyos;
	}

	public String getCodValoracionUbicacion() {
		return codValoracionUbicacion;
	}

	public void setCodValoracionUbicacion(String codValoracionUbicacion) {
		this.codValoracionUbicacion = codValoracionUbicacion;
	}

	public String getCodUbicacion() {
		return codUbicacion;
	}

	public void setCodUbicacion(String codUbicacion) {
		this.codUbicacion = codUbicacion;
	}

	public Boolean getSalidaHumosOtrasCaracteristicas() {
		return salidaHumosOtrasCaracteristicas;
	}

	public void setSalidaHumosOtrasCaracteristicas(Boolean salidaHumosOtrasCaracteristicas) {
		this.salidaHumosOtrasCaracteristicas = salidaHumosOtrasCaracteristicas;
	}

	public Boolean getAptoUsoEnBruto() {
		return aptoUsoEnBruto;
	}

	public void setAptoUsoEnBruto(Boolean aptoUsoEnBruto) {
		this.aptoUsoEnBruto = aptoUsoEnBruto;
	}

	public String getCodAccesibilidad() {
		return codAccesibilidad;
	}

	public void setCodAccesibilidad(String codAccesibilidad) {
		this.codAccesibilidad = codAccesibilidad;
	}

	public Float getEdificabilidadSuperficieTecho() {
		return edificabilidadSuperficieTecho;
	}

	public void setEdificabilidadSuperficieTecho(Float edificabilidadSuperficieTecho) {
		this.edificabilidadSuperficieTecho = edificabilidadSuperficieTecho;
	}

	public Float getParcelaSuperficie() {
		return parcelaSuperficie;
	}

	public void setParcelaSuperficie(Float parcelaSuperficie) {
		this.parcelaSuperficie = parcelaSuperficie;
	}

	public Float getPorcentajeUrbanizacionEjecutado() {
		return porcentajeUrbanizacionEjecutado;
	}

	public void setPorcentajeUrbanizacionEjecutado(Float porcentajeUrbanizacionEjecutado) {
		this.porcentajeUrbanizacionEjecutado = porcentajeUrbanizacionEjecutado;
	}

	public String getClasificacion() {
		return clasificacion;
	}

	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}

	public String getCodUso() {
		return codUso;
	}

	public void setCodUso(String codUso) {
		this.codUso = codUso;
	}

	public Float getMetrosLinealesFachadaPrincipal() {
		return metrosLinealesFachadaPrincipal;
	}

	public void setMetrosLinealesFachadaPrincipal(Float metrosLinealesFachadaPrincipal) {
		this.metrosLinealesFachadaPrincipal = metrosLinealesFachadaPrincipal;
	}

	public Boolean getAlmacen() {
		return almacen;
	}

	public void setAlmacen(Boolean almacen) {
		this.almacen = almacen;
	}

	public Float getAlmacenSuperficie() {
		return almacenSuperficie;
	}

	public void setAlmacenSuperficie(Float almacenSuperficie) {
		this.almacenSuperficie = almacenSuperficie;
	}

	public Boolean getSuperficieVentaExposicion() {
		return superficieVentaExposicion;
	}

	public void setSuperficieVentaExposicion(Boolean superficieVentaExposicion) {
		this.superficieVentaExposicion = superficieVentaExposicion;
	}

	public Float getSuperficieVentaExposicionConstruido() {
		return superficieVentaExposicionConstruido;
	}

	public void setSuperficieVentaExposicionConstruido(Float superficieVentaExposicionConstruido) {
		this.superficieVentaExposicionConstruido = superficieVentaExposicionConstruido;
	}

	public Boolean getEntreplanta() {
		return entreplanta;
	}

	public void setEntreplanta(Boolean entreplanta) {
		this.entreplanta = entreplanta;
	}

	public Float getAltura() {
		return altura;
	}

	public void setAltura(Float altura) {
		this.altura = altura;
	}

	public Float getPorcentajeEdificacionEjecutada() {
		return porcentajeEdificacionEjecutada;
	}

	public void setPorcentajeEdificacionEjecutada(Float porcentajeEdificacionEjecutada) {
		this.porcentajeEdificacionEjecutada = porcentajeEdificacionEjecutada;
	}

	public Boolean getOcupado() {
		return ocupado;
	}

	public void setOcupado(Boolean ocupado) {
		this.ocupado = ocupado;
	}

	public Boolean getVisitableFechaVisita() {
		return visitableFechaVisita;
	}

	public void setVisitableFechaVisita(Boolean visitableFechaVisita) {
		this.visitableFechaVisita = visitableFechaVisita;
	}

	public Float getValorEstimadoMaxVenta() {
		return valorEstimadoMaxVenta;
	}

	public void setValorEstimadoMaxVenta(Float valorEstimadoMaxVenta) {
		this.valorEstimadoMaxVenta = valorEstimadoMaxVenta;
	}

	public Float getValorEstimadoMinVenta() {
		return valorEstimadoMinVenta;
	}

	public void setValorEstimadoMinVenta(Float valorEstimadoMinVenta) {
		this.valorEstimadoMinVenta = valorEstimadoMinVenta;
	}

	public Float getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}

	public void setValorEstimadoVenta(Float valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}

	public Float getValorEstimadoMaxRenta() {
		return valorEstimadoMaxRenta;
	}

	public void setValorEstimadoMaxRenta(Float valorEstimadoMaxRenta) {
		this.valorEstimadoMaxRenta = valorEstimadoMaxRenta;
	}

	public Float getValorEstimadoMinRenta() {
		return valorEstimadoMinRenta;
	}

	public void setValorEstimadoMinRenta(Float valorEstimadoMinRenta) {
		this.valorEstimadoMinRenta = valorEstimadoMinRenta;
	}

	public Float getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}

	public void setValorEstimadoRenta(Float valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}

	public Integer getNumeroSalones() {
		return numeroSalones;
	}

	public void setNumeroSalones(Integer numeroSalones) {
		this.numeroSalones = numeroSalones;
	}

	public Integer getNumeroEstancias() {
		return numeroEstancias;
	}

	public void setNumeroEstancias(Integer numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}

	public Integer getNumeroPlantas() {
		return numeroPlantas;
	}

	public void setNumeroPlantas(Integer numeroPlantas) {
		this.numeroPlantas = numeroPlantas;
	}

	public List<TestigosOpcionalesDto> getTestigos() {
		return testigos;
	}

	public void setTestigos(List<TestigosOpcionalesDto> testigos) {
		this.testigos = testigos;
	}
	
}