package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedorHonorario;


/**
 * Modelo que gestiona la informacion de gastos de un expediente
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GEX_GASTOS_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastosExpediente implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastosExpedienteGenerator")
    @SequenceGenerator(name = "GastosExpedienteGenerator", sequenceName = "S_GEX_GASTOS_EXPEDIENTE")
    private Long id;
	
	@Column(name="GEX_WEBCOM_ID")
    private Long idWebCom;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ACC_ID")
	private DDAccionGastos accionGastos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCC_ID")
	private DDTipoCalculo tipoCalculo;     
    
    @Column(name="GEX_CODIGO")
    private String codigo;

    @Column(name="GEX_NOMBRE")
    private String nombre;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GEX_PROVEEDOR")
	private ActivoProveedor proveedor;

    @Column(name="GEX_OBSERVACIONES")
    private String observaciones;
    
    @Column(name="GEX_IMPORTE_CALCULO")
    private Double importeCalculo;

    @Column(name="GEX_IMPORTE_FINAL")
    private Double importeFinal;
    
    @Column(name="GEX_PAGADOR")
    private String pagador;
    
    @Column(name="GEX_APROBADO")
    private Integer aprobado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DEG_ID")
	private DDDestinatarioGasto destinatarioGasto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPH_ID")
	private DDTipoProveedorHonorario tipoProveedor;
    
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;    
    
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

	public Long getIdWebCom() {
		return idWebCom;
	}

	public void setIdWebCom(Long idWebCom) {
		this.idWebCom = idWebCom;
	}

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public DDAccionGastos getAccionGastos() {
		return accionGastos;
	}

	public void setAccionGastos(DDAccionGastos accionGastos) {
		this.accionGastos = accionGastos;
	}

	public DDTipoCalculo getTipoCalculo() {
		return tipoCalculo;
	}

	public void setTipoCalculo(DDTipoCalculo tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Double getImporteCalculo() {
		return importeCalculo;
	}

	public void setImporteCalculo(Double importeCalculo) {
		this.importeCalculo = importeCalculo;
	}

	public Double getImporteFinal() {
		return importeFinal;
	}

	public void setImporteFinal(Double importeFinal) {
		this.importeFinal = importeFinal;
	}

	public String getPagador() {
		return pagador;
	}

	public void setPagador(String pagador) {
		this.pagador = pagador;
	}

	public Integer getAprobado() {
		return aprobado;
	}

	public void setAprobado(Integer aprobado) {
		this.aprobado = aprobado;
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

	public DDDestinatarioGasto getDestinatarioGasto() {
		return destinatarioGasto;
	}

	public void setDestinatarioGasto(DDDestinatarioGasto destinatarioGasto) {
		this.destinatarioGasto = destinatarioGasto;
	}

	public DDTipoProveedorHonorario getTipoProveedor() {
		return tipoProveedor;
	}

	public void setTipoProveedor(DDTipoProveedorHonorario tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

     
    
   
}
