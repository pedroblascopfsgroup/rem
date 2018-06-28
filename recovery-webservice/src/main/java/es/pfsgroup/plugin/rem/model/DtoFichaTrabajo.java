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
    
    private Date horaConcreta;

    private Date fechaTope;
    
    private Boolean urgente;
    
    private Boolean riesgoInminenteTerceros;       

    private String tipoCalidadCodigo;

    private String  terceroNombre;

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
		
		if(this.horaConcreta!=null && this.fechaConcreta!=null) {
			Calendar fecha = new GregorianCalendar();
			Calendar hora = new GregorianCalendar();
			
			fecha.setTime(this.fechaConcreta);
			hora.setTime(this.horaConcreta);
			fecha.set(Calendar.HOUR,hora.get(Calendar.HOUR_OF_DAY));
			fecha.set(Calendar.MINUTE,hora.get(Calendar.MINUTE));
			 
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

	public Date getHoraConcreta() {
		return horaConcreta;
	}

	public void setHoraConcreta(Date horaConcreta) {
		this.horaConcreta = horaConcreta;
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
	
	
	
	
}
