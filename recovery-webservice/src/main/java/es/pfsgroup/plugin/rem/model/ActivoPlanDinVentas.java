package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * Modelo que gestiona el plan dinamico de ventas de un activo
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_PDV_PLAN_DIN_VENTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPlanDinVentas implements Serializable, Auditable {



	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "PDV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ACTPlanDinVentasGenerator")
    @SequenceGenerator(name = "ACTPlanDinVentasGenerator", sequenceName = "S_ACT_PDV_PLAN_DIN_VENTAS")
    private Long id;	
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
/*	@ManyToOne
    @JoinColumn(name = "DD_TPD_ID")
    private DDTipoProductoFinanciero tipoProductoFinanciero;
	
	@Column(name = "PDV_ACREEDOR_NUM_EXP")
	private Long acreedorNumExp;*/

	@Column(name = "PDV_ACREEDOR_NOMBRE")
	private String acreedorNombre;
	
	@Column(name = "PDV_ACREEDOR_CODIGO")
	private Long acreedorId;
	
	@Column(name = "PDV_ACREEDOR_NIF")
	private String acreedorNif;
	
	@Column(name = "PDV_ACREEDOR_DIR")
	private String acreedorDir;
	
	@Column(name = "PDV_IMPORTE_DEUDA")
	private Float importeDeuda;

	
	
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

/*	public DDTipoProductoFinanciero getTipoProductoFinanciero() {
		return tipoProductoFinanciero;
	}

	public void setTipoProductoFinanciero(
			DDTipoProductoFinanciero tipoProductoFinanciero) {
		this.tipoProductoFinanciero = tipoProductoFinanciero;
	}

	public Long getAcreedorNumExp() {
		return acreedorNumExp;
	}

	public void setAcreedorNumExp(Long acreedorNumExp) {
		this.acreedorNumExp = acreedorNumExp;
	}*/
	
	public Long getAcreedorId() {
		return acreedorId;
	}

	public void setAcreedorId(Long acreedorId) {
		this.acreedorId = acreedorId;
	}

	public String getAcreedorNif() {
		return acreedorNif;
	}

	public void setAcreedorNif(String acreedorNif) {
		this.acreedorNif = acreedorNif;
	}

	public String getAcreedorDir() {
		return acreedorDir;
	}

	public void setAcreedorDir(String acreedorDir) {
		this.acreedorDir = acreedorDir;
	}

	public Float getImporteDeuda() {
		return importeDeuda;
	}

	public void setImporteDeuda(Float importeDeuda) {
		this.importeDeuda = importeDeuda;
	}

	public String getAcreedorNombre() {
		return acreedorNombre;
	}

	public void setAcreedorNombre(String acreedorNombre) {
		this.acreedorNombre = acreedorNombre;
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
