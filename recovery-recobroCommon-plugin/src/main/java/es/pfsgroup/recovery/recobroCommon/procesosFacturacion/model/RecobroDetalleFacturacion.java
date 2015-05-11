package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model;

import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;

/**
 * Clase donde se guardan los detalles de facturación de cada subcartera para un proceso de facturacion
 * @author diana
 *
 */
@Entity
@Table(name = "RDF_RECOBRO_DETALLE_FACTURA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroDetalleFacturacion implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5868116916008271482L;

	@Id
    @Column(name = "RDF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DetalleFacturacionGenerator")
	@SequenceGenerator(name = "DetalleFacturacionGenerator", sequenceName = "S_RDF_RECOBRO_DETALLE_FACTURA")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "PFS_ID")
	private RecobroProcesoFacturacionSubcartera procesoFacturacionSubcartera;
	
	/*@ManyToOne
	@JoinColumn(name = "CPA_ID")
	private CobroPago cobroPago;*/
	
	@ManyToOne
	@JoinColumn(name = "CPA_ID")
	private EXTRecobroCobroPago cobroPago;
	
	@ManyToOne
	@JoinColumn(name = "CPR_ID")
	private RecobroCobroPreprocesado cobroPagoPreprocesado;
	
	
	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private EXTContrato contrato;
	
	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;
	
	@Column(name = "RDF_FECHA_COBRO")
	private Date fechaCobro;
	
	@Column(name = "RDF_PORCENTAJE")
	private Float porcentaje;
	
	@Column(name = "RDF_IMPORTE_A_PAGAR")
	private Double importeAPagar;
	
	@ManyToOne
	@JoinColumn(name = "RCF_TCC_ID")
	private RecobroTarifaCobro tarifaCobro;
	
	@Column(name = "RDF_IMP_CONCEP_FACTU")
	private Double importeConceptoFacturable;
	
	@Column(name = "RDF_IMP_REAL_FACTU")
	private Double importeRealFacturable;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID")
	private RecobroAgencia agencia;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID")
	private RecobroSubCartera subCartera;

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

	public RecobroProcesoFacturacionSubcartera getProcesoFacturacionSubcartera() {
		return procesoFacturacionSubcartera;
	}

	public void setProcesoFacturacionSubcartera(
			RecobroProcesoFacturacionSubcartera procesoFacturacionSubcartera) {
		this.procesoFacturacionSubcartera = procesoFacturacionSubcartera;
	}

	public EXTRecobroCobroPago getCobroPago() {
		return cobroPago;
	}

	public void setCobroPago(EXTRecobroCobroPago cobroPago) {
		this.cobroPago = cobroPago;
	}

	public EXTContrato getContrato() {
		return contrato;
	}

	public void setContrato(EXTContrato contrato) {
		this.contrato = contrato;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public Date getFechaCobro() {
		return fechaCobro;
	}

	public void setFechaCobro(Date fechaCobro) {
		this.fechaCobro = fechaCobro;
	}

	public Float getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Float porcentaje) {
		this.porcentaje = porcentaje;
	}

	public Double getImporteAPagar() {
		return importeAPagar;
	}

	public void setImporteAPagar(Double importeAPagar) {
		this.importeAPagar = importeAPagar;
	}
	
	public RecobroTarifaCobro getTarifaCobro() {
		return tarifaCobro;
	}

	public void setTarifaCobro(RecobroTarifaCobro tarifaCobro) {
		this.tarifaCobro = tarifaCobro;
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

	public Double getImporteConceptoFacturable() {
		return importeConceptoFacturable;
	}

	public void setImporteConceptoFacturable(Double importeConceptoFacturable) {
		this.importeConceptoFacturable = importeConceptoFacturable;
	}

	public Double getImporteRealFacturable() {
		return importeRealFacturable;
	}

	public void setImporteRealFacturable(Double importeRealFacturable) {
		this.importeRealFacturable = importeRealFacturable;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public RecobroCobroPreprocesado getCobroPagoPreprocesado() {
		return cobroPagoPreprocesado;
	}

	public void setCobroPagoPreprocesado(
			RecobroCobroPreprocesado cobroPagoPreprocesado) {
		this.cobroPagoPreprocesado = cobroPagoPreprocesado;
	}
	
	

}
