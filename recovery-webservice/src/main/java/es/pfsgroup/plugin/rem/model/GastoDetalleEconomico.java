package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPagador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPago;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


/**
 * Modelo que gestiona la informacion del detalle económico de un gasto
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GDE_GASTOS_DETALLE_ECONOMICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoDetalleEconomico implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GDE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoDetalleEconomicoGenerator")
    @SequenceGenerator(name = "GastoDetalleEconomicoGenerator", sequenceName = "S_GDE_GASTOS_DETALLE_ECONOMICO")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;
    
    @Column(name="GDE_PRINCIPAL_SUJETO")
    private Double importePrincipalSujeto;
    
    @Column(name="GDE_PRINCIPAL_NO_SUJETO")
    private Double importePrincipalNoSujeto;
    
    @Column(name="GDE_RECARGO")
    private Double importeRecargo;
    
    @Column(name="GDE_INTERES_DEMORA")
    private Double importeInteresDemora;
    
    @Column(name="GDE_COSTAS")
    private Double importeCostas;
    
    @Column(name="GDE_OTROS_INCREMENTOS")
    private Double importeOtrosIncrementos;
    
    @Column(name="GDE_PROV_SUPLIDOS")
    private Double importeProvisionesSuplidos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
    private DDTiposImpuesto impuestoIndirectoTipo;
    
    @Column(name="GDE_IMP_IND_EXENTO")
    private Integer impuestoIndirectoExento;
    
    @Column(name="GDE_IMP_IND_RENUNCIA_EXENCION")
    private Integer renunciaExencionImpuestoIndirecto;
    
    @Column(name="GDE_IMP_IND_TIPO_IMPOSITIVO")
    private Double impuestoIndirectoTipoImpositivo;
    
    @Column(name="GDE_IMP_IND_CUOTA")
    private Double impuestoIndirectoCuota;
    
    @Column(name="GDE_IRPF_TIPO_IMPOSITIVO")
    private Double irpfTipoImpositivo;
    
    @Column(name="GDE_IRPF_CUOTA")
    private Double irpfCuota;
    
    @Column(name="GDE_IMPORTE_TOTAL")
    private Double importeTotal;
    
    @Column(name="GDE_FECHA_TOPE_PAGO")
    private Date fechaTopePago;
    
    @Column(name="GDE_REPERCUTIBLE_INQUILINO")
    private Integer repercutibleInquilino;
    
    @Column(name="GDE_IMPORTE_PAGADO")
    private Double importePagado;
    
    @Column(name="GDE_FECHA_PAGO")
    private Date fechaPago;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoPagador tipoPagador;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPP_ID")
    private DDTipoPago tipoPago;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DEP_ID")
    private DDDestinatarioPago destinatariosPago;   
    
    
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

	public Double getImportePrincipalSujeto() {
		return importePrincipalSujeto;
	}

	public void setImportePrincipalSujeto(Double importePrincipalSujeto) {
		this.importePrincipalSujeto = importePrincipalSujeto;
	}

	public Double getImportePrincipalNoSujeto() {
		return importePrincipalNoSujeto;
	}

	public void setImportePrincipalNoSujeto(Double importePrincipalNoSujeto) {
		this.importePrincipalNoSujeto = importePrincipalNoSujeto;
	}

	public Double getImporteRecargo() {
		return importeRecargo;
	}

	public void setImporteRecargo(Double importeRecargo) {
		this.importeRecargo = importeRecargo;
	}

	public Double getImporteInteresDemora() {
		return importeInteresDemora;
	}

	public void setImporteInteresDemora(Double importeInteresDemora) {
		this.importeInteresDemora = importeInteresDemora;
	}

	public Double getImporteCostas() {
		return importeCostas;
	}

	public void setImporteCostas(Double importeCostas) {
		this.importeCostas = importeCostas;
	}

	public Double getImporteOtrosIncrementos() {
		return importeOtrosIncrementos;
	}

	public void setImporteOtrosIncrementos(Double importeOtrosIncrementos) {
		this.importeOtrosIncrementos = importeOtrosIncrementos;
	}

	public Double getImporteProvisionesSuplidos() {
		return importeProvisionesSuplidos;
	}

	public void setImporteProvisionesSuplidos(Double importeProvisionesSuplidos) {
		this.importeProvisionesSuplidos = importeProvisionesSuplidos;
	}

	public DDTiposImpuesto getImpuestoIndirectoTipo() {
		return impuestoIndirectoTipo;
	}

	public void setImpuestoIndirectoTipo(DDTiposImpuesto impuestoIndirectoTipo) {
		this.impuestoIndirectoTipo = impuestoIndirectoTipo;
	}

	public Integer getImpuestoIndirectoExento() {
		return impuestoIndirectoExento;
	}

	public void setImpuestoIndirectoExento(Integer impuestoIndirectoExento) {
		this.impuestoIndirectoExento = impuestoIndirectoExento;
	}

	public Integer getRenunciaExencionImpuestoIndirecto() {
		return renunciaExencionImpuestoIndirecto;
	}

	public void setRenunciaExencionImpuestoIndirecto(
			Integer renunciaExencionImpuestoIndirecto) {
		this.renunciaExencionImpuestoIndirecto = renunciaExencionImpuestoIndirecto;
	}

	public Double getImpuestoIndirectoTipoImpositivo() {
		return impuestoIndirectoTipoImpositivo;
	}

	public void setImpuestoIndirectoTipoImpositivo(
			Double impuestoIndirectoTipoImpositivo) {
		this.impuestoIndirectoTipoImpositivo = impuestoIndirectoTipoImpositivo;
	}

	public Double getImpuestoIndirectoCuota() {
		return impuestoIndirectoCuota;
	}

	public void setImpuestoIndirectoCuota(Double impuestoIndirectoCuota) {
		this.impuestoIndirectoCuota = impuestoIndirectoCuota;
	}

	public Double getIrpfTipoImpositivo() {
		return irpfTipoImpositivo;
	}

	public void setIrpfTipoImpositivo(Double irpfTipoImpositivo) {
		this.irpfTipoImpositivo = irpfTipoImpositivo;
	}

	public Double getIrpfCuota() {
		return irpfCuota;
	}

	public void setIrpfCuota(Double irpfCuota) {
		this.irpfCuota = irpfCuota;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
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

	public Date getFechaTopePago() {
		return fechaTopePago;
	}

	public void setFechaTopePago(Date fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}

	public Integer getRepercutibleInquilino() {
		return repercutibleInquilino;
	}

	public void setRepercutibleInquilino(Integer repercutibleInquilino) {
		this.repercutibleInquilino = repercutibleInquilino;
	}

	public Double getImportePagado() {
		return importePagado;
	}

	public void setImportePagado(Double importePagado) {
		this.importePagado = importePagado;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public DDTipoPagador getTipoPagador() {
		return tipoPagador;
	}

	public void setTipoPagador(DDTipoPagador tipoPagador) {
		this.tipoPagador = tipoPagador;
	}

	public DDTipoPago getTipoPago() {
		return tipoPago;
	}

	public void setTipoPago(DDTipoPago tipoPago) {
		this.tipoPago = tipoPago;
	}

	public DDDestinatarioPago getDestinatariosPago() {
		return destinatariosPago;
	}

	public void setDestinatariosPago(DDDestinatarioPago destinatariosPago) {
		this.destinatariosPago = destinatariosPago;
	}

}
