//package es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.model;
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
//import es.capgemini.pfs.persona.model.DDTipoTelefono;
//import es.capgemini.pfs.persona.model.Persona;
//import es.capgemini.pfs.users.domain.Usuario;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIAccionNoProcInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDSubTipoAccionNoProcInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDSubTipoResultadoInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDTipoAccionNoProcInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDTipoResultadoInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIEstadoProcesal;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIIterJudicial;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHISubestadoProcesal;
//
//@Entity
//@Table(name = "SIDHI_DAT_NPR_NOPROC", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//public class SIDHIAccionNoProc implements SIDHIAccionNoProcInfo, Serializable, Auditable {
//	
//	/**
//	 * 
//	 */
//	private static final long serialVersionUID = -9208274845272221214L;
//	
//	@Id
//	@Column(name = "NPR_ID")
//	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIAccionNoProcGenerator")
//	@SequenceGenerator(name = "SIDHIAccionNoProcGenerator", sequenceName = "S_SIDHI_DAT_NPR_NOPROC")
//	private Long id;
//	
//	@Column(name="NPR_ACCION")
//	private Long idAccion;
//	
//	@Column(name="NPR_GESTOR")
//	private String gestor;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "USU_ID")
//	private Usuario usuario;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TPE_ID")
//	private DDTipoPersona tipoPersona;
//	
//	@Column(name="NPR_CODPERSONA")
//	private String codigoPersona;
//	
//	@ManyToOne(fetch=FetchType.EAGER)
//	@JoinColumn(name="PER_ID")
//	private Persona persona;
//	
//	@ManyToOne(fetch=FetchType.EAGER)
//	@JoinColumn(name="DD_TTF_ID")
//	private DDTipoTelefono tipoTelefono;
//	
//	@Column(name="NPR_TELEFONO")
//	private String numeroTelefono;
//	
//	@Column(name="NPR_OBSERVACIONES")
//	private String observaciones;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "ITE_ID")
//	private SIDHIIterJudicial iterJudicial;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "CNT_ID")
//	private Contrato contrato;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "EPC_ID")
//	private SIDHIEstadoProcesal estadoProcesal;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "SEP_ID")
//	private SIDHISubestadoProcesal subEstadoProcesal;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_SIE_ID")
//	private SIDHIDDSubTipoAccionNoProc subtipoAccionNoProc;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TIE_ID")
//	private SIDHIDDTipoAccionNoProc tipoAccionNoProc;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_SRD_ID")
//	private SIDHIDDSubTipoResultado subTipoResultado;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TRD_ID")
//	private SIDHIDDTipoResultado tipoResultado;
//	
//	@Column(name="NPR_FECHAACCION")
//	private Date fechaAccion;
//	
//	@Column(name="NPR_FECHA_EXTRACCION")
//	private Date fechaExtraccion;
//	
//	@Embedded
//	private Auditoria auditoria;
//
//	@Version
//	private Integer version;
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public Long getId() {
//		return id;
//	}
//
//	@Override
//	public String getCodigoPersona() {
//		return codigoPersona;
//	}
//	
//	public void setCodigoPersona(String codigoPersona){
//		this.codigoPersona=codigoPersona;
//	}
//
//	@Override
//	public Contrato getContrato() {
//		return contrato;
//	}
//	
//	public void setContrato(Contrato contrato){
//		this.contrato=contrato;
//	}
//
//	@Override
//	public SIDHIEstadoProcesal getEstadoProcesal() {
//		return estadoProcesal;
//	}
//	
//	public void setEstadoProcesal(SIDHIEstadoProcesal estadoProcesal){
//		this.estadoProcesal=estadoProcesal;
//	}
//
//	@Override
//	public Date getFechaAccion() {
//		return fechaAccion;
//	}
//	
//	public void setFechaAccion(Date fechaAccion){
//		this.fechaAccion=fechaAccion;
//	}
//	
//	@Override
//	public Date getFechaExtraccion() {
//		return fechaExtraccion;
//	}
//
//	@Override
//	public String getGestor() {
//		return gestor;
//	}
//
//	@Override
//	public Long getIdAccion() {
//		return idAccion;
//	}
//
//	@Override
//	public SIDHIIterJudicialInfo getIterJudicial() {
//		return iterJudicial;
//	}
//
//	@Override
//	public String getNumeroTelefono() {
//		return numeroTelefono;
//	}
//
//	@Override
//	public String getObservaciones() {
//		return observaciones;
//	}
//
//	@Override
//	public Persona getPersona() {
//		return persona;
//	}
//
//	@Override
//	public SIDHISubestadoProcesal getSubEstadoProcesal() {
//		return subEstadoProcesal;
//	}
//
//	@Override
//	public SIDHIDDSubTipoResultadoInfo getSubTipoResultado() {
//		return subTipoResultado;
//	}
//
//	@Override
//	public SIDHIDDSubTipoAccionNoProcInfo getSubtipoAccionNoProc() {
//		return subtipoAccionNoProc;
//	}
//
//	@Override
//	public SIDHIDDTipoAccionNoProcInfo getTipoAccionNoProc() {
//		return tipoAccionNoProc;
//	}
//
//	@Override
//	public DDTipoPersona getTipoPersona() {
//		return tipoPersona;
//	}
//
//	@Override
//	public SIDHIDDTipoResultadoInfo getTipoResultado() {
//		return tipoResultado;
//	}
//
//	@Override
//	public DDTipoTelefono getTipoTelefono() {
//		return tipoTelefono;
//	}
//
//	@Override
//	public Usuario getUsuario() {
//		return usuario;
//	}
//
//	@Override
//	public Auditoria getAuditoria() {
//		return auditoria;
//	}
//
//	@Override
//	public void setAuditoria(Auditoria auditoria) {
//		this.auditoria=auditoria;
//	}
//
//	public void setVersion(Integer version) {
//		this.version = version;
//	}
//
//	public Integer getVersion() {
//		return version;
//	}
//
//
//}
