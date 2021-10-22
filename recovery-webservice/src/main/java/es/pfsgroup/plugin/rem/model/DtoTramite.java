package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar el detalle de los trámites
 * @author Daniel Gutiérrez
 *
 */
public class DtoTramite extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private Long idTramite;

	private Long idTipoTramite;
	
	private String tipoTramite;
	
	private Long idTramitePadre;

	private Long idActivo;
	
	private String nombre;
	
	private String estado;
	
	private Long idTrabajo;
	
	private Long numTrabajo;
	
	private String cartera;

	private String codigoCartera;
	
	private String fechaInicio;
	
	private String fechaFinalizacion;
	
	private String tipoTrabajo;
	
	private String subtipoTrabajo;
	
	private String codigoSubtipoTrabajo;
	
	private String tipoActivo;
	
	private String subtipoActivo;
	
	private Long numActivo;
	
	private Boolean esMultiActivo;
	
	private Long countActivos;

	private Boolean ocultarBotonCierre;
	
	private Boolean ocultarBotonResolucionAlquiler;
	
	private Boolean ocultarBotonResolucion;
	
	private Boolean ocultarBotonAnular;

	private Boolean tieneEC;
	
	private String descripcionEstadoEC;
	
	private Long numEC;
	
	private Long idExpediente;
	
	private Boolean estaTareaRespuestaBankiaDevolucion;
	
	private Boolean estaTareaPendienteDevolucion;
	
	private Boolean estaTareaRespuestaBankiaAnulacionDevolucion;
	
	private Boolean estaEnTareaSiguienteResolucionExpediente;
	
	private Boolean ocultarBotonLanzarTareaAdministrativa;

	private Boolean esTarifaPlana;

	private Boolean ocultarBotonReactivarTramite;
	
	private Boolean desactivarBotonLanzarTareaAdministrativa;
	
	private Boolean activoAplicaGestion;
	
	private Boolean esTareaAutorizacionBankia;
	
	private String codigoSubcartera;

	private Boolean tramiteVentaAnulado;
	
	private Boolean tramiteAlquilerAnulado;
	
	private Boolean esTareaSolicitudOAutorizacion;
	
	private Boolean esGestorAutorizado;
	
	private Boolean estaEnTareaReserva;
	
	private String codigoEstadoExpedienteComercial;
	
	private String codigoEstadoExpediente;
	
	private String codigoEstadoExpedienteBC;

	private String fechaContabilizacion;

	private String fechaContabilizacionPropietario;
	
	
	
	public Long getIdTramite() {
		return idTramite;
	}

	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}

	public Long getIdTipoTramite() {
		return idTipoTramite;
	}

	public void setIdTipoTramite(Long idTipoTramite) {
		this.idTipoTramite = idTipoTramite;
	}

	public String getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(String tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public Long getIdTramitePadre() {
		return idTramitePadre;
	}

	public void setIdTramitePadre(Long idTramitePadre) {
		this.idTramitePadre = idTramitePadre;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public Long getIdTrabajo(){
		return idTrabajo;
	}
	
	public void setIdTrabajo(Long idTrabajo){
		this.idTrabajo = idTrabajo;
	}
	
	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getCartera(){
		return cartera;
	}
	
	public void setCartera(String cartera){
		this.cartera = cartera;
	}

	public String getCodigoCartera(){
		return codigoCartera;
	}
	
	public void setCodigoCartera(String codigoCartera){
		this.codigoCartera = codigoCartera;
	}
	
	public String getFechaInicio(){
		return fechaInicio;
	}
	
	public void setFechaInicio(String fechaInicio){
		this.fechaInicio = fechaInicio;
	}
	
	public String getFechaFinalizacion(){
		return fechaFinalizacion;
	}
	
	public void setFechaFinalizacion(String fechaFin){
		this.fechaFinalizacion = fechaFin;
	}
	
	public String getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(String tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public String getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(String subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}	
	
	public String getCodigoSubtipoTrabajo() {
		return codigoSubtipoTrabajo;
	}

	public void setCodigoSubtipoTrabajo(String codigoSubtipoTrabajo) {
		this.codigoSubtipoTrabajo = codigoSubtipoTrabajo;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Boolean getEsMultiActivo() {
		return esMultiActivo;
	}
	
	public void setEsMultiActivo(Boolean esMultiActivo) {
		this.esMultiActivo = esMultiActivo;
	}

	public Long getCountActivos() {
		return countActivos;
	}

	public void setCountActivos(Long countActivos) {
		this.countActivos = countActivos;
	}

	public Boolean getOcultarBotonCierre() {
		return ocultarBotonCierre;
	}

	public void setOcultarBotonCierre(Boolean ocultarBotonCierre) {
		this.ocultarBotonCierre = ocultarBotonCierre;
	}
	
	public Boolean getOcultarBotonResolucion() {
		return ocultarBotonResolucion;
	}

	public void setOcultarBotonResolucion(Boolean ocultarBotonResolucion) {
		this.ocultarBotonResolucion = ocultarBotonResolucion;
	}
	
	public Boolean getTieneEC() {
		return tieneEC;
	}

	public void setTieneEC(Boolean tieneEC) {
		this.tieneEC = tieneEC;
	}

	public String getDescripcionEstadoEC() {
		return descripcionEstadoEC;
	}

	public void setDescripcionEstadoEC(String descripcionEstadoEC) {
		this.descripcionEstadoEC = descripcionEstadoEC;
	}

	public Long getNumEC() {
		return numEC;
	}

	public void setNumEC(Long numEC) {
		this.numEC = numEC;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Boolean getOcultarBotonAnular() {
		return ocultarBotonAnular;
	}

	public void setOcultarBotonAnular(Boolean ocultarBotonAnular) {
		this.ocultarBotonAnular = ocultarBotonAnular;
	}

	public Boolean getEstaTareaPendienteDevolucion() {
		return estaTareaPendienteDevolucion;
	}

	public void setEstaTareaPendienteDevolucion(Boolean estaTareaPendienteDevolucion) {
		this.estaTareaPendienteDevolucion = estaTareaPendienteDevolucion;
	}

	public Boolean getEstaTareaRespuestaBankiaDevolucion() {
		return estaTareaRespuestaBankiaDevolucion;
	}

	public void setEstaTareaRespuestaBankiaDevolucion(Boolean estaTareaRespuestaBankiaDevolucion) {
		this.estaTareaRespuestaBankiaDevolucion = estaTareaRespuestaBankiaDevolucion;
	}

	public Boolean getEstaTareaRespuestaBankiaAnulacionDevolucion() {
		return estaTareaRespuestaBankiaAnulacionDevolucion;
	}

	public void setEstaTareaRespuestaBankiaAnulacionDevolucion(Boolean estaTareaRespuestaBankiaAnulacionDevolucion) {
		this.estaTareaRespuestaBankiaAnulacionDevolucion = estaTareaRespuestaBankiaAnulacionDevolucion;
	}

	public Boolean getEstaEnTareaSiguienteResolucionExpediente() {
		return estaEnTareaSiguienteResolucionExpediente;
	}

	public void setEstaEnTareaSiguienteResolucionExpediente(Boolean estaEnTareaSiguienteResolucionExpediente) {
		this.estaEnTareaSiguienteResolucionExpediente = estaEnTareaSiguienteResolucionExpediente;
	}
	
	public Boolean getOcultarBotonLanzarTareaAdministrativa() {
		return ocultarBotonLanzarTareaAdministrativa;
	}

	public void setOcultarBotonLanzarTareaAdministrativa(Boolean ocultarBotonLanzarTareaAdministrativa) {
		this.ocultarBotonLanzarTareaAdministrativa = ocultarBotonLanzarTareaAdministrativa;
	}

	public Boolean getOcultarBotonReactivarTramite() {
		return ocultarBotonReactivarTramite;
	}

	public void setOcultarBotonReactivarTramite(Boolean ocultarBotonReactivarTramite) {
		this.ocultarBotonReactivarTramite = ocultarBotonReactivarTramite;
	}
	
	public Boolean getDesactivarBotonLanzarTareaAdministrativa() {
		return desactivarBotonLanzarTareaAdministrativa;
	}

	public void setDesactivarBotonLanzarTareaAdministrativa(Boolean desactivarBotonLanzarTareaAdministrativa) {
		this.desactivarBotonLanzarTareaAdministrativa = desactivarBotonLanzarTareaAdministrativa;
	}

	public Boolean getEsTarifaPlana() {
		return esTarifaPlana;
	}

	public void setEsTarifaPlana(Boolean esTarifaPlana) {
		this.esTarifaPlana = esTarifaPlana;
	}

	public Boolean getActivoAplicaGestion() {
		return activoAplicaGestion;
	}

	public void setActivoAplicaGestion(Boolean activoAplicaGestion) {
		this.activoAplicaGestion = activoAplicaGestion;
	}

	public Boolean getEsTareaAutorizacionBankia() {
		return esTareaAutorizacionBankia;
	}

	public void setEsTareaAutorizacionBankia(Boolean esTareaAutorizacionBankia) {
		this.esTareaAutorizacionBankia = esTareaAutorizacionBankia;
	}

	public String getCodigoSubcartera() {
		return codigoSubcartera;
	}

	public void setCodigoSubcartera(String codigoSubcartera) {
		this.codigoSubcartera = codigoSubcartera;
	}
	
	public Boolean getOcultarBotonResolucionAlquiler() {
		return ocultarBotonResolucionAlquiler;
	}

	public void setOcultarBotonResolucionAlquiler(Boolean ocultarBotonResolucionAlquiler) {
		this.ocultarBotonResolucionAlquiler = ocultarBotonResolucionAlquiler;
	}
	
	public Boolean getTramiteVentaAnulado() {
		return tramiteVentaAnulado;
	}

	public void setTramiteVentaAnulado(Boolean tramiteVentaAnulado) {
		this.tramiteVentaAnulado = tramiteVentaAnulado;
	}

	public Boolean getTramiteAlquilerAnulado() {
		return tramiteAlquilerAnulado;
	}

	public void setTramiteAlquilerAnulado(Boolean tramiteAlquilerAnulado) {
		this.tramiteAlquilerAnulado = tramiteAlquilerAnulado;
	}

	public Boolean getEsTareaSolicitudOAutorizacion() {
		return esTareaSolicitudOAutorizacion;
	}

	public void setEsTareaSolicitudOAutorizacion(Boolean esTareaSolicitudOAutorizacion) {
		this.esTareaSolicitudOAutorizacion = esTareaSolicitudOAutorizacion;
	}

	public Boolean getEsGestorAutorizado() {
		return esGestorAutorizado;
	}

	public void setEsGestorAutorizado(Boolean esGestorAutorizado) {
		this.esGestorAutorizado = esGestorAutorizado;
	}

	public Boolean getEstaEnTareaReserva() {
		return estaEnTareaReserva;
	}

	public void setEstaEnTareaReserva(Boolean estaEnTareaReserva) {
		this.estaEnTareaReserva = estaEnTareaReserva;
	}

	public String getCodigoEstadoExpedienteComercial() {
		return codigoEstadoExpedienteComercial;
	}

	public void setCodigoEstadoExpedienteComercial(String codigoEstadoExpedienteComercial) {
		this.codigoEstadoExpedienteComercial = codigoEstadoExpedienteComercial;
	}

	public String getCodigoEstadoExpediente() {
		return codigoEstadoExpediente;
	}

	public void setCodigoEstadoExpediente(String codigoEstadoExpediente) {
		this.codigoEstadoExpediente = codigoEstadoExpediente;
	}

	public String getCodigoEstadoExpedienteBC() {
		return codigoEstadoExpedienteBC;
	}

	public void setCodigoEstadoExpedienteBC(String codigoEstadoExpedienteBC) {
		this.codigoEstadoExpedienteBC = codigoEstadoExpedienteBC;
	}

	public String getFechaContabilizacion() {
		return fechaContabilizacion;
	}

	public void setFechaContabilizacion(String fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}

	public String getFechaContabilizacionPropietario() {
		return fechaContabilizacionPropietario;
	}

	public void setFechaContabilizacionPropietario(String fechaContabilizacionPropietario) {
		this.fechaContabilizacionPropietario = fechaContabilizacionPropietario;
	}
}