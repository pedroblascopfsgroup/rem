package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un activo-gasto.
 *  
 * @author Gabriel De Toni
 *
 */
public class DtoAdmisionRevisionTitulo extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long id;
	private Long idActivo;
	private String revisadoCodigo;
	private String revisadoDescripcion;
	private Date fechaRevisado;
	private Long ratificacion;
	private String instLibArrendatariaCodigo;
	private String instLibArrendatariaDescripcion;
	private String sitIniInscripcionCodigo;
	private String sitIniInscripcionDescripcion;
	private String posesoriaIniCodigo;
	private String posesoriaIniDescripcion;
	private String sitIniCargasCodigo;
	private String sitIniCargasDescripcion;
	private Double porcPropiedad;
	private String tipoTitularidadCodigo;
	private String tipoTitularidadDescripcion;
	private String observaciones;
	private String autorizTransmisionCodigo;
	private String autorizTransmisionDescripcion;
	private String anotacionConcursoCodigo;
	private String anotacionConcursoDescripcion;
	private String estadoGestionCaCodigo;
	private String estadoGestionCaDescripcion;
	private String consFisicaCodigo;
	private String consFisicaDescripcion;
	private Double porcConsTasacionCf;
	private String consJuridicaCodigo;
	private String consJuridicaDescripcion;
	private Double porcConsTasacionCj;
	private String certificadoFinObraCodigo;
	private String certificadoFinObraDescripcion;
	private String afoActaFinObraCodigo;
	private String afoActaFinObraDescripcion;
	private String licPrimeraOcupacionCodigo;
	private String licPrimeraOcupacionDescripcion;
	private String boletinesCodigo;
	private String boletinesDescripcion;
	private String seguroDecenalCodigo;
	private String seguroDecenalDescripcion;
	private String cedulaHabitabilidadCodigo;
	private String cedulaHabitabilidadDescripcion;
	private Date fechaContratoAlq;
	private String legislacionAplicableAlq;
	private String duracionContratoAlq;
	private String tipoArrendamientoCodigo;
	private String tipoArrendamientoDescripcion;
	private String notifArrendatariosCodigo;
	private String notifArrendatariosDescripcion;
	private String tipoExpAdmCodigo;
	private String tipoExpAdmDescripcion;
	private String estadoGestionEaCodigo;
	private String estadoGestionEaDescripcion;
	private String tipoInicioRegistralCodigo;
	private String tipoInicioRegistralDescripcion;
	private String estadoGestionCrCodigo;
	private String estadoGestionCrDescripcion;
	private String tipoOcupacionLegalCodigo;
	private String tipoOcupacionLegalDescripcion;
	private String tipoInciIloc;
	private String estadoGestionIlCodigo;
	private String estadoGestionIlDescripcion;
	private String deterioroGrave;
	private String tipoInciOtros;
	private String estadoGestionOtCodigo;
	private String estadoGestionOtDescripcion;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getRevisadoCodigo() {
		return revisadoCodigo;
	}
	public void setRevisadoCodigo(String revisadoCodigo) {
		this.revisadoCodigo = revisadoCodigo;
	}
	public String getRevisadoDescripcion() {
		return revisadoDescripcion;
	}
	public void setRevisadoDescripcion(String revisadoDescripcion) {
		this.revisadoDescripcion = revisadoDescripcion;
	}
	public Date getFechaRevisado() {
		return fechaRevisado;
	}
	public void setFechaRevisado(Date fechaRevisado) {
		this.fechaRevisado = fechaRevisado;
	}
	public Long getRatificacion() {
		return ratificacion;
	}
	public void setRatificacion(Long ratificacion) {
		this.ratificacion = ratificacion;
	}
	public String getInstLibArrendatariaCodigo() {
		return instLibArrendatariaCodigo;
	}
	public void setInstLibArrendatariaCodigo(String instLibArrendatariaCodigo) {
		this.instLibArrendatariaCodigo = instLibArrendatariaCodigo;
	}
	public String getInstLibArrendatariaDescripcion() {
		return instLibArrendatariaDescripcion;
	}
	public void setInstLibArrendatariaDescripcion(String instLibArrendatariaDescripcion) {
		this.instLibArrendatariaDescripcion = instLibArrendatariaDescripcion;
	}
	public String getSitIniInscripcionCodigo() {
		return sitIniInscripcionCodigo;
	}
	public void setSitIniInscripcionCodigo(String sitIniInscripcionCodigo) {
		this.sitIniInscripcionCodigo = sitIniInscripcionCodigo;
	}
	public String getSitIniInscripcionDescripcion() {
		return sitIniInscripcionDescripcion;
	}
	public void setSitIniInscripcionDescripcion(String sitIniInscripcionDescripcion) {
		this.sitIniInscripcionDescripcion = sitIniInscripcionDescripcion;
	}
	public String getPosesoriaIniCodigo() {
		return posesoriaIniCodigo;
	}
	public void setPosesoriaIniCodigo(String posesoriaIniCodigo) {
		this.posesoriaIniCodigo = posesoriaIniCodigo;
	}
	public String getPosesoriaIniDescripcion() {
		return posesoriaIniDescripcion;
	}
	public void setPosesoriaIniDescripcion(String posesoriaIniDescripcion) {
		this.posesoriaIniDescripcion = posesoriaIniDescripcion;
	}
	public String getSitIniCargasCodigo() {
		return sitIniCargasCodigo;
	}
	public void setSitIniCargasCodigo(String sitIniCargasCodigo) {
		this.sitIniCargasCodigo = sitIniCargasCodigo;
	}
	public String getSitIniCargasDescripcion() {
		return sitIniCargasDescripcion;
	}
	public void setSitIniCargasDescripcion(String sitIniCargasDescripcion) {
		this.sitIniCargasDescripcion = sitIniCargasDescripcion;
	}
	public Double getPorcPropiedad() {
		return porcPropiedad;
	}
	public void setPorcPropiedad(Double porcPropiedad) {
		this.porcPropiedad = porcPropiedad;
	}
	public String getTipoTitularidadCodigo() {
		return tipoTitularidadCodigo;
	}
	public void setTipoTitularidadCodigo(String tipoTitularidadCodigo) {
		this.tipoTitularidadCodigo = tipoTitularidadCodigo;
	}
	public String getTipoTitularidadDescripcion() {
		return tipoTitularidadDescripcion;
	}
	public void setTipoTitularidadDescripcion(String tipoTitularidadDescripcion) {
		this.tipoTitularidadDescripcion = tipoTitularidadDescripcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getAutorizTransmisionCodigo() {
		return autorizTransmisionCodigo;
	}
	public void setAutorizTransmisionCodigo(String autorizTransmisionCodigo) {
		this.autorizTransmisionCodigo = autorizTransmisionCodigo;
	}
	public String getAutorizTransmisionDescripcion() {
		return autorizTransmisionDescripcion;
	}
	public void setAutorizTransmisionDescripcion(String autorizTransmisionDescripcion) {
		this.autorizTransmisionDescripcion = autorizTransmisionDescripcion;
	}
	public String getAnotacionConcursoCodigo() {
		return anotacionConcursoCodigo;
	}
	public void setAnotacionConcursoCodigo(String anotacionConcursoCodigo) {
		this.anotacionConcursoCodigo = anotacionConcursoCodigo;
	}
	public String getAnotacionConcursoDescripcion() {
		return anotacionConcursoDescripcion;
	}
	public void setAnotacionConcursoDescripcion(String anotacionConcursoDescripcion) {
		this.anotacionConcursoDescripcion = anotacionConcursoDescripcion;
	}
	public String getEstadoGestionCaCodigo() {
		return estadoGestionCaCodigo;
	}
	public void setEstadoGestionCaCodigo(String estadoGestionCaCodigo) {
		this.estadoGestionCaCodigo = estadoGestionCaCodigo;
	}
	public String getEstadoGestionCaDescripcion() {
		return estadoGestionCaDescripcion;
	}
	public void setEstadoGestionCaDescripcion(String estadoGestionCaDescripcion) {
		this.estadoGestionCaDescripcion = estadoGestionCaDescripcion;
	}
	public String getConsFisicaCodigo() {
		return consFisicaCodigo;
	}
	public void setConsFisicaCodigo(String consFisicaCodigo) {
		this.consFisicaCodigo = consFisicaCodigo;
	}
	public String getConsFisicaDescripcion() {
		return consFisicaDescripcion;
	}
	public void setConsFisicaDescripcion(String consFisicaDescripcion) {
		this.consFisicaDescripcion = consFisicaDescripcion;
	}
	public Double getPorcConsTasacionCf() {
		return porcConsTasacionCf;
	}
	public void setPorcConsTasacionCf(Double porcConsTasacionCf) {
		this.porcConsTasacionCf = porcConsTasacionCf;
	}
	public String getConsJuridicaCodigo() {
		return consJuridicaCodigo;
	}
	public void setConsJuridicaCodigo(String consJuridicaCodigo) {
		this.consJuridicaCodigo = consJuridicaCodigo;
	}
	public String getConsJuridicaDescripcion() {
		return consJuridicaDescripcion;
	}
	public void setConsJuridicaDescripcion(String consJuridicaDescripcion) {
		this.consJuridicaDescripcion = consJuridicaDescripcion;
	}
	public Double getPorcConsTasacionCj() {
		return porcConsTasacionCj;
	}
	public void setPorcConsTasacionCj(Double porcConsTasacionCj) {
		this.porcConsTasacionCj = porcConsTasacionCj;
	}
	public String getCertificadoFinObraCodigo() {
		return certificadoFinObraCodigo;
	}
	public void setCertificadoFinObraCodigo(String certificadoFinObraCodigo) {
		this.certificadoFinObraCodigo = certificadoFinObraCodigo;
	}
	public String getCertificadoFinObraDescripcion() {
		return certificadoFinObraDescripcion;
	}
	public void setCertificadoFinObraDescripcion(String certificadoFinObraDescripcion) {
		this.certificadoFinObraDescripcion = certificadoFinObraDescripcion;
	}
	public String getAfoActaFinObraCodigo() {
		return afoActaFinObraCodigo;
	}
	public void setAfoActaFinObraCodigo(String afoActaFinObraCodigo) {
		this.afoActaFinObraCodigo = afoActaFinObraCodigo;
	}
	public String getAfoActaFinObraDescripcion() {
		return afoActaFinObraDescripcion;
	}
	public void setAfoActaFinObraDescripcion(String afoActaFinObraDescripcion) {
		this.afoActaFinObraDescripcion = afoActaFinObraDescripcion;
	}
	public String getLicPrimeraOcupacionCodigo() {
		return licPrimeraOcupacionCodigo;
	}
	public void setLicPrimeraOcupacionCodigo(String licPrimeraOcupacionCodigo) {
		this.licPrimeraOcupacionCodigo = licPrimeraOcupacionCodigo;
	}
	public String getLicPrimeraOcupacionDescripcion() {
		return licPrimeraOcupacionDescripcion;
	}
	public void setLicPrimeraOcupacionDescripcion(String licPrimeraOcupacionDescripcion) {
		this.licPrimeraOcupacionDescripcion = licPrimeraOcupacionDescripcion;
	}
	public String getBoletinesCodigo() {
		return boletinesCodigo;
	}
	public void setBoletinesCodigo(String boletinesCodigo) {
		this.boletinesCodigo = boletinesCodigo;
	}
	public String getBoletinesDescripcion() {
		return boletinesDescripcion;
	}
	public void setBoletinesDescripcion(String boletinesDescripcion) {
		this.boletinesDescripcion = boletinesDescripcion;
	}
	public String getSeguroDecenalCodigo() {
		return seguroDecenalCodigo;
	}
	public void setSeguroDecenalCodigo(String seguroDecenalCodigo) {
		this.seguroDecenalCodigo = seguroDecenalCodigo;
	}
	public String getSeguroDecenalDescripcion() {
		return seguroDecenalDescripcion;
	}
	public void setSeguroDecenalDescripcion(String seguroDecenalDescripcion) {
		this.seguroDecenalDescripcion = seguroDecenalDescripcion;
	}
	public String getCedulaHabitabilidadCodigo() {
		return cedulaHabitabilidadCodigo;
	}
	public void setCedulaHabitabilidadCodigo(String cedulaHabitabilidadCodigo) {
		this.cedulaHabitabilidadCodigo = cedulaHabitabilidadCodigo;
	}
	public String getCedulaHabitabilidadDescripcion() {
		return cedulaHabitabilidadDescripcion;
	}
	public void setCedulaHabitabilidadDescripcion(String cedulaHabitabilidadDescripcion) {
		this.cedulaHabitabilidadDescripcion = cedulaHabitabilidadDescripcion;
	}
	public Date getFechaContratoAlq() {
		return fechaContratoAlq;
	}
	public void setFechaContratoAlq(Date fechaContratoAlq) {
		this.fechaContratoAlq = fechaContratoAlq;
	}
	public String getLegislacionAplicableAlq() {
		return legislacionAplicableAlq;
	}
	public void setLegislacionAplicableAlq(String legislacionAplicableAlq) {
		this.legislacionAplicableAlq = legislacionAplicableAlq;
	}
	public String getDuracionContratoAlq() {
		return duracionContratoAlq;
	}
	public void setDuracionContratoAlq(String duracionContratoAlq) {
		this.duracionContratoAlq = duracionContratoAlq;
	}
	public String getTipoArrendamientoCodigo() {
		return tipoArrendamientoCodigo;
	}
	public void setTipoArrendamientoCodigo(String tipoArrendamientoCodigo) {
		this.tipoArrendamientoCodigo = tipoArrendamientoCodigo;
	}
	public String getTipoArrendamientoDescripcion() {
		return tipoArrendamientoDescripcion;
	}
	public void setTipoArrendamientoDescripcion(String tipoArrendamientoDescripcion) {
		this.tipoArrendamientoDescripcion = tipoArrendamientoDescripcion;
	}
	public String getNotifArrendatariosCodigo() {
		return notifArrendatariosCodigo;
	}
	public void setNotifArrendatariosCodigo(String notifArrendatariosCodigo) {
		this.notifArrendatariosCodigo = notifArrendatariosCodigo;
	}
	public String getNotifArrendatariosDescripcion() {
		return notifArrendatariosDescripcion;
	}
	public void setNotifArrendatariosDescripcion(String notifArrendatariosDescripcion) {
		this.notifArrendatariosDescripcion = notifArrendatariosDescripcion;
	}
	public String getTipoExpAdmCodigo() {
		return tipoExpAdmCodigo;
	}
	public void setTipoExpAdmCodigo(String tipoExpAdmCodigo) {
		this.tipoExpAdmCodigo = tipoExpAdmCodigo;
	}
	public String getTipoExpAdmDescripcion() {
		return tipoExpAdmDescripcion;
	}
	public void setTipoExpAdmDescripcion(String tipoExpAdmDescripcion) {
		this.tipoExpAdmDescripcion = tipoExpAdmDescripcion;
	}
	public String getEstadoGestionEaCodigo() {
		return estadoGestionEaCodigo;
	}
	public void setEstadoGestionEaCodigo(String estadoGestionEaCodigo) {
		this.estadoGestionEaCodigo = estadoGestionEaCodigo;
	}
	public String getEstadoGestionEaDescripcion() {
		return estadoGestionEaDescripcion;
	}
	public void setEstadoGestionEaDescripcion(String estadoGestionEaDescripcion) {
		this.estadoGestionEaDescripcion = estadoGestionEaDescripcion;
	}
	public String getTipoInicioRegistralCodigo() {
		return tipoInicioRegistralCodigo;
	}
	public void setTipoInicioRegistralCodigo(String tipoInicioRegistralCodigo) {
		this.tipoInicioRegistralCodigo = tipoInicioRegistralCodigo;
	}
	public String getTipoInicioRegistralDescripcion() {
		return tipoInicioRegistralDescripcion;
	}
	public void setTipoInicioRegistralDescripcion(String tipoInicioRegistralDescripcion) {
		this.tipoInicioRegistralDescripcion = tipoInicioRegistralDescripcion;
	}
	public String getEstadoGestionCrCodigo() {
		return estadoGestionCrCodigo;
	}
	public void setEstadoGestionCrCodigo(String estadoGestionCrCodigo) {
		this.estadoGestionCrCodigo = estadoGestionCrCodigo;
	}
	public String getEstadoGestionCrDescripcion() {
		return estadoGestionCrDescripcion;
	}
	public void setEstadoGestionCrDescripcion(String estadoGestionCrDescripcion) {
		this.estadoGestionCrDescripcion = estadoGestionCrDescripcion;
	}
	public String getTipoOcupacionLegalCodigo() {
		return tipoOcupacionLegalCodigo;
	}
	public void setTipoOcupacionLegalCodigo(String tipoOcupacionLegalCodigo) {
		this.tipoOcupacionLegalCodigo = tipoOcupacionLegalCodigo;
	}
	public String getTipoOcupacionLegalDescripcion() {
		return tipoOcupacionLegalDescripcion;
	}
	public void setTipoOcupacionLegalDescripcion(String tipoOcupacionLegalDescripcion) {
		this.tipoOcupacionLegalDescripcion = tipoOcupacionLegalDescripcion;
	}
	public String getTipoInciIloc() {
		return tipoInciIloc;
	}
	public void setTipoInciIloc(String tipoInciIloc) {
		this.tipoInciIloc = tipoInciIloc;
	}
	public String getEstadoGestionIlCodigo() {
		return estadoGestionIlCodigo;
	}
	public void setEstadoGestionIlCodigo(String estadoGestionIlCodigo) {
		this.estadoGestionIlCodigo = estadoGestionIlCodigo;
	}
	public String getEstadoGestionIlDescripcion() {
		return estadoGestionIlDescripcion;
	}
	public void setEstadoGestionIlDescripcion(String estadoGestionIlDescripcion) {
		this.estadoGestionIlDescripcion = estadoGestionIlDescripcion;
	}
	public String getDeterioroGrave() {
		return deterioroGrave;
	}
	public void setDeterioroGrave(String deterioroGrave) {
		this.deterioroGrave = deterioroGrave;
	}
	public String getTipoInciOtros() {
		return tipoInciOtros;
	}
	public void setTipoInciOtros(String tipoInciOtros) {
		this.tipoInciOtros = tipoInciOtros;
	}
	public String getEstadoGestionOtCodigo() {
		return estadoGestionOtCodigo;
	}
	public void setEstadoGestionOtCodigo(String estadoGestionOtCodigo) {
		this.estadoGestionOtCodigo = estadoGestionOtCodigo;
	}
	public String getEstadoGestionOtDescripcion() {
		return estadoGestionOtDescripcion;
	}
	public void setEstadoGestionOtDescripcion(String estadoGestionOtDescripcion) {
		this.estadoGestionOtDescripcion = estadoGestionOtDescripcion;
	}
	
}
