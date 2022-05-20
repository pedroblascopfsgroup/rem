package es.pfsgroup.plugin.rem.model;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * Dto que gestiona la informacion de un trabajo.
 * 
 * @author Jose Villel
 *
 */
public class DtoFichaTrabajo {

	private Long idTrabajo;

	private String numTrabajo;

	private Long idTrabajoWebcom;

	private String nombreProveedor;

	private Long idProveedor;

	private String tipoTrabajoCodigo;

	private String tipoTrabajoDescripcion;

	private String subtipoTrabajoCodigo;

	private String subtipoTrabajoDescripcion;

	private String estadoCodigo;

	private String estadoDescripcion;

	private String descripcion;

	private Date fechaSolicitud;

	private Date fechaAprobacion;

	private Date fechaInicio;

	private Date fechaFin;

	private String continuoObservaciones;

	private Boolean cubreSeguro;

	private String ciaAseguradora;

	private Long idGestorActivoResponsable;

	private String gestorActivoResponsable;

	private Long idSupervisorActivo;

	private String supervisorActivo;

	private Long idResponsableTrabajo;

	private String responsableTrabajo;

	private Boolean esSolicitudConjunta;

	private Date fechaConcreta;
	
	private String fechaConcretaString;

	private Date horaConcreta;
	
	private String horaConcretaString;

	private Date fechaTope;

	private Boolean urgente;

	private Boolean riesgoInminenteTerceros;

	private String tipoCalidadCodigo;

	private String terceroNombre;

	private String terceroEmail;

	private String terceroDireccion;

	private String terceroContacto;

	private String terceroTel1;

	private String terceroTel2;

	private Long idSolicitante;

	private String solicitante;

	private String propietario;

	private Long idActivo;

	private Long idAgrupacion;

	private Long numAgrupacion;

	private String tipoAgrupacionDescripcion;

	private String participacion;

	private int numActivosAgrupacion;

	private String cartera;

	private String codCartera;

	private Date fechaFinCompromiso;

	private Date fechaRechazo;

	private String motivoRechazo;

	private Date fechaEleccionProveedor;

	private Date fechaEjecucionReal;

	private Date fechaAnulacion;

	private Date fechaValidacion;

	private Date fechaCierreEconomico;

	private Date fechaPago;

	private String nombreMediador;

	private Long idMediador;

	private Long idProceso;

	private Date fechaEmisionFactura;

	private String idsActivos;

	private Integer esTarifaPlana;

	private String codigoPromocionPrinex;

	private Date fechaAutorizacionPropietario;

	private Boolean bloquearResponsable;

	private Long idSupervisorAlquileres;

	private Long idSupervisorSuelos;

	private Long idSupervisorEdificaciones;

	private Boolean requerimiento;

	private Boolean logadoGestorMantenimiento;

	private String codSubcartera;

	private Boolean perteneceDNDtipoEdificacion;

	private Long numeroDND;

	private String nombreDND;

	private String codigoPartida;

	private String codigoSubpartida;

	private String estadoGasto;

	private Long gastoProveedor;

	private String nombreUg;

	private String nombreProyecto;

	private String nombreExpediente;
	

	private Long trabajoDnd;

	private String gestorActivo;
	
	private Boolean tieneTramiteCreado;
	
	private Boolean esFEjecucionEditable;
	
	private Boolean esTarifaPlanaEditable;
	
	private Boolean esSiniestroEditable;
	
	private Boolean esEstadoEditable;
	
	private String idTarea;
	
	private String idTarifas;
	
	private Double importePresupuesto;
	
	private String refImportePresupueso;
	private Boolean riesgosTerceros;
	
	private String descripcionGeneral;
	
	private Long gestorActivoCodigo;
	
	private Long numAlbaran;
	
	private Long numGasto;

	private String estadoGastoCodigo;
	
	private Boolean cubiertoSeguro;
	
	private Double importePrecio;
	
	private Boolean aplicaComite;
	
	private String resolucionComiteCodigo;
	
	private Date fechaResolucionComite;
	
	private String resolucionComiteId;
	
	private String estadoTrabajoCodigo;
	
	private Date fechaEjecucionTrabajo;
	
	private Boolean tarifaPlana;
	
	private Boolean riesgoSiniestro;
	
	private String proovedorCodigo;
	
	private Date fechaEntregaLlaves;
	
	private String receptorCodigo;
	
	private Boolean llavesNoAplica;
	
	private String llavesMotivo;
	
	private Long idProveedorReceptor;
	private Long idProveedorLlave;
	
	//
	private Boolean llavesNoAplicaTrabajo;
	private Boolean riesgoSiniestroTrabajo;
	private Boolean tarifaPlanaTrabajo;
	private Boolean aplicaComiteTrabajo;
	private Boolean riesgosTercerosTrabajo;
	
	private Boolean visualizarLlaves;
	
	private Integer tomaPosesion;
	
	private Long proveedorContact;
	private String estadoDescripcionyFecha;
	
	private String identificadorReamCodigo;
	
	private Boolean perteneceGastoOPrefactura;
	
	private String refacturacionTrabajoDescripcion;
	
	private String tipoCalculoMargenDescripcion;
	
	private Double porcentajeMargen;
	
	private Double importeMargen;
	
	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public Long getIdResponsableTrabajo() {
		return idResponsableTrabajo;
	}

	public void setIdResponsableTrabajo(Long idResponsableTrabajo) {
		this.idResponsableTrabajo = idResponsableTrabajo;
	}

	public String getResponsableTrabajo() {
		return responsableTrabajo;
	}

	public void setResponsableTrabajo(String responsableTrabajo) {
		this.responsableTrabajo = responsableTrabajo;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Long getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}

	public void setIdTrabajoWebcom(Long idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public String getTipoTrabajoCodigo() {
		return tipoTrabajoCodigo;
	}

	public void setTipoTrabajoCodigo(String tipoTrabajoCodigo) {
		this.tipoTrabajoCodigo = tipoTrabajoCodigo;
	}

	public String getTipoTrabajoDescripcion() {
		return tipoTrabajoDescripcion;
	}

	public void setTipoTrabajoDescripcion(String tipoTrabajoDescripcion) {
		this.tipoTrabajoDescripcion = tipoTrabajoDescripcion;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getSubtipoTrabajoCodigo() {
		return subtipoTrabajoCodigo;
	}

	public void setSubtipoTrabajoCodigo(String subtipoTrabajoCodigo) {
		this.subtipoTrabajoCodigo = subtipoTrabajoCodigo;
	}

	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}

	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}

	public String getEstadoCodigo() {
		return estadoCodigo;
	}

	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}

	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}

	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public String getContinuoObservaciones() {
		return continuoObservaciones;
	}

	public void setContinuoObservaciones(String continuoObservaciones) {
		this.continuoObservaciones = continuoObservaciones;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Boolean getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Boolean cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public String getCiaAseguradora() {
		return ciaAseguradora;
	}

	public void setCiaAseguradora(String ciaAseguradora) {
		this.ciaAseguradora = ciaAseguradora;
	}

	public Long getIdGestorActivoResponsable() {
		return idGestorActivoResponsable;
	}

	public void setIdGestorActivoResponsable(Long idGestorActivoResponsable) {
		this.idGestorActivoResponsable = idGestorActivoResponsable;
	}

	public String getGestorActivoResponsable() {
		return gestorActivoResponsable;
	}

	public void setGestorActivoResponsable(String gestorActivoResponsable) {
		this.gestorActivoResponsable = gestorActivoResponsable;
	}

	public Long getIdSupervisorActivo() {
		return idSupervisorActivo;
	}

	public void setIdSupervisorActivo(Long idSupervisorActivo) {
		this.idSupervisorActivo = idSupervisorActivo;
	}

	public String getSupervisorActivo() {
		return supervisorActivo;
	}

	public void setSupervisorActivo(String supervisorActivo) {
		this.supervisorActivo = supervisorActivo;
	}

	public Boolean getEsSolicitudConjunta() {
		return esSolicitudConjunta;
	}

	public void setEsSolicitudConjunta(Boolean esSolicitudConjunta) {
		this.esSolicitudConjunta = esSolicitudConjunta;
	}

	public Date getFechaHoraConcreta() {

		Date fechaHoraConcreta = null;

		if (this.horaConcreta != null && this.fechaConcreta != null) {
			Calendar fecha = new GregorianCalendar();
			Calendar hora = new GregorianCalendar();

			fecha.setTime(this.fechaConcreta);
			hora.setTime(this.horaConcreta);
			fecha.set(Calendar.HOUR, hora.get(Calendar.HOUR_OF_DAY));
			fecha.set(Calendar.MINUTE, hora.get(Calendar.MINUTE));

			fechaHoraConcreta = fecha.getTime();
		}

		return fechaHoraConcreta;
	}

	public Date getFechaConcreta() {
		return fechaConcreta;
	}

	public void setFechaConcreta(Date fechaConcreta) {
		this.fechaConcreta = fechaConcreta;
	}

	public String getFechaConcretaString() {
		return fechaConcretaString;
	}

	public void setFechaConcretaString(String fechaConcretaString) {
		this.fechaConcretaString = fechaConcretaString;
	}

	public Date getHoraConcreta() {
		return horaConcreta;
	}

	public void setHoraConcreta(Date horaConcreta) {
		this.horaConcreta = horaConcreta;
	}

	public String getHoraConcretaString() {
		return horaConcretaString;
	}

	public void setHoraConcretaString(String horaConcretaString) {
		this.horaConcretaString = horaConcretaString;
	}

	public Date getFechaTope() {
		return fechaTope;
	}

	public void setFechaTope(Date fechaTope) {
		this.fechaTope = fechaTope;
	}

	public Boolean getUrgente() {
		return urgente;
	}

	public void setUrgente(Boolean urgente) {
		this.urgente = urgente;
	}

	public Boolean getRiesgoInminenteTerceros() {
		return riesgoInminenteTerceros;
	}

	public void setRiesgoInminenteTerceros(Boolean riesgoInminenteTerceros) {
		this.riesgoInminenteTerceros = riesgoInminenteTerceros;
	}

	public String getTipoCalidadCodigo() {
		return tipoCalidadCodigo;
	}

	public void setTipoCalidadCodigo(String tipoCalidadCodigo) {
		this.tipoCalidadCodigo = tipoCalidadCodigo;
	}

	public String getTerceroNombre() {
		return terceroNombre;
	}

	public void setTerceroNombre(String terceroNombre) {
		this.terceroNombre = terceroNombre;
	}

	public String getTerceroEmail() {
		return terceroEmail;
	}

	public void setTerceroEmail(String terceroEmail) {
		this.terceroEmail = terceroEmail;
	}

	public String getTerceroDireccion() {
		return terceroDireccion;
	}

	public void setTerceroDireccion(String terceroDireccion) {
		this.terceroDireccion = terceroDireccion;
	}

	public String getTerceroContacto() {
		return terceroContacto;
	}

	public void setTerceroContacto(String terceroContacto) {
		this.terceroContacto = terceroContacto;
	}

	public String getTerceroTel1() {
		return terceroTel1;
	}

	public void setTerceroTel1(String terceroTel1) {
		this.terceroTel1 = terceroTel1;
	}

	public String getTerceroTel2() {
		return terceroTel2;
	}

	public void setTerceroTel2(String terceroTel2) {
		this.terceroTel2 = terceroTel2;
	}

	public Long getIdSolicitante() {
		return idSolicitante;
	}

	public void setIdSolicitante(Long idSolicitante) {
		this.idSolicitante = idSolicitante;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}

	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}

	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}

	public int getNumActivosAgrupacion() {
		return numActivosAgrupacion;
	}

	public void setNumActivosAgrupacion(int numActivosAgrupacion) {
		this.numActivosAgrupacion = numActivosAgrupacion;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getParticipacion() {
		return participacion;
	}

	public void setParticipacion(String participacion) {
		this.participacion = participacion;
	}

	public Date getFechaFinCompromiso() {
		return fechaFinCompromiso;
	}

	public void setFechaFinCompromiso(Date fechaFinCompromiso) {
		this.fechaFinCompromiso = fechaFinCompromiso;
	}

	public Date getFechaRechazo() {
		return fechaRechazo;
	}

	public void setFechaRechazo(Date fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public Date getFechaEleccionProveedor() {
		return fechaEleccionProveedor;
	}

	public void setFechaEleccionProveedor(Date fechaEleccionProveedor) {
		this.fechaEleccionProveedor = fechaEleccionProveedor;
	}

	public Date getFechaEjecucionReal() {
		return fechaEjecucionReal;
	}

	public void setFechaEjecucionReal(Date fechaEjecucionReal) {
		this.fechaEjecucionReal = fechaEjecucionReal;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public Date getFechaValidacion() {
		return fechaValidacion;
	}

	public void setFechaValidacion(Date fechaValidacion) {
		this.fechaValidacion = fechaValidacion;
	}

	public Date getFechaCierreEconomico() {
		return fechaCierreEconomico;
	}

	public void setFechaCierreEconomico(Date fechaCierreEconomico) {
		this.fechaCierreEconomico = fechaCierreEconomico;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public String getNombreMediador() {
		return nombreMediador;
	}

	public void setNombreMediador(String nombreMediador) {
		this.nombreMediador = nombreMediador;
	}

	public Long getIdMediador() {
		return idMediador;
	}

	public void setIdMediador(Long idMediador) {
		this.idMediador = idMediador;
	}

	public Long getIdProceso() {
		return idProceso;
	}

	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}

	public Date getFechaEmisionFactura() {
		return fechaEmisionFactura;
	}

	public void setFechaEmisionFactura(Date fechaEmisionFactura) {
		this.fechaEmisionFactura = fechaEmisionFactura;
	}

	public String getIdsActivos() {
		return idsActivos;
	}

	public void setIdsActivos(String idsActivos) {
		this.idsActivos = idsActivos;
	}

	public Integer getEsTarifaPlana() {
		return esTarifaPlana;
	}

	public void setEsTarifaPlana(Integer esTarifaPlana) {
		this.esTarifaPlana = esTarifaPlana;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public Date getFechaAutorizacionPropietario() {
		return fechaAutorizacionPropietario;
	}

	public void setFechaAutorizacionPropietario(Date fechaAutorizacionPropietario) {
		this.fechaAutorizacionPropietario = fechaAutorizacionPropietario;

	}

	public Boolean getBloquearResponsable() {
		return bloquearResponsable;
	}

	public void setBloquearResponsable(Boolean bloquearResponsable) {
		this.bloquearResponsable = bloquearResponsable;
	}

	public Long getIdSupervisorAlquileres() {
		return idSupervisorAlquileres;
	}

	public void setIdSupervisorAlquileres(Long idSupervisorAlquileres) {
		this.idSupervisorAlquileres = idSupervisorAlquileres;
	}

	public Long getIdSupervisorSuelos() {
		return idSupervisorSuelos;
	}

	public void setIdSupervisorSuelos(Long idSupervisorSuelos) {
		this.idSupervisorSuelos = idSupervisorSuelos;
	}

	public Long getIdSupervisorEdificaciones() {
		return idSupervisorEdificaciones;
	}

	public void setIdSupervisorEdificaciones(Long idSupervisorEdificaciones) {
		this.idSupervisorEdificaciones = idSupervisorEdificaciones;
	}

	public Boolean getRequerimiento() {
		return requerimiento;
	}

	public void setRequerimiento(Boolean requerimiento) {
		this.requerimiento = requerimiento;
	}

	public String getCodCartera() {
		return codCartera;
	}

	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}

	public Boolean getLogadoGestorMantenimiento() {
		return logadoGestorMantenimiento;
	}

	public void setLogadoGestorMantenimiento(Boolean logadoGestorMantenimiento) {
		this.logadoGestorMantenimiento = logadoGestorMantenimiento;
	}

	public String getCodSubcartera() {
		return codSubcartera;
	}

	public void setCodSubcartera(String codSubcartera) {
		this.codSubcartera = codSubcartera;
	}

	public Boolean getPerteneceDNDtipoEdificacion() {
		return perteneceDNDtipoEdificacion;
	}

	public void setPerteneceDNDtipoEdificacion(Boolean perteneceDNDtipoEdificacion) {
		this.perteneceDNDtipoEdificacion = perteneceDNDtipoEdificacion;
	}

	public Long getNumeroDND() {
		return numeroDND;
	}

	public void setNumeroDND(Long numeroDND) {
		this.numeroDND = numeroDND;
	}

	public String getNombreDND() {
		return nombreDND;
	}

	public void setNombreDND(String nombreDND) {
		this.nombreDND = nombreDND;
	}

	public String getCodigoPartida() {
		return codigoPartida;
	}

	public void setCodigoPartida(String codigoPartida) {
		this.codigoPartida = codigoPartida;
	}

	public String getCodigoSubpartida() {
		return codigoSubpartida;
	}

	public void setCodigoSubpartida(String codigoSubpartida) {
		this.codigoSubpartida = codigoSubpartida;
	}

	public String getEstadoGasto() {
		return estadoGasto;
	}

	public void setEstadoGasto(String estadoGasto) {
		this.estadoGasto = estadoGasto;
	}

	public Long getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(Long gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public String getNombreUg() {
		return nombreUg;
	}

	public void setNombreUg(String nombreUg) {
		this.nombreUg = nombreUg;
	}

	public String getNombreProyecto() {
		return nombreProyecto;
	}

	public void setNombreProyecto(String nombreProyecto) {
		this.nombreProyecto = nombreProyecto;
	}

	public String getNombreExpediente() {
		return nombreExpediente;
	}

	public void setNombreExpediente(String nombreExpediente) {
		this.nombreExpediente = nombreExpediente;
	}


	public Long getTrabajoDnd() {
		return trabajoDnd;
	}

	public void setTrabajoDnd(Long trabajoDnd) {
		this.trabajoDnd = trabajoDnd;
	}

	public String getGestorActivo() {
		return gestorActivo;
	}

	public void setGestorActivo(String gestorActivo) {
		this.gestorActivo = gestorActivo;
	}

	public Boolean getTieneTramiteCreado() {
		return tieneTramiteCreado;
	}

	public void setTieneTramiteCreado(Boolean tieneTramiteCreado) {
		this.tieneTramiteCreado = tieneTramiteCreado;
	}

	public Boolean getEsFEjecucionEditable() {
		return esFEjecucionEditable;
	}

	public void setEsFEjecucionEditable(Boolean esFEjecucionEditable) {
		this.esFEjecucionEditable = esFEjecucionEditable;
	}

	public Boolean getEsTarifaPlanaEditable() {
		return esTarifaPlanaEditable;
	}

	public void setEsTarifaPlanaEditable(Boolean esTarifaPlanaEditable) {
		this.esTarifaPlanaEditable = esTarifaPlanaEditable;
	}

	public Boolean getEsSiniestroEditable() {
		return esSiniestroEditable;
	}

	public void setEsSiniestroEditable(Boolean esSiniestroEditable) {
		this.esSiniestroEditable = esSiniestroEditable;
	}

	public Boolean getEsEstadoEditable() {
		return esEstadoEditable;
	}

	public void setEsEstadoEditable(Boolean esEstadoEditable) {
		this.esEstadoEditable = esEstadoEditable;
	}


	public String getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(String idTarea) {
		this.idTarea = idTarea;
	}

	public String getIdTarifas() {
		return idTarifas;
	}

	public void setIdTarifas(String idTarifas) {
		this.idTarifas = idTarifas;
	}

	public Double getImportePresupuesto() {
		return importePresupuesto;
	}

	public void setImportePresupuesto(Double importePresupuesto) {
		this.importePresupuesto = importePresupuesto;
	}

	public String getRefImportePresupueso() {
		return refImportePresupueso;
	}

	public void setRefImportePresupueso(String refImportePresupueso) {
		this.refImportePresupueso = refImportePresupueso;
	}

	public String getDescripcionGeneral() {
		return descripcionGeneral;
	}

	public void setDescripcionGeneral(String descripcionGeneral) {
		this.descripcionGeneral = descripcionGeneral;
	}

	public Long getGestorActivoCodigo() {
		return gestorActivoCodigo;
	}

	public void setGestorActivoCodigo(Long gestorActivoCodigo) {
		this.gestorActivoCodigo = gestorActivoCodigo;
	}

	public Long getNumAlbaran() {
		return numAlbaran;
	}

	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}

	public Long getNumGasto() {
		return numGasto;
	}

	public void setNumGasto(Long numGasto) {
		this.numGasto = numGasto;
	}

	public String getEstadoGastoCodigo() {
		return estadoGastoCodigo;
	}

	public void setEstadoGastoCodigo(String estadoGastoCodigo) {
		this.estadoGastoCodigo = estadoGastoCodigo;
	}

	public Boolean isCubiertoSeguro() {
		return cubiertoSeguro;
	}

	public void setCubiertoSeguro(Boolean cubiertoSeguro) {
		this.cubiertoSeguro = cubiertoSeguro;
	}

	public Double getImportePrecio() {
		return importePrecio;
	}

	public void setImportePrecio(Double importePrecio) {
		this.importePrecio = importePrecio;
	}

	public Boolean isAplicaComite() {
		return aplicaComite;
	}

	public void setAplicaComite(Boolean aplicaComite) {
		this.aplicaComite = aplicaComite;
	}

	public String getResolucionComiteCodigo() {
		return resolucionComiteCodigo;
	}

	public void setResolucionComiteCodigo(String resolucionComiteCodigo) {
		this.resolucionComiteCodigo = resolucionComiteCodigo;
	}


	public Date getFechaResolucionComite() {
		return fechaResolucionComite;
	}

	public void setFechaResolucionComite(Date fechaResolucionComite) {
		this.fechaResolucionComite = fechaResolucionComite;
	}


	public String getResolucionComiteId() {
		return resolucionComiteId;
	}

	public void setResolucionComiteId(String resolucionComiteId) {
		this.resolucionComiteId = resolucionComiteId;
	}



	public String getEstadoTrabajoCodigo() {
		return estadoTrabajoCodigo;
	}

	public void setEstadoTrabajoCodigo(String estadoTrabajoCodigo) {
		this.estadoTrabajoCodigo = estadoTrabajoCodigo;
	}

	public Date getFechaEjecucionTrabajo() {
		return fechaEjecucionTrabajo;
	}

	public void setFechaEjecucionTrabajo(Date fechaEjecucionTrabajo) {
		this.fechaEjecucionTrabajo = fechaEjecucionTrabajo;
	}

	public Boolean isTarifaPlana() {
		return tarifaPlana;
	}

	public void setTarifaPlana(Boolean tarifaPlana) {
		this.tarifaPlana = tarifaPlana;
	}

	public Boolean isRiesgoSiniestro() {
		return riesgoSiniestro;
	}

	public void setRiesgoSiniestro(Boolean riesgoSiniestro) {
		this.riesgoSiniestro = riesgoSiniestro;
	}

	public String getProovedorCodigo() {
		return proovedorCodigo;
	}

	public void setProovedorCodigo(String proovedorCodigo) {
		this.proovedorCodigo = proovedorCodigo;
	}

	public String getReceptorCodigo() {
		return receptorCodigo;
	}

	public void setReceptorCodigo(String receptorCodigo) {
		this.receptorCodigo = receptorCodigo;
	}

	public Boolean isLlavesNoAplica() {
		return llavesNoAplica;
	}

	public void setLlavesNoAplica(Boolean llavesNoAplica) {
		this.llavesNoAplica = llavesNoAplica;
	}

	public String getLlavesMotivo() {
		return llavesMotivo;
	}

	public void setLlavesMotivo(String llavesMotivo) {
		this.llavesMotivo = llavesMotivo;
	}

	public Boolean isRiesgosTerceros() {
		return riesgosTerceros;
	}

	public void setRiesgosTerceros(Boolean riesgosTerceros) {
		this.riesgosTerceros = riesgosTerceros;
	}

	public Boolean getLlavesNoAplicaTrabajo() {
		return llavesNoAplicaTrabajo;
	}

	public void setLlavesNoAplicaTrabajo(Boolean llavesNoAplicaTrabajo) {
		this.llavesNoAplicaTrabajo = llavesNoAplicaTrabajo;
	}

	public Boolean getRiesgoSiniestroTrabajo() {
		return riesgoSiniestroTrabajo;
	}

	public void setRiesgoSiniestroTrabajo(Boolean riesgoSiniestroTrabajo) {
		this.riesgoSiniestroTrabajo = riesgoSiniestroTrabajo;
	}

	public Boolean getTarifaPlanaTrabajo() {
		return tarifaPlanaTrabajo;
	}

	public void setTarifaPlanaTrabajo(Boolean tarifaPlanaTrabajo) {
		this.tarifaPlanaTrabajo = tarifaPlanaTrabajo;
	}

	public Boolean getAplicaComiteTrabajo() {
		return aplicaComiteTrabajo;
	}

	public void setAplicaComiteTrabajo(Boolean aplicaComiteTrabajo) {
		this.aplicaComiteTrabajo = aplicaComiteTrabajo;
	}

	public Boolean getRiesgosTercerosTrabajo() {
		return riesgosTercerosTrabajo;
	}

	public void setRiesgosTercerosTrabajo(Boolean riesgosTercerosTrabajo) {
		this.riesgosTercerosTrabajo = riesgosTercerosTrabajo;
	}

	public Boolean getRiesgosTerceros() {
		return riesgosTerceros;
	}

	public Boolean getCubiertoSeguro() {
		return cubiertoSeguro;
	}

	public Boolean getAplicaComite() {
		return aplicaComite;
	}

	public Boolean getTarifaPlana() {
		return tarifaPlana;
	}

	public Boolean getRiesgoSiniestro() {
		return riesgoSiniestro;
	}

	public Boolean getLlavesNoAplica() {
		return llavesNoAplica;
	}

	public Boolean getVisualizarLlaves() {
		return visualizarLlaves;
	}

	public void setVisualizarLlaves(Boolean visualizarLlaves) {
		this.visualizarLlaves = visualizarLlaves;
	}

	public Long getIdProveedorReceptor() {
		return idProveedorReceptor;
	}

	public void setIdProveedorReceptor(Long idProveedorReceptor) {
		this.idProveedorReceptor = idProveedorReceptor;
	}

	public Long getIdProveedorLlave() {
		return idProveedorLlave;
	}

	public void setIdProveedorLlave(Long idProveedorLlave) {
		this.idProveedorLlave = idProveedorLlave;
	}

	public Date getFechaEntregaLlaves() {
		return fechaEntregaLlaves;
	}

	public void setFechaEntregaLlaves(Date fechaEntregaLlaves) {
		this.fechaEntregaLlaves = fechaEntregaLlaves;
	}
	
	public Integer getTomaPosesion() {
		return tomaPosesion;
	}

	public void setTomaPosesion(Integer tomaPosesion) {
		this.tomaPosesion = tomaPosesion;

	}
	public Long getProveedorContact() {
		return proveedorContact;
	}

	public void setProveedorContact(Long proveedorContact) {
		this.proveedorContact = proveedorContact;
	}

	public String getEstadoDescripcionyFecha() {
		return estadoDescripcionyFecha;
	}

	public void setEstadoDescripcionyFecha(String estadoDescripcionyFecha) {
		this.estadoDescripcionyFecha = estadoDescripcionyFecha;
	}
	
	public String getIdentificadorReamCodigo() {
		return identificadorReamCodigo;
	}

	public void setIdentificadorReamCodigo(String identificadorReamCodigo) {
		this.identificadorReamCodigo = identificadorReamCodigo;
	}
	
	public Boolean getPerteneceGastoOPrefactura() {
		return perteneceGastoOPrefactura;
	}
	
	public void setPerteneceGastoOPrefactura(Boolean perteneceGastoOPrefactura) {
		this.perteneceGastoOPrefactura = perteneceGastoOPrefactura;
	}
	
	public String getRefacturacionTrabajoDescripcion() {
		return refacturacionTrabajoDescripcion;
	}
	
	public void setRefacturacionTrabajoDescripcion(String refacturacionTrabajoDescripcion) {
		this.refacturacionTrabajoDescripcion = refacturacionTrabajoDescripcion;
	}
	
	public String getTipoCalculoMargenDescripcion() {
		return tipoCalculoMargenDescripcion;
	}
	
	public void setTipoCalculoMargenDescripcion(String tipoCalculoMargenDescripcion) {
		this.tipoCalculoMargenDescripcion = tipoCalculoMargenDescripcion;
	}
	
	public Double getPorcentajeMargen() {
		return porcentajeMargen;
	}
	
	public void setPorcentajeMargen(Double porcentajeMargen) {
		this.porcentajeMargen = porcentajeMargen;
	}
	
	public Double getImporteMargen() {
		return importeMargen;
	}
	
	public void setImporteMargen(Double importeMargen) {
		this.importeMargen = importeMargen;
	}
}
