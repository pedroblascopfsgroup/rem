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
import es.pfsgroup.plugin.rem.model.dd.DDTipoRetencion;


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
    
    @Column(name="GDE_REEMBOLSO_TERCERO")
    private Integer reembolsoTercero;
    
    @Column(name="GDE_INCLUIR_PAGO_PROVISION")
    private Integer incluirPagoProvision;
    
    @Column(name="GDE_ABONO_CUENTA")
    private Integer abonoCuenta;
    
    @Column(name="GDE_IBAN")
    private String ibanAbonar;
    
    @Column(name="GDE_TITULAR_CUENTA")
    private String titularCuentaAbonar;
    
    @Column(name="GDE_NIF_TITULAR_CUENTA")
    private String nifTitularCuentaAbonar;
    
    @Column(name="GDE_PAGADO_CONEXION_BANKIA")
    private Integer pagadoConexionBankia;
    
    @Column(name="GDE_NUMERO_CONEXION")
    private String numeroConexionBankia;
    
    @Column(name="GDE_OFICINA_BANKIA")
    private String oficinaBankia;
    
    @Column(name="GDE_FECHA_CONEXION")
    private Date fechaConexion;
    
    @Column(name="GDE_ANTICIPO")
    private Integer anticipo;
    
	@Column(name="GDE_FECHA_ANTICIPO")
    private Date fechaAnticipo;
	
	@Column(name="GDE_GASTO_REFACTURABLE")
    private Boolean gastoRefacturable;

    @Column(name = "GDE_IRPF_BASE")
    private Double irpfBase;
    
    @Column(name = "GDE_IRPF_CLAVE")
    private String irpfClave;
    
    @Column(name = "GDE_IRPF_SUBCLAVE")
    private String irpfSubclave;
    
    @Column(name = "GDE_RET_GAR_BASE")
    private Double retencionGarantiaBase;
    
   @Column(name = "GDE_RET_GAR_TIPO_IMPOSITIVO")
    private Double retencionGarantiaTipoImpositivo;
    
   @Column(name = "GDE_RET_GAR_CUOTA")
   private Double retencionGarantiaCuota;
   
   @Column(name = "GDE_RET_GAR_APLICA")
   private Boolean retencionGarantiaAplica;
   
   @ManyToOne(fetch = FetchType.LAZY)
   @JoinColumn(name = "DD_TRE_ID")
   private DDTipoRetencion tipoRetencion;
   
   @Column(name = "GDE_PAGO_URGENTE")
   private Boolean pagoUrgente;

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

	public Integer getReembolsoTercero() {
		return reembolsoTercero;
	}

	public void setReembolsoTercero(Integer reembolsoTercero) {
		this.reembolsoTercero = reembolsoTercero;
	}

	public Integer getIncluirPagoProvision() {
		return incluirPagoProvision;
	}

	public void setIncluirPagoProvision(Integer incluirPagoProvision) {
		this.incluirPagoProvision = incluirPagoProvision;
	}

	public Integer getAbonoCuenta() {
		return abonoCuenta;
	}

	public void setAbonoCuenta(Integer abonoCuenta) {
		this.abonoCuenta = abonoCuenta;
	}

	public String getIbanAbonar() {
		return ibanAbonar;
	}

	public void setIbanAbonar(String ibanAbonar) {
		this.ibanAbonar = ibanAbonar;
	}

	public String getTitularCuentaAbonar() {
		return titularCuentaAbonar;
	}

	public void setTitularCuentaAbonar(String titularCuentaAbonar) {
		this.titularCuentaAbonar = titularCuentaAbonar;
	}

	public String getNifTitularCuentaAbonar() {
		return nifTitularCuentaAbonar;
	}

	public void setNifTitularCuentaAbonar(String nifTitularCuentaAbonar) {
		this.nifTitularCuentaAbonar = nifTitularCuentaAbonar;
	}

	public Integer getPagadoConexionBankia() {
		return pagadoConexionBankia;
	}

	public void setPagadoConexionBankia(Integer pagadoConexionBankia) {
		this.pagadoConexionBankia = pagadoConexionBankia;
	}

	public String getNumeroConexionBankia() {
		return numeroConexionBankia;
	}

	public void setNumeroConexionBankia(String numeroConexionBankia) {
		this.numeroConexionBankia = numeroConexionBankia;
	}

	public String getOficinaBankia() {
		return oficinaBankia;
	}

	public void setOficinaBankia(String oficinaBankia) {
		this.oficinaBankia = oficinaBankia;
	}

	public Date getFechaConexion() {
		return fechaConexion;
	}

	public void setFechaConexion(Date fechaConexion) {
		this.fechaConexion = fechaConexion;
	}
	
    public Integer getAnticipo() {
		return anticipo;
	}

	public void setAnticipo(Integer anticipo) {
		this.anticipo = anticipo;
	}

	public Date getFechaAnticipo() {
		return fechaAnticipo;
	}

	public void setFechaAnticipo(Date fechaAnticipo) {
		this.fechaAnticipo = fechaAnticipo;
	}

	public Boolean getGastoRefacturable() {
		return gastoRefacturable;
	}

	public void setGastoRefacturable(Boolean gastoRefacturable) {
		this.gastoRefacturable = gastoRefacturable;
	}

	public Double getIrpfBase() {
		return irpfBase;
	}

	public void setIrpfBase(Double irpfBase) {
		this.irpfBase = irpfBase;
	}

	public String getIrpfClave() {
		return irpfClave;
	}

	public void setIrpfClave(String irpfClave) {
		this.irpfClave = irpfClave;
	}

	public String getIrpfSubclave() {
		return irpfSubclave;
	}

	public void setIrpfSubclave(String irpfSubclave) {
		this.irpfSubclave = irpfSubclave;
	}

	public Double getRetencionGarantiaBase() {
		return retencionGarantiaBase;
	}

	public void setRetencionGarantiaBase(Double retencionGarantiaBase) {
		this.retencionGarantiaBase = retencionGarantiaBase;
	}

	public Double getRetencionGarantiaTipoImpositivo() {
		return retencionGarantiaTipoImpositivo;
	}

	public void setRetencionGarantiaTipoImpositivo(Double retencionGarantiaTipoImpositivo) {
		this.retencionGarantiaTipoImpositivo = retencionGarantiaTipoImpositivo;
	}

	public Double getRetencionGarantiaCuota() {
		return retencionGarantiaCuota;
	}

	public void setRetencionGarantiaCuota(Double retencionGarantiaCuota) {
		this.retencionGarantiaCuota = retencionGarantiaCuota;
	}

	public Boolean getRetencionGarantiaAplica() {
		return retencionGarantiaAplica;
	}

	public void setRetencionGarantiaAplica(Boolean retencionGarantiaAplica) {
		this.retencionGarantiaAplica = retencionGarantiaAplica;
	}

	public DDTipoRetencion getTipoRetencion() {
		return tipoRetencion;
	}

	public void setTipoRetencion(DDTipoRetencion tipoRetencion) {
		this.tipoRetencion = tipoRetencion;
	}

	public Boolean getPagoUrgente() {
		return pagoUrgente;
	}

	public void setPagoUrgente(Boolean pagoUrgente) {
		this.pagoUrgente = pagoUrgente;
	}
	
}
