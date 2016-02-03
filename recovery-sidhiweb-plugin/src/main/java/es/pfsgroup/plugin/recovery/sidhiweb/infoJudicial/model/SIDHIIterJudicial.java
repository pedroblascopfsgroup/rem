package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIAccionJudicialInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIIterJudicialInfo;

@Entity
@Table(name = "SIDHI_DAT_ITE_ITERES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIIterJudicial implements SIDHIIterJudicialInfo, Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7271379018223935774L;
	
	//private final Log logger = LogFactory.getLog(getClass());

	@Id
	@Column(name = "ITE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIProcedimientoJudicialGenerator")
	@SequenceGenerator(name = "SIDHIProcedimientoJudicialGenerator", sequenceName = "S_SIDHI_DAT_ITE_ITERES")
	private Long id;
	
	
	@OneToMany(mappedBy = "iter", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ite_id")
    @Where(clause = "borrado = 0")
	private List<SIDHIAccionJudicial> accionesJudiciales;
	
	@OneToOne
	@JoinColumn(name = "PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Procedimiento procedimiento;
	
	@Column(name="ITE_EXPEDIENTE_EXT")
	private String idExpedienteExterno;
	
	@OneToOne
	@JoinColumn(name = "USU_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Usuario procurador;
	
	@Column(name="ITE_PROCURADOR")
	private String usernameProcurador;
	
	@Column(name="ITE_PLAZA")
	private String plaza;
	
	@Column(name="ITE_JUZGADO")
	private String juzgado;
	
	@ManyToOne
    @JoinColumn(name = "DD_JUZ_ID")
	private TipoJuzgado tipoJuzgado;
	
	@Column(name="ITE_NUM_AUTOS")
	private String numeroAutos;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}


	@Override
	public List<? extends SIDHIAccionJudicialInfo> getAccionesJudiciales() {
		return accionesJudiciales;
	}
	
	public void setAccionesJudiciales( List<SIDHIAccionJudicial> accionesJudiciales){
		this.accionesJudiciales= accionesJudiciales;
	}

	@Override
	public String getIdExpedienteExterno() {
		return idExpedienteExterno;
	}
	
	public void setIdExpedienteExterno (String idExpedienteExterno){
		this.idExpedienteExterno=idExpedienteExterno;
	}
	

	@Override
	public Usuario getProcurador() {
		return procurador;
	}
	
	public void setProcurador(Usuario procurador){
		this.procurador=procurador;
	}

	@Override
	public String getUsernameProcurador() {
		return usernameProcurador;
	}
	
	public void setUsernameProcurador(String usernameProcurador){
		this.usernameProcurador=usernameProcurador;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setTipoJuzgado(TipoJuzgado tipoJuzgado) {
		this.tipoJuzgado = tipoJuzgado;
	}

	public TipoJuzgado getTipoJuzgado() {
		return tipoJuzgado;
	}

	public void setNumeroAutos(String numeroAutos) {
		this.numeroAutos = numeroAutos;
	}

	public String getNumeroAutos() {
		return numeroAutos;
	}

	
}
