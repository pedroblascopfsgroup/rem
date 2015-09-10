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
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.OrderBy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
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

	/*
	 * Formulas para el buscador de precontencioso
	 */

	@Formula(value = 
		" (SELECT dd_pco_prc_estado_preparacion.dd_pco_pep_descripcion" +
		" FROM   pco_prc_hep_histor_est_prep " +
		"       INNER JOIN pco_prc_procedimientos " +
		"               ON pco_prc_procedimientos.pco_prc_id = pco_prc_hep_histor_est_prep.pco_prc_id " +
		"       INNER JOIN dd_pco_prc_estado_preparacion " +
		"               ON dd_pco_prc_estado_preparacion.dd_pco_pep_id = pco_prc_hep_histor_est_prep.dd_pco_pep_id " +
		" WHERE  pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_fin IS NULL " +
		"       AND pco_prc_procedimientos.borrado = 0 " +
		"       AND pco_prc_hep_histor_est_prep.borrado = 0 " +
		"       AND dd_pco_prc_estado_preparacion.borrado = 0 " +
		"       AND pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID ) ")
	private String estadoActual;

	@Formula(value = 
		" (SELECT pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_incio" +
		" FROM   pco_prc_hep_histor_est_prep " +
		"       INNER JOIN pco_prc_procedimientos " +
		"               ON pco_prc_procedimientos.pco_prc_id = pco_prc_hep_histor_est_prep.pco_prc_id " +
		" WHERE  pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_fin IS NULL " +
		"       AND pco_prc_procedimientos.borrado = 0 " +
		"       AND pco_prc_hep_histor_est_prep.borrado = 0 " +
		"       AND pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID ) ")
	private Date fechaEstadoActual;

	@Formula(value = 
		"(SELECT SUM(pco_liq_liquidaciones.pco_liq_total) " +
		" FROM   pco_prc_procedimientos " +
		"       INNER JOIN pco_liq_liquidaciones ON pco_prc_procedimientos.pco_prc_id = pco_liq_liquidaciones.pco_prc_id " +
		" WHERE  pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID) ")
	private Float totalLiquidacion;

	@Formula(value = 
		" (SELECT CASE WHEN Count(1) > 0 THEN 0 ELSE 1 END " +
		" FROM   pco_prc_procedimientos " +
		"        INNER JOIN pco_doc_documentos " +
		"                ON pco_prc_procedimientos.pco_prc_id = pco_doc_documentos.pco_prc_id " +
		" WHERE  pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID " +
		"        AND pco_doc_documentos.borrado = 0 " +
		"        AND pco_doc_documentos.pco_doc_pdd_adjunto = 0) ")
	private Boolean todosDocumentos;

	@Formula(value = 
		" (SELECT CASE WHEN Count(1) > 0 THEN 0 ELSE 1 END " +
		" FROM   pco_liq_liquidaciones " +
		"        INNER JOIN pco_prc_procedimientos " +
		"                ON pco_prc_procedimientos.pco_prc_id = pco_liq_liquidaciones.pco_prc_id " +
		"        INNER JOIN dd_pco_liq_estado " +
		"                ON dd_pco_liq_estado.dd_pco_liq_id = pco_liq_liquidaciones.dd_pco_liq_id " +
		" WHERE  pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID " +
		"        AND pco_liq_liquidaciones.borrado = 0 " +
		"        AND dd_pco_liq_estado.dd_pco_liq_codigo != '" + DDEstadoLiquidacionPCO.CONFIRMADA + "' )")
	private Boolean todasLiquidaciones;

	@Formula(value = 
		" (SELECT CASE WHEN Count(1) > 0 THEN 0 ELSE 1 END " +
		" FROM   pco_prc_procedimientos " +
		"        INNER JOIN pco_bur_burofax " +
		"                ON pco_prc_procedimientos.pco_prc_id = pco_bur_burofax.pco_prc_id " +
		"        INNER JOIN dd_pco_bfe_estado " +
		"                ON dd_pco_bfe_estado.dd_pco_bfe_id = pco_bur_burofax.dd_pco_bfe_id " +
		" WHERE  dd_pco_bfe_estado.dd_pco_bfe_codigo != '" + DDEstadoBurofaxPCO.NOTIFICADO + "' " +
		"        AND pco_bur_burofax.borrado = 0 " +
		"        AND pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID )")
	private Boolean todosBurofaxes;

	@Formula(value =
		" (SELECT TRUNC(SYSDATE) - TRUNC(pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_incio) " +
		" FROM   pco_prc_procedimientos " +
		"        INNER JOIN pco_prc_hep_histor_est_prep " +
		"                ON pco_prc_procedimientos.pco_prc_id = pco_prc_hep_histor_est_prep.pco_prc_id " +
		"        INNER JOIN dd_pco_prc_estado_preparacion " +
		"                ON dd_pco_prc_estado_preparacion.dd_pco_pep_id = pco_prc_hep_histor_est_prep.dd_pco_pep_id " +
		" WHERE  pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID " +
		"        AND pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_fin IS NULL " +
		"        AND pco_prc_hep_histor_est_prep.borrado = 0 " +
		"        AND dd_pco_prc_estado_preparacion.dd_pco_pep_codigo != '" + DDEstadoPreparacionPCO.PREPARADO + "' " +
		"        AND dd_pco_prc_estado_preparacion.dd_pco_pep_codigo != '" + DDEstadoPreparacionPCO.CANCELADO + "' ) ")
	private Integer diasEnGestion;
	
	private static final String formulaFechaGeneralizada1 =
	" (SELECT MAX(To_date(To_char(pco_prc_hep_histor_est_prep.pco_prc_hep_fecha_incio, 'yyyy-MM-dd'), 'yyyy-MM-dd')) " +
	"        FROM   pco_prc_hep_histor_est_prep " +
	"               inner join pco_prc_procedimientos " +
	"                       ON pco_prc_procedimientos.pco_prc_id = pco_prc_hep_histor_est_prep.pco_prc_id " +
	"               inner join dd_pco_prc_estado_preparacion " +
	"                       ON dd_pco_prc_estado_preparacion.dd_pco_pep_id = pco_prc_hep_histor_est_prep.dd_pco_pep_id " +
	"        WHERE  pco_prc_procedimientos.borrado = 0 " +
	"               AND pco_prc_hep_histor_est_prep.borrado = 0 " +
	"               AND dd_pco_prc_estado_preparacion.borrado = 0 " +
	"               AND pco_prc_procedimientos.pco_prc_id = PCO_PRC_ID " +
	"               AND dd_pco_prc_estado_preparacion.dd_pco_pep_codigo = '";
	
	private static final String formulaFechaGeneralizada2 =
	"')";
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.PREPARACION + formulaFechaGeneralizada2)
	private Date fechaInicioPreparacion;
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.ENVIADO + formulaFechaGeneralizada2)
	private Date fechaEnvioLetrado;
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.PREPARADO + formulaFechaGeneralizada2)
	private Date fechaPreparado;
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.FINALIZADO + formulaFechaGeneralizada2)
	private Date fechaFinalizado;
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.SUBSANAR + formulaFechaGeneralizada2)
	private Date fechaUltimaSubsanacion;
	
	@Formula(value = formulaFechaGeneralizada1 + DDEstadoPreparacionPCO.CANCELADO + formulaFechaGeneralizada2)
	private Date fechaCancelado;

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
		for (HistoricoEstadoProcedimientoPCO historicoEstado : estadosPreparacionProc) {
			if (fechaMasActual == null || fechaMasActual.before(historicoEstado.getFechaInicio())) {
				if( historicoEstado.getEstadoPreparacion() != null) {
					fechaMasActual = historicoEstado.getFechaInicio();
					estadoActual = historicoEstado;
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
