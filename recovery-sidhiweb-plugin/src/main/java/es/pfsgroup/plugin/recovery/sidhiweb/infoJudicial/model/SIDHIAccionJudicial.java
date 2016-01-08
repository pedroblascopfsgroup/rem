package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIAccionJudicialInfo;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHITipoAccionValorInfo;

@Entity
@Table(name = "SIDHI_DAT_ACJ_ACCIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIAccionJudicial implements SIDHIAccionJudicialInfo,
Serializable, Auditable{
	
	@Transient
	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * 
	 */
	private static final long serialVersionUID = 3539018320186673468L;

	@Id
	@Column(name = "ACJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIAccionJudicialGenerator")
	@SequenceGenerator(name = "SIDHIAccionJudicialGenerator", sequenceName = "S_SIDHI_DAT_ACJ_ACCIONES")
	private Long id;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "EPC_ID")
	private SIDHIEstadoProcesal estadoProcesal;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SEP_ID")
	private SIDHISubestadoProcesal subestadoProcesal;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "DD_EAC_ID")
	private SIDHIDatEacEstadoAccion estadoAccion;

	@Column(name = "ACJ_COD_INTERFAZ")
	private String codigoInterfaz;

	@Column(name = "ACJ_PROCESADA")
	private Boolean procesada;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ITE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private SIDHIIterJudicial iter;

	@Column(name = "ACJ_FECHAACCION")
	private Date fechaAccion;

	@OneToMany(mappedBy = "accion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private List<SIDHIAccionValor> valores;
	
	@Column(name = "ACJ_ACCION")
	private Long idAccion;
	
	@Column(name = "ACJ_TIPO_JUICIO")
	private String tipoJuicio;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Override
	public String getCodigoEstadoProcesal() {
		if (estadoProcesal == null)
			return null;
		return estadoProcesal.getCodigo();
	}

	@Override
	public String getCodigoInterfaz() {
		return this.codigoInterfaz;
	}

	@Override
	public String getCodigoSubestadoProcesal() {
		if (subestadoProcesal == null)
			return null;
		return subestadoProcesal.getCodigo();
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;

	}

	public void setEstadoProcesal(SIDHIEstadoProcesal estadoProcesal) {
		this.estadoProcesal = estadoProcesal;
	}

	public SIDHIEstadoProcesal getEstadoProcesal() {
		return estadoProcesal;
	}

	public void setSubestadoProcesal(SIDHISubestadoProcesal subestadoProcesal) {
		this.subestadoProcesal = subestadoProcesal;
	}

	public SIDHISubestadoProcesal getSubestadoProcesal() {
		return subestadoProcesal;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setCodigoInterfaz(String codigoInterfaz) {
		this.codigoInterfaz = codigoInterfaz;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public void setProcesada(boolean procesada) {
		this.procesada = procesada;
	}

	public boolean isProcesada() {
		if (procesada == null)
			return Boolean.FALSE;
		return procesada;
	}

	public void setIter(SIDHIIterJudicial iter) {
		this.iter = iter;
	}

	public SIDHIIterJudicial getIter() {
		return iter;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	
	public Boolean getProcesada() {
		return procesada;
	}

	public void setProcesada(Boolean procesada) {
		this.procesada = procesada;
	}

	public List<SIDHIAccionValor> getValores() {
		return valores;
	}

	public void setValores(List<SIDHIAccionValor> valores) {
		this.valores = valores;
	}

	@Override
	public String getValor(SIDHITipoAccionValorInfo tipoValor) {
		if (tipoValor == null)
			return null;
		if (Checks.estaVacio(this.valores)) {
			return null;
		}
		if (!Checks.esNulo(tipoValor.getCodigo())) {
			for (SIDHIAccionValor acv : this.valores) {
				if ((acv.getTipo() != null)
						&& (acv.getTipo().getCodigo() != null)
						&& (acv.getTipo().getCodigo().equals(tipoValor
								.getCodigo()))) {
					return acv.getValor();
				}
			}
		} else {
			logger
					.warn("No se busca el valor por que el código de tipo es null: "
							+ tipoValor);
		}
		return null;
	}

	@Override
	public String toString() {
		return "SIDHIAccionJudicial [codigoInterfaz=" + codigoInterfaz
				+ ", estadoProcesal=" + estadoProcesal + ", fechaAccion="
				+ fechaAccion + ", id=" + id + ", procesada=" + procesada
				+ ", subestadoProcesal=" + subestadoProcesal + "]";
	}

	public void setIdAccion(Long idAccion) {
		this.idAccion = idAccion;
	}

	public Long getIdAccion() {
		return idAccion;
	}

	public SIDHIDatEacEstadoAccion getEstadoAccion() {
		return estadoAccion;
	}

	public void setEstadoAccion(SIDHIDatEacEstadoAccion estadoAccion) {
		this.estadoAccion = estadoAccion;
	}

	public String getTipoJuicio() {
		return tipoJuicio;
	}

	public void setTipoJuicio(String tipoJuicio) {
		this.tipoJuicio = tipoJuicio;
	}

}
