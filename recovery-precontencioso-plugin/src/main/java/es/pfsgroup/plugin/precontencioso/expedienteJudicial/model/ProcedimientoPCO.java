package es.pfsgroup.plugin.precontencioso.expedienteJudicial.model;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.OrderBy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Entity
@Table(name = "PCO_PRC_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProcedimientoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = 8036714975464886725L;

	@Id
	@Column(name = "PCO_PRC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoPCOGenerator")
	@SequenceGenerator(name = "ProcedimientoPCOGenerator", sequenceName = "S_PCO_PRC_PROCEDIMIENTOS")
	private Long id;

	@OneToOne
	@JoinColumn(name = "PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Procedimiento procedimiento;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_PTP_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoPreparacionPCO tipoPreparacion;
	
	@ManyToOne
	@JoinColumn(name = "PCO_PRC_TIPO_PRC_PROP")
	private TipoProcedimiento tipoProcPropuesto;

	@ManyToOne
    @JoinColumn(name = "PCO_PRC_TIPO_PRC_INICIADO")
	private TipoProcedimiento tipoProcIniciado;

	@Column(name = "PCO_PRC_PRETURNADO")
	private Boolean preturnado;

	@Column(name = "PCO_PRC_NOM_EXP_JUD")
	private String nombreExpJudicial;

	@Column(name = "PCO_PRC_NUM_EXP_INT")
	private String numExpInterno;
	
	@Column(name = "PCO_PRC_NUM_EXP_EXT")
	private String numExpExterno;

	@Column(name = "PCO_PRC_CNT_PRINCIPAL")
	private String cntPrincipal;

	@OneToMany(mappedBy = "procedimientoPCO", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<DocumentoPCO> documentos;

	@OneToMany(mappedBy = "procedimientoPCO", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<LiquidacionPCO> liquidaciones;

	@OneToMany(mappedBy = "procedimientoPCO", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<BurofaxPCO> burofaxes;

	@OneToMany(mappedBy = "procedimientoPCO", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@OrderBy(clause = "PCO_PRC_HEP_FECHA_INCIO DESC")
	private List<HistoricoEstadoProcedimientoPCO> estadosPreparacionProc;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * Devuelve el <DDEstadoPreparacionPCO> en el que se encuentra el procedimiento
	 */
	public DDEstadoPreparacionPCO getEstadoActual () {
		HistoricoEstadoProcedimientoPCO historico = getEstadoActualByHistorico();
		if(historico != null) {
			return historico.getEstadoPreparacion();
		}
		return null;
	}
	
	public HistoricoEstadoProcedimientoPCO getEstadoActualByHistorico() {
		HistoricoEstadoProcedimientoPCO estadoActual = null;
		// Recuperar estado actual por fecha inicio mas actual
		Date fechaMasActual = null;
		if (estadosPreparacionProc != null) {
			for (HistoricoEstadoProcedimientoPCO historicoEstado : estadosPreparacionProc) {
				if (fechaMasActual == null || fechaMasActual.before(historicoEstado.getFechaInicio())) {
					if( historicoEstado.getEstadoPreparacion() != null) {
						fechaMasActual = historicoEstado.getFechaInicio();
						estadoActual = historicoEstado;
					}
				}
			}
		}
		return estadoActual;
	}

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public DDTipoPreparacionPCO getTipoPreparacion() {
		return tipoPreparacion;
	}

	public void setTipoPreparacion(DDTipoPreparacionPCO tipoPreparacion) {
		this.tipoPreparacion = tipoPreparacion;
	}

	public TipoProcedimiento getTipoProcPropuesto() {
		return tipoProcPropuesto;
	}

	public void setTipoProcPropuesto(TipoProcedimiento tipoProcPropuesto) {
		this.tipoProcPropuesto = tipoProcPropuesto;
	}

	public TipoProcedimiento getTipoProcIniciado() {
		return tipoProcIniciado;
	}

	public void setTipoProcIniciado(TipoProcedimiento tipoProcIniciado) {
		this.tipoProcIniciado = tipoProcIniciado;
	}

	public Boolean getPreturnado() {
		return preturnado;
	}

	public void setPreturnado(Boolean preturnado) {
		this.preturnado = preturnado;
	}

	public String getNombreExpJudicial() {
		return nombreExpJudicial;
	}

	public void setNombreExpJudicial(String nombreExpJudicial) {
		this.nombreExpJudicial = nombreExpJudicial;
	}

	public String getNumExpInterno() {
		return numExpInterno;
	}

	public void setNumExpInterno(String numExpInterno) {
		this.numExpInterno = numExpInterno;
	}

	public String getNumExpExterno() {
		return numExpExterno;
	}

	public void setNumExpExterno(String numExpExterno) {
		this.numExpExterno = numExpExterno;
	}

	public String getCntPrincipal() {
		return cntPrincipal;
	}

	public void setCntPrincipal(String cntPrincipal) {
		this.cntPrincipal = cntPrincipal;
	}

	public List<DocumentoPCO> getDocumentos() {
		return documentos;
	}

	public void setDocumentos(List<DocumentoPCO> documentos) {
		this.documentos = documentos;
	}

	public List<LiquidacionPCO> getLiquidaciones() {
		return liquidaciones;
	}

	public void setLiquidaciones(List<LiquidacionPCO> liquidaciones) {
		this.liquidaciones = liquidaciones;
	}

	public List<BurofaxPCO> getBurofaxes() {
		return burofaxes;
	}

	public void setBurofaxes(List<BurofaxPCO> burofaxes) {
		this.burofaxes = burofaxes;
	}

	public List<HistoricoEstadoProcedimientoPCO> getEstadosPreparacionProc() {
		return estadosPreparacionProc;
	}

	public void setEstadosPreparacionProc(List<HistoricoEstadoProcedimientoPCO> estadosPreparacionProc) {
		this.estadosPreparacionProc = estadosPreparacionProc;
	}

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
