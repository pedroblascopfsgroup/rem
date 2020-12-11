package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

/**
 * Modelo que gestiona la informacion de los adjuntos.
 */

public class DtoActivoTributos implements Serializable{

	private static final long serialVersionUID = -7785802535778510517L;

    private String numActivo;
    
    private Long idTributo;
    
    private String fechaPresentacion;    
   
    private String fechaRecPropietario;

    private String fechaRecGestoria;
    
    private String tipoSolicitud;   

	private String observaciones;

	private String fechaRecRecursoPropietario;

	private String fechaRecRecursoGestoria;
	
	private String fechaRespRecurso;

	private String resultadoSolicitud;
	
	private Long numGastoHaya;
	
	private String existeDocumentoTributo;
	
	private String documentoTributoNombre;
	
	private Long documentoTributoId;
	
	private Long numTributo;
	
	private String tipoTributo;
	
	private String fechaRecepcionTributo;
	
	private String fechaPagoTributo;
	
	private Double importePagado;
	
	private Long numExpediente;
	
	private String fechaComunicacionDevolucionIngreso;
	
	private Double importeRecuperadoRecurso;
	
	private String estaExento;
	
	private String motivoExento;

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getFechaPresentacion() {
		return fechaPresentacion;
	}

	public void setFechaPresentacion(String fechaPresentacion) {
		this.fechaPresentacion = fechaPresentacion;
	}

	public String getFechaRecPropietario() {
		return fechaRecPropietario;
	}

	public void setFechaRecPropietario(String fechaRecPropietario) {
		this.fechaRecPropietario = fechaRecPropietario;
	}

	public String getFechaRecGestoria() {
		return fechaRecGestoria;
	}

	public void setFechaRecGestoria(String fechaRecGestoria) {
		this.fechaRecGestoria = fechaRecGestoria;
	}

	public String getTipoSolicitud() {
		return tipoSolicitud;
	}

	public void setTipoSolicitud(String tipoSolicitud) {
		this.tipoSolicitud = tipoSolicitud;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getFechaRecRecursoPropietario() {
		return fechaRecRecursoPropietario;
	}

	public void setFechaRecRecursoPropietario(String fechaRecRecursoPropietario) {
		this.fechaRecRecursoPropietario = fechaRecRecursoPropietario;
	}

	public String getFechaRecRecursoGestoria() {
		return fechaRecRecursoGestoria;
	}

	public void setFechaRecRecursoGestoria(String fechaRecRecursoGestoria) {
		this.fechaRecRecursoGestoria = fechaRecRecursoGestoria;
	}

	public String getFechaRespRecurso() {
		return fechaRespRecurso;
	}

	public void setFechaRespRecurso(String fechaRespRecurso) {
		this.fechaRespRecurso = fechaRespRecurso;
	}

	public String getResultadoSolicitud() {
		return resultadoSolicitud;
	}

	public void setResultadoSolicitud(String resultadoSolicitud) {
		this.resultadoSolicitud = resultadoSolicitud;
	}

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public Long getIdTributo() {
		return idTributo;
	}

	public void setIdTributo(Long idTributo) {
		this.idTributo = idTributo;
	}

	public String getExisteDocumentoTributo() {
		return existeDocumentoTributo;
	}
	
	public void setExisteDocumentoTributo(String existeDocumentoTributo) {
		this.existeDocumentoTributo = existeDocumentoTributo;
	}

	public String getDocumentoTributoNombre() {
		return documentoTributoNombre;
	}

	public void setDocumentoTributoNombre(String documentoTributoNombre) {
		this.documentoTributoNombre = documentoTributoNombre;
	}

	public Long getDocumentoTributoId() {
		return documentoTributoId;
	}

	public void setDocumentoTributoId(Long documentoTributoId) {
		this.documentoTributoId = documentoTributoId;
	}

	public Long getNumTributo() {
		return numTributo;
	}

	public void setNumTributo(Long numTributo) {
		this.numTributo = numTributo;
	}

	public String getTipoTributo() {
		return tipoTributo;
	}

	public void setTipoTributo(String tipoTributo) {
		this.tipoTributo = tipoTributo;
	}

	public String getFechaRecepcionTributo() {
		return fechaRecepcionTributo;
	}

	public void setFechaRecepcionTributo(String fechaRecepcionTributo) {
		this.fechaRecepcionTributo = fechaRecepcionTributo;
	}

	public String getFechaPagoTributo() {
		return fechaPagoTributo;
	}

	public void setFechaPagoTributo(String fechaPagoTributo) {
		this.fechaPagoTributo = fechaPagoTributo;
	}

	public Double getImportePagado() {
		return importePagado;
	}

	public void setImportePagado(Double importePagado) {
		this.importePagado = importePagado;
	}

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public String getFechaComunicacionDevolucionIngreso() {
		return fechaComunicacionDevolucionIngreso;
	}

	public void setFechaComunicacionDevolucionIngreso(String fechaComunicacionDevolucionIngreso) {
		this.fechaComunicacionDevolucionIngreso = fechaComunicacionDevolucionIngreso;
	}

	public Double getImporteRecuperadoRecurso() {
		return importeRecuperadoRecurso;
	}

	public void setImporteRecuperadoRecurso(Double importeRecuperadoRecurso) {
		this.importeRecuperadoRecurso = importeRecuperadoRecurso;
	}

	public String getEstaExento() {
		return estaExento;
	}

	public void setEstaExento(String estaExento) {
		this.estaExento = estaExento;
	}

	public String getMotivoExento() {
		return motivoExento;
	}

	public void setMotivoExento(String motivoExento) {
		this.motivoExento = motivoExento;
	}

	
}
