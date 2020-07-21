package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


@Entity
@Table(name = "GLD_GASTOS_LINEA_DETALLE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoLineaDetalle implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoLineaDetalleGenerator")
	@SequenceGenerator(name = "GastoLineaDetalleGenerator", sequenceName = "S_GLD_GASTOS_LINEA_DETALLE")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
	private GastoProveedor gastoProveedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
	
	@Column(name="GLD_PRINCIPAL_SUJETO")
    private Double principalSujeto;
	
	@Column(name="GLD_PRINCIPAL_NO_SUJETO")
    private Double principalNoSujeto;

	@Column(name="GLD_RECARGO")
    private Double recargo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TRG_ID")
	private DDTipoRecargoGasto tipoRecargoGasto;
	
	@Column(name="GLD_INTERES_DEMORA")
	private Double interesDemora;
	
	@Column(name="GLD_COSTAS")
	private Double costas;
	
	@Column(name="GLD_OTROS_INCREMENTOS")
	private Double otrosIncrementos;
	
	@Column(name="GLD_PROV_SUPLIDOS")
	private Double provSuplidos;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tipoImpuesto;
	
	@Column(name="GLD_IMP_IND_EXENTO")
	private Boolean esImporteIndirectoExento;
	
	@Column(name="GLD_IMP_IND_RENUNCIA_EXENCION")
	private Boolean esImporteIndirectoRenunciaExento;
	
	@Column(name="GLD_IMP_IND_TIPO_IMPOSITIVO")
	private Double importeIndirectoTipoImpositivo;
	
	@Column(name="GLD_IMP_IND_CUOTA")
	private Double importeIndirectoCuota;
	
	@Column(name="GLD_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name="GLD_CCC_BASE")
	private String cccBase;
	
	@Column(name="GLD_CPP_BASE")
	private String cppBase;
	
	@Column(name="GLD_CCC_ESP")
	private String cccEsp;
	
	@Column(name="GLD_CPP_ESP")
	private String cppEsp;
	
	@Column(name="GLD_CCC_TASAS")
	private String cccTasas;
	
	@Column(name="GLD_CPP_TASAS")
	private String cppTasas;
	
	@Column(name="GLD_CCC_RECARGO")
	private String cccRecargo;
	
	@Column(name="GLD_CPP_RECARGO")
	private String cppRecargo;
	
	@Column(name="GLD_CCC_INTERESES")
	private String cccIntereses;
	
	@Column(name="GLD_CPP_INTERESES")
	private String cppIntereses;
	
    @OneToOne(mappedBy = "gastoLineaDetalle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GastoLineaDetalleEntidad gastoLineaEntidad;    
    
    @OneToOne(mappedBy = "gastoLineaDetalle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GastoLineaDetalleTrabajo gastoLineaTrabajo;    
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public Double getPrincipalSujeto() {
		return principalSujeto;
	}

	public void setPrincipalSujeto(Double principalSujeto) {
		this.principalSujeto = principalSujeto;
	}

	public Double getPrincipalNoSujeto() {
		return principalNoSujeto;
	}

	public void setPrincipalNoSujeto(Double principalNoSujeto) {
		this.principalNoSujeto = principalNoSujeto;
	}

	public Double getRecargo() {
		return recargo;
	}

	public void setRecargo(Double recargo) {
		this.recargo = recargo;
	}

	public DDTipoRecargoGasto getTipoRecargoGasto() {
		return tipoRecargoGasto;
	}

	public void setTipoRecargoGasto(DDTipoRecargoGasto tipoRecargoGasto) {
		this.tipoRecargoGasto = tipoRecargoGasto;
	}

	public Double getInteresDemora() {
		return interesDemora;
	}

	public void setInteresDemora(Double interesDemora) {
		this.interesDemora = interesDemora;
	}

	public Double getCostas() {
		return costas;
	}

	public void setCostas(Double costas) {
		this.costas = costas;
	}

	public Double getOtrosIncrementos() {
		return otrosIncrementos;
	}

	public void setOtrosIncrementos(Double otrosIncrementos) {
		this.otrosIncrementos = otrosIncrementos;
	}

	public Double getProvSuplidos() {
		return provSuplidos;
	}

	public void setProvSuplidos(Double provSuplidos) {
		this.provSuplidos = provSuplidos;
	}

	public DDTiposImpuesto getTipoImpuesto() {
		return tipoImpuesto;
	}

	public void setTipoImpuesto(DDTiposImpuesto tipoImpuesto) {
		this.tipoImpuesto = tipoImpuesto;
	}

	public Boolean getEsImporteIndirectoExento() {
		return esImporteIndirectoExento;
	}

	public void setEsImporteIndirectoExento(Boolean esImporteIndirectoExento) {
		this.esImporteIndirectoExento = esImporteIndirectoExento;
	}

	public Boolean getEsImporteIndirectoRenunciaExento() {
		return esImporteIndirectoRenunciaExento;
	}

	public void setEsImporteIndirectoRenunciaExento(Boolean esImporteIndirectoRenunciaExento) {
		this.esImporteIndirectoRenunciaExento = esImporteIndirectoRenunciaExento;
	}

	public Double getImporteIndirectoTipoImpositivo() {
		return importeIndirectoTipoImpositivo;
	}

	public void setImporteIndirectoTipoImpositivo(Double importeIndirectoTipoImpositivo) {
		this.importeIndirectoTipoImpositivo = importeIndirectoTipoImpositivo;
	}

	public Double getImporteIndirectoCuota() {
		return importeIndirectoCuota;
	}

	public void setImporteIndirectoCuota(Double importeIndirectoCuota) {
		this.importeIndirectoCuota = importeIndirectoCuota;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public String getCccBase() {
		return cccBase;
	}

	public void setCccBase(String cccBase) {
		this.cccBase = cccBase;
	}

	public String getCppBase() {
		return cppBase;
	}

	public void setCppBase(String cppBase) {
		this.cppBase = cppBase;
	}

	public String getCccEsp() {
		return cccEsp;
	}

	public void setCccEsp(String cccEsp) {
		this.cccEsp = cccEsp;
	}

	public String getCppEsp() {
		return cppEsp;
	}

	public void setCppEsp(String cppEsp) {
		this.cppEsp = cppEsp;
	}

	public String getCccTasas() {
		return cccTasas;
	}

	public void setCccTasas(String cccTasas) {
		this.cccTasas = cccTasas;
	}

	public String getCppTasas() {
		return cppTasas;
	}

	public void setCppTasas(String cppTasas) {
		this.cppTasas = cppTasas;
	}

	public String getCccRecargo() {
		return cccRecargo;
	}

	public void setCccRecargo(String cccRecargo) {
		this.cccRecargo = cccRecargo;
	}

	public String getCppRecargo() {
		return cppRecargo;
	}

	public void setCppRecargo(String cppRecargo) {
		this.cppRecargo = cppRecargo;
	}

	public String getCccIntereses() {
		return cccIntereses;
	}

	public void setCccIntereses(String cccIntereses) {
		this.cccIntereses = cccIntereses;
	}

	public String getCppIntereses() {
		return cppIntereses;
	}

	public void setCppIntereses(String cppIntereses) {
		this.cppIntereses = cppIntereses;
	}

	public GastoLineaDetalleEntidad getGastoLineaEntidad() {
		return gastoLineaEntidad;
	}

	public void setGastoLineaEntidad(GastoLineaDetalleEntidad gastoLineaEntidad) {
		this.gastoLineaEntidad = gastoLineaEntidad;
	}

	public GastoLineaDetalleTrabajo getGastoLineaTrabajo() {
		return gastoLineaTrabajo;
	}

	public void setGastoLineaTrabajo(GastoLineaDetalleTrabajo gastoLineaTrabajo) {
		this.gastoLineaTrabajo = gastoLineaTrabajo;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
