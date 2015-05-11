package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;

/**
 * Clase que relaciona las subcarteras con los procesos de facturacion
 * @author diana
 *
 */
@Entity
@Table(name = "PFS_PROC_FAC_SUBCARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroProcesoFacturacionSubcartera implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5319625705175711973L;

	@Id
    @Column(name = "PFS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcesoFacturacionSubcarteraGenerator")
	@SequenceGenerator(name = "ProcesoFacturacionSubcarteraGenerator", sequenceName = "S_PFS_PROC_FAC_SUBCARTERA")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "PRF_ID")
	private RecobroProcesoFacturacion procesoFacturacion;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID")
	private RecobroSubCartera subCartera;
	
	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID_ORIGINAL")
	private RecobroModeloFacturacion modeloFacturacionInicial;
	
	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID_ACTUAL")
	private RecobroModeloFacturacion modeloFacturacionActual;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="PFS_ID")
	@OrderBy("agencia")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroDetalleFacturacion> detallesFacturacion;
	
	@Column(name = "RCF_TOTAL_COBROS")
	private Double totalImporteCobros;
	
	@Column(name = "RCF_TOTAL_FACTURABLE")
	private Double totalImporteFacturable;
	
	
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

	public RecobroProcesoFacturacion getProcesoFacturacion() {
		return procesoFacturacion;
	}

	public void setProcesoFacturacion(RecobroProcesoFacturacion procesoFacturacion) {
		this.procesoFacturacion = procesoFacturacion;
	}

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public RecobroModeloFacturacion getModeloFacturacionInicial() {
		return modeloFacturacionInicial;
	}

	public void setModeloFacturacionInicial(
			RecobroModeloFacturacion modeloFacturacionInicial) {
		this.modeloFacturacionInicial = modeloFacturacionInicial;
	}

	public RecobroModeloFacturacion getModeloFacturacionActual() {
		return modeloFacturacionActual;
	}

	public void setModeloFacturacionActual(
			RecobroModeloFacturacion modeloFacturacionActual) {
		this.modeloFacturacionActual = modeloFacturacionActual;
	}

	public List<RecobroDetalleFacturacion> getDetallesFacturacion() {
		return detallesFacturacion;
	}

	public void setDetallesFacturacion(
			List<RecobroDetalleFacturacion> detallesFacturacion) {
		this.detallesFacturacion = detallesFacturacion;
	}

	public Double getTotalImporteCobros() {
		return totalImporteCobros;
	}

	public void setTotalImporteCobros(Double totalImporteCobros) {
		this.totalImporteCobros = totalImporteCobros;
	}

	public Double getTotalImporteFacturable() {
		return totalImporteFacturable;
	}

	public void setTotalImporteFacturable(Double totalImporteFacturable) {
		this.totalImporteFacturable = totalImporteFacturable;
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
	

	/**
	 * Devuelve el número de registros de detalles que corresponden con la agencia determinada
	 * @param agenciaId
	 * @return
	 */
	public Double getTotalCobrosAgencia(Long agenciaId) {
		Double total = 0d;
		for (RecobroDetalleFacturacion recobroDetalleFacturacion : detallesFacturacion) {
			if (recobroDetalleFacturacion.getAgencia().getId().longValue() == agenciaId.longValue())
				total++;
		}
		
		return total;
	}
	
	/**
	 * Devuelve el sumatorio del importe a pagar de los detalles por agencia 
	 * @param agenciaId
	 * @return
	 */
	public Double getTotalImporteCobrosAgencia(Long agenciaId) {
		Double total = 0d;
		for (RecobroDetalleFacturacion recobroDetalleFacturacion : detallesFacturacion) {
			if (recobroDetalleFacturacion.getAgencia().getId().longValue() == agenciaId.longValue())
				total += recobroDetalleFacturacion.getImporteAPagar();
		}
		
		return total;
	}
}
