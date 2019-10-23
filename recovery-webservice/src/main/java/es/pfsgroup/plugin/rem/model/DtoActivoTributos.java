package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Modelo que gestiona la informacion de los adjuntos.
 */

public class DtoActivoTributos implements Serializable{

	private static final long serialVersionUID = -7785802535778510517L;

    private String numActivo;
    
    private Long idTributo;
    
    private Date fechaPresentacion;    
   
    private Date fechaRecPropietario;

    private Date fechaRecGestoria;
    
    private String tipoSolicitud;   

	private String observaciones;

	private Date fechaRecRecursoPropietario;

	private Date fechaRecRecursoGestoria;
	
	private Date fechaRespRecurso;

	private String resultadoSolicitud;
	
	private Long numGastoHaya;
	
	private String existeDocumentoTributo;
	
	private String documentoTributoNombre;
	
	private Long documentoTributoId;

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public Date getFechaPresentacion() {
		return fechaPresentacion;
	}

	public void setFechaPresentacion(Date fechaPresentacion) {
		this.fechaPresentacion = fechaPresentacion;
	}

	public Date getFechaRecPropietario() {
		return fechaRecPropietario;
	}

	public void setFechaRecPropietario(Date fechaRecPropietario) {
		this.fechaRecPropietario = fechaRecPropietario;
	}

	public Date getFechaRecGestoria() {
		return fechaRecGestoria;
	}

	public void setFechaRecGestoria(Date fechaRecGestoria) {
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

	public Date getFechaRecRecursoPropietario() {
		return fechaRecRecursoPropietario;
	}

	public void setFechaRecRecursoPropietario(Date fechaRecRecursoPropietario) {
		this.fechaRecRecursoPropietario = fechaRecRecursoPropietario;
	}

	public Date getFechaRecRecursoGestoria() {
		return fechaRecRecursoGestoria;
	}

	public void setFechaRecRecursoGestoria(Date fechaRecRecursoGestoria) {
		this.fechaRecRecursoGestoria = fechaRecRecursoGestoria;
	}

	public Date getFechaRespRecurso() {
		return fechaRespRecurso;
	}

	public void setFechaRespRecurso(Date fechaRespRecurso) {
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

	

	

	
	
}
