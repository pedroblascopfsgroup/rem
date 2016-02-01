//package es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.model;
//
//import java.io.Serializable;
//import java.util.Date;
//
//import javax.persistence.Column;
//import javax.persistence.Embedded;
//import javax.persistence.Entity;
//import javax.persistence.FetchType;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.JoinColumn;
//import javax.persistence.ManyToOne;
//import javax.persistence.SequenceGenerator;
//import javax.persistence.Table;
//import javax.persistence.Version;
//
//import org.hibernate.annotations.Cache;
//import org.hibernate.annotations.CacheConcurrencyStrategy;
//
//import es.capgemini.pfs.auditoria.Auditable;
//import es.capgemini.pfs.auditoria.model.Auditoria;
//import es.capgemini.pfs.contrato.model.Contrato;
//import es.capgemini.pfs.persona.model.DDTipoPersona;
//import es.capgemini.pfs.persona.model.Persona;
//import es.capgemini.pfs.users.domain.Usuario;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter.model.SIDHIHitoIterInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIAccionJudicial;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIIterJudicial;
//
//@Entity
//@Table(name = "SIDHI_DAT_HIT_HITO", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//public class SIDHIHitoIter implements SIDHIHitoIterInfo, Serializable, Auditable{
//	
//	/**
//	 * 
//	 */
//	private static final long serialVersionUID = 8035821347084401461L;
//
//	@Id
//	@Column(name = "HIT_ID")
//	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIHitoIterGenerator")
//	@SequenceGenerator(name = "SIDHIHitoIterGenerator", sequenceName = "S_SIDHI_DAT_HIT_HITO")
//	private Long id;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "ACJ_ID")
//	private SIDHIAccionJudicial accion;
//	
////	@ManyToOne(fetch = FetchType.EAGER)
////	@JoinColumn(name = "NPR_ID")
////	private SIDHIAccionNoProc accionNoProc; 
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "ITE_ID")
//	private SIDHIIterJudicial iterJudicial;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "CNT_ID")
//	private Contrato contrato;
//	
//	@Column(name="HIT_FECHA_EXTRACCION")
//	private Date fechaExtraccion;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TPE_ID")
//	private DDTipoPersona tipoPersona;
//	
//	@Column(name="HIT_CODPERSONA")
//	private String codigoPersona;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "PER_ID")
//	private Persona persona;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_THE_ID")
//	private SIDHIDDTipoHitoIter tipoHitoIter;
//	
//	@Column(name="HIT_FECHA_INICIO")
//	private Date fechaInicio;
//	
//	@Column(name="HIT_FECHA_CUMPL")
//	private Date fechaCumplimiento;
//	
//	@Column(name="HIT_HITO")
//	private Long idHito;
//	
//	@Column(name="HIT_ACCION")
//	private Long idAccion;
//	
//	@Column(name="HIT_OBSERVACIONES")
//	private String observaciones;
//	
//	@Column(name="HIT_GESTOR")
//	private String gestor;
//	
//	@Column(name="HIT_GESTOR_CUMPLIMIENTO")
//	private String gestorCumplimiento;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "USU_ID_CUMPLIMIENTO")
//	private Usuario usuarioCumplimiento;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "USU_ID")
//	private Usuario usuario;
//	
//	@Embedded
//	private Auditoria auditoria;
//
//	@Version
//	private Integer version;
//
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public Long getId() {
//		return id;
//	}
//
//	public SIDHIAccionJudicial getAccion() {
//		return accion;
//	}
//
//	public void setAccion(SIDHIAccionJudicial accion) {
//		this.accion = accion;
//	}
//
////	public SIDHIAccionNoProc getAccionNoProc() {
////		return accionNoProc;
////	}
////
////	public void setAccionNoProc(SIDHIAccionNoProc accionNoProc) {
////		this.accionNoProc = accionNoProc;
////	}
//
//	public SIDHIIterJudicial getIterJudicial() {
//		return iterJudicial;
//	}
//
//	public void setIterJudicial(SIDHIIterJudicial iterJudicial) {
//		this.iterJudicial = iterJudicial;
//	}
//
//	public Contrato getContrato() {
//		return contrato;
//	}
//
//	public void setContrato(Contrato contrato) {
//		this.contrato = contrato;
//	}
//
//	public Date getFechaExtraccion() {
//		return fechaExtraccion;
//	}
//
//	public void setFechaExtraccion(Date fechaExtraccion) {
//		this.fechaExtraccion = fechaExtraccion;
//	}
//
//	public DDTipoPersona getTipoPersona() {
//		return tipoPersona;
//	}
//
//	public void setTipoPersona(DDTipoPersona tipoPersona) {
//		this.tipoPersona = tipoPersona;
//	}
//
//	public String getCodigoPersona() {
//		return codigoPersona;
//	}
//
//	public void setCodigoPersona(String codigoPersona) {
//		this.codigoPersona = codigoPersona;
//	}
//
//	public Persona getPersona() {
//		return persona;
//	}
//
//	public void setPersona(Persona persona) {
//		this.persona = persona;
//	}
//
//	public SIDHIDDTipoHitoIter getTipoHitoIter() {
//		return tipoHitoIter;
//	}
//
//	public void setTipoHitoIter(SIDHIDDTipoHitoIter tipoHitoIter) {
//		this.tipoHitoIter = tipoHitoIter;
//	}
//
//	public Date getFechaInicio() {
//		return fechaInicio;
//	}
//
//	public void setFechaInicio(Date fechaInicio) {
//		this.fechaInicio = fechaInicio;
//	}
//
//	public Date getFechaCumplimiento() {
//		return fechaCumplimiento;
//	}
//
//	public void setFechaCumplimiento(Date fechaCumplimiento) {
//		this.fechaCumplimiento = fechaCumplimiento;
//	}
//
//	public Long getIdHito() {
//		return idHito;
//	}
//
//	public void setIdHito(Long idHito) {
//		this.idHito = idHito;
//	}
//
//	public Long getIdAccion() {
//		return idAccion;
//	}
//
//	public void setIdAccion(Long idAccion) {
//		this.idAccion = idAccion;
//	}
//
//	public String getObservaciones() {
//		return observaciones;
//	}
//
//	public void setObservaciones(String observaciones) {
//		this.observaciones = observaciones;
//	}
//
//	public String getGestor() {
//		return gestor;
//	}
//
//	public void setGestor(String gestor) {
//		this.gestor = gestor;
//	}
//
//	public String getGestorCumplimiento() {
//		return gestorCumplimiento;
//	}
//
//	public void setGestorCumplimiento(String gestorCumplimiento) {
//		this.gestorCumplimiento = gestorCumplimiento;
//	}
//
//	public Usuario getUsuarioCumplimiento() {
//		return usuarioCumplimiento;
//	}
//
//	public void setUsuarioCumplimiento(Usuario usuarioCumplimiento) {
//		this.usuarioCumplimiento = usuarioCumplimiento;
//	}
//
//	public Usuario getUsuario() {
//		return usuario;
//	}
//
//	public void setUsuario(Usuario usuario) {
//		this.usuario = usuario;
//	}
//
//	public Auditoria getAuditoria() {
//		return auditoria;
//	}
//
//	public void setAuditoria(Auditoria auditoria) {
//		this.auditoria = auditoria;
//	}
//
//	public Integer getVersion() {
//		return version;
//	}
//
//	public void setVersion(Integer version) {
//		this.version = version;
//	}
//	
//	
//
//}
