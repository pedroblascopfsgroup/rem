package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un activo-gasto.
 *  
 * @author Sergio Salt.
 *
 */
public class DtoAdmisionRevisionTitulo extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long   id;
	private Long idActivo;
	private String revisado;
	private String instLibArrendataria;
	private String ratificacion;
	private String situacionInicialInscripcion;
	private String situacionInicialInscripcionDescripcion;
	private String posesoriaInicial;
	private String posesoriaInicialDescripcion;
	private String situacionInicialCargas;
	private String situacionInicialCargasDescripcion;
	private String tipoTitularidad;
	private String tipoTitularidadDescripcion;
	private String estadoAutorizaTransmision;
	private String estadoAutorizaTransmisionDescripcion;
	private String anotacionConcurso;
	private String anotacionConcursoDescripcion;
	private String estadoGestionCa;
	private String estadoGestionCaDescripcion;
	private String consFisica;
	private String consJuridica;
	private String estadoCertificadoFinObra;
	private String estadoCertificadoFinObraDescripcion;
	private String estadoAfoActaFinObra;
	private String estadoAfoActaFinObraDescripcion;
	private String licenciaPrimeraOcupacion;
	private String licenciaPrimeraOcupacionDescripcion;
	private String boletines;
	private String boletinesDescripcion;
	private String seguroDecenal;
	private String seguroDecenalDescripcion;
	private String cedulaHabitabilidad;
	private String cedulaHabitabilidadDescripcion;
	private String tipoArrendamiento;
	private String tipoArrendamientoDescripcion;
	private String notificarArrendatarios;
	private String tipoExpediente;
	private String tipoExpedienteDescripcion;
	private String estadoGestionEa;
	private String estadoGestionEaDescripcion;
	private String tipoIncidenciaRegistral;
	private String tipoIncidenciaRegistralDescripcion;
	private String estadoGestionCr;
	private String estadoGestionCrDescripcion;
	private String tipoOcupacionLegal;
	private String tipoOcupacionLegalDescripcion;
	private String estadoGestionIl;
	private String estadoGestionIlDescripcion;
	private String estadoGestionOt;
	private String estadoGestionOtDescripcion;
	private Date   fechaRevisionTitulo;
	private Double porcentajePropiedad;
	private String observaciones;
	private Double porcentajeConsTasacionCf;
	private Double porcentajeConsTasacionCj;
	private Date   fechaContratoAlquiler;
	private String legislacionAplicableAlquiler;
	private String duracionContratoAlquiler;
	private String tipoIncidenciaIloc;
	private String deterioroGrave;
	private String tipoIncidenciaOtros;
	private String tipoTituloCodigo;
	private String tipoTituloDescripcion;
	private String subtipoTituloCodigo;
	private String subtipoTituloDescripcion;
	private String situacionConstructivaRegistral;
	private String situacionConstructivaRegistralDescripcion;
	private String proteccionOficial;
	private String proteccionOficialDescripcion;
	private String tipoIncidencia;
	private String tipoTituloActivo;
	private String subtipoTituloActivo;
	//
	private String tipoTituloActivoRef;
	private String subtipoTituloActivoRef;
    
	private boolean update = false;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRevisado() {
		return revisado;
	}
	public void setRevisado(String revisado) {
		this.revisado = revisado;
	}
	public String getInstLibArrendataria() {
		return instLibArrendataria;
	}
	public void setInstLibArrendataria(String instLibArrendataria) {
		this.instLibArrendataria = instLibArrendataria;
	}
	public String getRatificacion() {
		return ratificacion;
	}
	public void setRatificacion(String ratificacion) {
		this.ratificacion = ratificacion;
	}
	public String getSituacionInicialInscripcion() {
		return situacionInicialInscripcion;
	}
	public void setSituacionInicialInscripcion(String situacionInicialInscripcion) {
		this.situacionInicialInscripcion = situacionInicialInscripcion;
	}
	public String getSituacionInicialInscripcionDescripcion() {
		return situacionInicialInscripcionDescripcion;
	}
	public void setSituacionInicialInscripcionDescripcion(String situacionInicialInscripcionDescripcion) {
		this.situacionInicialInscripcionDescripcion = situacionInicialInscripcionDescripcion;
	}
	public String getPosesoriaInicial() {
		return posesoriaInicial;
	}
	public void setPosesoriaInicial(String posesoriaInicial) {
		this.posesoriaInicial = posesoriaInicial;
	}
	public String getPosesoriaInicialDescripcion() {
		return posesoriaInicialDescripcion;
	}
	public void setPosesoriaInicialDescripcion(String posesoriaInicialDescripcion) {
		this.posesoriaInicialDescripcion = posesoriaInicialDescripcion;
	}
	public String getSituacionInicialCargas() {
		return situacionInicialCargas;
	}
	public void setSituacionInicialCargas(String situacionInicialCargas) {
		this.situacionInicialCargas = situacionInicialCargas;
	}
	public String getSituacionInicialCargasDescripcion() {
		return situacionInicialCargasDescripcion;
	}
	public void setSituacionInicialCargasDescripcion(String situacionInicialCargasDescripcion) {
		this.situacionInicialCargasDescripcion = situacionInicialCargasDescripcion;
	}
	public String getTipoTitularidad() {
		return tipoTitularidad;
	}
	public void setTipoTitularidad(String tipoTitularidad) {
		this.tipoTitularidad = tipoTitularidad;
	}
	public String getTipoTitularidadDescripcion() {
		return tipoTitularidadDescripcion;
	}
	public void setTipoTitularidadDescripcion(String tipoTitularidadDescripcion) {
		this.tipoTitularidadDescripcion = tipoTitularidadDescripcion;
	}
	public String getEstadoAutorizaTransmision() {
		return estadoAutorizaTransmision;
	}
	public void setEstadoAutorizaTransmision(String estadoAutorizaTransmision) {
		this.estadoAutorizaTransmision = estadoAutorizaTransmision;
	}
	public String getEstadoAutorizaTransmisionDescripcion() {
		return estadoAutorizaTransmisionDescripcion;
	}
	public void setEstadoAutorizaTransmisionDescripcion(String estadoAutorizaTransmisionDescripcion) {
		this.estadoAutorizaTransmisionDescripcion = estadoAutorizaTransmisionDescripcion;
	}
	public String getAnotacionConcurso() {
		return anotacionConcurso;
	}
	public void setAnotacionConcurso(String anotacionConcurso) {
		this.anotacionConcurso = anotacionConcurso;
	}
	public String getAnotacionConcursoDescripcion() {
		return anotacionConcursoDescripcion;
	}
	public void setAnotacionConcursoDescripcion(String anotacionConcursoDescripcion) {
		this.anotacionConcursoDescripcion = anotacionConcursoDescripcion;
	}
	public String getEstadoGestionCa() {
		return estadoGestionCa;
	}
	public void setEstadoGestionCa(String estadoGestionCa) {
		this.estadoGestionCa = estadoGestionCa;
	}
	public String getEstadoGestionCaDescripcion() {
		return estadoGestionCaDescripcion;
	}
	public void setEstadoGestionCaDescripcion(String estadoGestionCaDescripcion) {
		this.estadoGestionCaDescripcion = estadoGestionCaDescripcion;
	}
	public String getConsFisica() {
		return consFisica;
	}
	public void setConsFisica(String consFisica) {
		this.consFisica = consFisica;
	}
	public String getConsJuridica() {
		return consJuridica;
	}
	public void setConsJuridica(String consJuridica) {
		this.consJuridica = consJuridica;
	}
	public String getEstadoAfoActaFinObra() {
		return estadoAfoActaFinObra;
	}
	public void setEstadoAfoActaFinObra(String estadoAfoActaFinObra) {
		this.estadoAfoActaFinObra = estadoAfoActaFinObra;
	}
	public String getEstadoAfoActaFinObraDescripcion() {
		return estadoAfoActaFinObraDescripcion;
	}
	public void setEstadoAfoActaFinObraDescripcion(String estadoAfoActaFinObraDescripcion) {
		this.estadoAfoActaFinObraDescripcion = estadoAfoActaFinObraDescripcion;
	}
	public String getLicenciaPrimeraOcupacion() {
		return licenciaPrimeraOcupacion;
	}
	public void setLicenciaPrimeraOcupacion(String licenciaPrimeraOcupacion) {
		this.licenciaPrimeraOcupacion = licenciaPrimeraOcupacion;
	}
	public String getLicenciaPrimeraOcupacionDescripcion() {
		return licenciaPrimeraOcupacionDescripcion;
	}
	public void setLicenciaPrimeraOcupacionDescripcion(String licenciaPrimeraOcupacionDescripcion) {
		this.licenciaPrimeraOcupacionDescripcion = licenciaPrimeraOcupacionDescripcion;
	}
	public String getBoletines() {
		return boletines;
	}
	public void setBoletines(String boletines) {
		this.boletines = boletines;
	}
	public String getBoletinesDescripcion() {
		return boletinesDescripcion;
	}
	public void setBoletinesDescripcion(String boletinesDescripcion) {
		this.boletinesDescripcion = boletinesDescripcion;
	}
	public String getSeguroDecenal() {
		return seguroDecenal;
	}
	public void setSeguroDecenal(String seguroDecenal) {
		this.seguroDecenal = seguroDecenal;
	}
	public String getSeguroDecenalDescripcion() {
		return seguroDecenalDescripcion;
	}
	public void setSeguroDecenalDescripcion(String seguroDecenalDescripcion) {
		this.seguroDecenalDescripcion = seguroDecenalDescripcion;
	}
	public String getTipoArrendamiento() {
		return tipoArrendamiento;
	}
	public void setTipoArrendamiento(String tipoArrendamiento) {
		this.tipoArrendamiento = tipoArrendamiento;
	}
	public String getTipoArrendamientoDescripcion() {
		return tipoArrendamientoDescripcion;
	}
	public void setTipoArrendamientoDescripcion(String tipoArrendamientoDescripcion) {
		this.tipoArrendamientoDescripcion = tipoArrendamientoDescripcion;
	}
	public String getNotificarArrendatarios() {
		return notificarArrendatarios;
	}
	public void setNotificarArrendatarios(String notificarArrendatarios) {
		this.notificarArrendatarios = notificarArrendatarios;
	}
	public String getTipoExpediente() {
		return tipoExpediente;
	}
	public void setTipoExpediente(String tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}
	public String getTipoExpedienteDescripcion() {
		return tipoExpedienteDescripcion;
	}
	public void setTipoExpedienteDescripcion(String tipoExpedienteDescripcion) {
		this.tipoExpedienteDescripcion = tipoExpedienteDescripcion;
	}
	public String getEstadoGestionEa() {
		return estadoGestionEa;
	}
	public void setEstadoGestionEa(String estadoGestionEa) {
		this.estadoGestionEa = estadoGestionEa;
	}
	public String getEstadoGestionEaDescripcion() {
		return estadoGestionEaDescripcion;
	}
	public void setEstadoGestionEaDescripcion(String estadoGestionEaDescripcion) {
		this.estadoGestionEaDescripcion = estadoGestionEaDescripcion;
	}
	public String getTipoIncidenciaRegistral() {
		return tipoIncidenciaRegistral;
	}
	public void setTipoIncidenciaRegistral(String tipoIncidenciaRegistral) {
		this.tipoIncidenciaRegistral = tipoIncidenciaRegistral;
	}
	public String getTipoIncidenciaRegistralDescripcion() {
		return tipoIncidenciaRegistralDescripcion;
	}
	public void setTipoIncidenciaRegistralDescripcion(String tipoIncidenciaRegistralDescripcion) {
		this.tipoIncidenciaRegistralDescripcion = tipoIncidenciaRegistralDescripcion;
	}
	public String getEstadoGestionCr() {
		return estadoGestionCr;
	}
	public void setEstadoGestionCr(String estadoGestionCr) {
		this.estadoGestionCr = estadoGestionCr;
	}
	public String getEstadoGestionCrDescripcion() {
		return estadoGestionCrDescripcion;
	}
	public void setEstadoGestionCrDescripcion(String estadoGestionCrDescripcion) {
		this.estadoGestionCrDescripcion = estadoGestionCrDescripcion;
	}
	public String getTipoOcupacionLegal() {
		return tipoOcupacionLegal;
	}
	public void setTipoOcupacionLegal(String tipoOcupacionLegal) {
		this.tipoOcupacionLegal = tipoOcupacionLegal;
	}
	public String getTipoOcupacionLegalDescripcion() {
		return tipoOcupacionLegalDescripcion;
	}
	public void setTipoOcupacionLegalDescripcion(String tipoOcupacionLegalDescripcion) {
		this.tipoOcupacionLegalDescripcion = tipoOcupacionLegalDescripcion;
	}
	public String getEstadoGestionIl() {
		return estadoGestionIl;
	}
	public void setEstadoGestionIl(String estadoGestionIl) {
		this.estadoGestionIl = estadoGestionIl;
	}
	public String getEstadoGestionIlDescripcion() {
		return estadoGestionIlDescripcion;
	}
	public void setEstadoGestionIlDescripcion(String estadoGestionIlDescripcion) {
		this.estadoGestionIlDescripcion = estadoGestionIlDescripcion;
	}
	public String getEstadoGestionOt() {
		return estadoGestionOt;
	}
	public void setEstadoGestionOt(String estadoGestionOt) {
		this.estadoGestionOt = estadoGestionOt;
	}
	public String getEstadoGestionOtDescripcion() {
		return estadoGestionOtDescripcion;
	}
	public void setEstadoGestionOtDescripcion(String estadoGestionOtDescripcion) {
		this.estadoGestionOtDescripcion = estadoGestionOtDescripcion;
	}
	public Date getFechaRevisionTitulo() {
		return fechaRevisionTitulo;
	}
	public void setFechaRevisionTitulo(Date fechaRevisionTitulo) {
		this.fechaRevisionTitulo = fechaRevisionTitulo;
	}
	public Double getPorcentajePropiedad() {
		return porcentajePropiedad;
	}
	public void setPorcentajePropiedad(Double porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Double getPorcentajeConsTasacionCf() {
		return porcentajeConsTasacionCf;
	}
	public void setPorcentajeConsTasacionCf(Double porcentajeConsTasacionCf) {
		this.porcentajeConsTasacionCf = porcentajeConsTasacionCf;
	}
	public Double getPorcentajeConsTasacionCj() {
		return porcentajeConsTasacionCj;
	}
	public void setPorcentajeConsTasacionCj(Double porcentajeConsTasacionCj) {
		this.porcentajeConsTasacionCj = porcentajeConsTasacionCj;
	}
	public Date getFechaContratoAlquiler() {
		return fechaContratoAlquiler;
	}
	public void setFechaContratoAlquiler(Date fechaContratoAlquiler) {
		this.fechaContratoAlquiler = fechaContratoAlquiler;
	}
	public String getLegislacionAplicableAlquiler() {
		return legislacionAplicableAlquiler;
	}
	public void setLegislacionAplicableAlquiler(String legislacionAplicableAlquiler) {
		this.legislacionAplicableAlquiler = legislacionAplicableAlquiler;
	}
	public String getDuracionContratoAlquiler() {
		return duracionContratoAlquiler;
	}
	public void setDuracionContratoAlquiler(String duracionContratoAlquiler) {
		this.duracionContratoAlquiler = duracionContratoAlquiler;
	}
	public String getTipoIncidenciaIloc() {
		return tipoIncidenciaIloc;
	}
	public void setTipoIncidenciaIloc(String tipoIncidenciaIloc) {
		this.tipoIncidenciaIloc = tipoIncidenciaIloc;
	}
	public String getDeterioroGrave() {
		return deterioroGrave;
	}
	public void setDeterioroGrave(String deterioroGrave) {
		this.deterioroGrave = deterioroGrave;
	}
	public String getTipoIncidenciaOtros() {
		return tipoIncidenciaOtros;
	}
	public void setTipoIncidenciaOtros(String tipoIncidenciaOtros) {
		this.tipoIncidenciaOtros = tipoIncidenciaOtros;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public boolean isUpdate() {
		return update;
	}
	public void setUpdate(boolean update) {
		this.update = update;
	}
	public String getCedulaHabitabilidad() {
		return cedulaHabitabilidad;
	}
	public void setCedulaHabitabilidad(String cedulaHabitabilidad) {
		this.cedulaHabitabilidad = cedulaHabitabilidad;
	}
	public String getCedulaHabitabilidadDescripcion() {
		return cedulaHabitabilidadDescripcion;
	}
	public void setCedulaHabitabilidadDescripcion(String cedulaHabitabilidadDescripcion) {
		this.cedulaHabitabilidadDescripcion = cedulaHabitabilidadDescripcion;
	}
	public String getEstadoCertificadoFinObra() {
		return estadoCertificadoFinObra;
	}
	public void setEstadoCertificadoFinObra(String estadoCertificadoFinObra) {
		this.estadoCertificadoFinObra = estadoCertificadoFinObra;
	}
	public String getEstadoCertificadoFinObraDescripcion() {
		return estadoCertificadoFinObraDescripcion;
	}
	public void setEstadoCertificadoFinObraDescripcion(String estadoCertificadoFinObraDescripcion) {
		this.estadoCertificadoFinObraDescripcion = estadoCertificadoFinObraDescripcion;
	}
	public String getTipoTituloCodigo() {
		return tipoTituloCodigo;
	}
	public void setTipoTituloCodigo(String tipoTituloCodigo) {
		this.tipoTituloCodigo = tipoTituloCodigo;
	}
	public String getTipoTituloDescripcion() {
		return tipoTituloDescripcion;
	}
	public void setTipoTituloDescripcion(String tipoTituloDescripcion) {
		this.tipoTituloDescripcion = tipoTituloDescripcion;
	}
	public String getSubtipoTituloCodigo() {
		return subtipoTituloCodigo;
	}
	public void setSubtipoTituloCodigo(String subtipoTituloCodigo) {
		this.subtipoTituloCodigo = subtipoTituloCodigo;
	}
	public String getSubtipoTituloDescripcion() {
		return subtipoTituloDescripcion;
	}
	public void setSubtipoTituloDescripcion(String subtipoTituloDescripcion) {
		this.subtipoTituloDescripcion = subtipoTituloDescripcion;
	}
	public String getSituacionConstructivaRegistral() {
		return situacionConstructivaRegistral;
	}
	public void setSituacionConstructivaRegistral(String situacionConstructivaRegistral) {
		this.situacionConstructivaRegistral = situacionConstructivaRegistral;
	}
	public String getSituacionConstructivaRegistralDescripcion() {
		return situacionConstructivaRegistralDescripcion;
	}
	public void setSituacionConstructivaRegistralDescripcion(String situacionConstructivaRegistralDescripcion) {
		this.situacionConstructivaRegistralDescripcion = situacionConstructivaRegistralDescripcion;
	}
	public String getProteccionOficial() {
		return proteccionOficial;
	}
	public void setProteccionOficial(String proteccionOficial) {
		this.proteccionOficial = proteccionOficial;
	}
	public String getProteccionOficialDescripcion() {
		return proteccionOficialDescripcion;
	}
	public void setProteccionOficialDescripcion(String proteccionOficialDescripcion) {
		this.proteccionOficialDescripcion = proteccionOficialDescripcion;
	}
	public String getTipoIncidencia() {
		return tipoIncidencia;
	}
	public void setTipoIncidencia(String tipoIncidencia) {
		this.tipoIncidencia = tipoIncidencia;
	}
	public String getTipoTituloActivo() {
		return tipoTituloActivo;
	}
	public void setTipoTituloActivo(String tipoTituloActivo) {
		this.tipoTituloActivo = tipoTituloActivo;
	}
	public String getSubtipoTituloActivo() {
		return subtipoTituloActivo;
	}
	public void setSubtipoTituloActivo(String subtipoTituloActivo) {
		this.subtipoTituloActivo = subtipoTituloActivo;
	}
	public String getSubtipoTituloActivoRef() {
		return subtipoTituloActivoRef;
	}
	public void setSubtipoTituloActivoRef(String subtipoTituloActivoRef) {
		this.subtipoTituloActivoRef = subtipoTituloActivoRef;
	}
	public String getTipoTituloActivoRef() {
		return tipoTituloActivoRef;
	}
	public void setTipoTituloActivoRef(String tipoTituloActivoRef) {
		this.tipoTituloActivoRef = tipoTituloActivoRef;
	}
	
}