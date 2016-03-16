package es.capgemini.pfs.batch.recobro.facturacion.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;

/**
 * Clase donde se guardan los detalles de facturaci�n de cada subcartera para un proceso de facturacion
 * una vez se han aplicado los correctores
 * @author diana
 *
 */
@Entity
@Table(name = "TMP_RECOBRO_DETALLE_FACTURA_CO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroDetalleFacturacionCorrectorTemporal implements Serializable{

	/**
	 * SERIALUID
	 */
	private static final long serialVersionUID = 1L;
	
	public RecobroDetalleFacturacionCorrectorTemporal(){}
	
	public RecobroDetalleFacturacionCorrectorTemporal(RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal){
		this.agencia = recobroDetalleFacturacionTemporal.getAgencia();
		this.cobroPago = recobroDetalleFacturacionTemporal.getCobroPago();
		this.contrato = recobroDetalleFacturacionTemporal.getContrato();
		this.expediente = recobroDetalleFacturacionTemporal.getExpediente();
		this.fechaCobro = recobroDetalleFacturacionTemporal.getFechaCobro();
		this.importeAPagar = recobroDetalleFacturacionTemporal.getImporteAPagar();
		this.porcentaje = recobroDetalleFacturacionTemporal.getPorcentaje();
		this.procesoFacturacionSubcartera = recobroDetalleFacturacionTemporal.getProcesoFacturacionSubcartera();
		this.subCartera = recobroDetalleFacturacionTemporal.getSubCartera();
		this.tarifaCobro = recobroDetalleFacturacionTemporal.getTarifaCobro();
		this.importeConceptoFacturable = recobroDetalleFacturacionTemporal.getImporteConceptoFacturable();
		this.importeRealFacturable = recobroDetalleFacturacionTemporal.getImporteRealFacturable();
	}

	@ManyToOne
	@JoinColumn(name = "PFS_ID")
	private RecobroProcesoFacturacionSubcartera procesoFacturacionSubcartera;
	
	@Id
	@ManyToOne
	@JoinColumn(name = "CPA_ID")
	private EXTRecobroCobroPago cobroPago;
	
	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private EXTContrato contrato;
	
	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID", nullable = false)
	private RecobroSubCartera subCartera;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;
	
	@Column(name = "RDF_FECHA_COBRO")
	private Date fechaCobro;
	
	@Column(name = "RDF_PORCENTAJE")
	private Float porcentaje;
	
	@Column(name = "RDF_IMPORTE_A_PAGAR")
	private Double importeAPagar;
	
	@ManyToOne
	@JoinColumn(name = "RCF_TCC_ID")
	private RecobroTarifaCobro tarifaCobro;
	
	@Column(name="RDF_IMP_CONCEP_FACTU")
	private Double importeConceptoFacturable;
	
	@Column(name="RDF_IMP_REAL_FACTU")
	private Double importeRealFacturable;	
	
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
		return (Date)fechaCobro.clone();
	}

	public void setFechaCobro(Date fechaCobro) {
		this.fechaCobro = (Date)fechaCobro.clone();
	}

	public Float getPorcentaje() {
		return porcentaje;
	}

	public RecobroTarifaCobro getTarifaCobro() {
		return tarifaCobro;
	}

	public void setTarifaCobro(RecobroTarifaCobro tarifaCobro) {
		this.tarifaCobro = tarifaCobro;
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

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
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
	
}
