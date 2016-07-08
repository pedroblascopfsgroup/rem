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
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoProveedor;



/**
 * Modelo que gestiona la información de los recargos de los proveedores
 *
 */
@Entity
@Table(name = "ACT_RPV_RECARGOS_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TrabajoRecargosProveedor implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;		

	
	@Id
    @Column(name = "RPV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TrabajoRecargosProveedorGenerator")
    @SequenceGenerator(name = "TrabajoRecargosProveedorGenerator", sequenceName = "S_ACT_RPV_RECARGOS_PROVEEDOR")
    private Long id;	
   
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
    
    @ManyToOne
    @JoinColumn(name = "DD_TRP_ID")
    private DDTipoRecargoProveedor tipoRecargo;
    
    @ManyToOne
    @JoinColumn(name = "DD_TCC_ID")
    private DDTipoCalculo tipoCalculo;
    
    @Column(name="RPV_IMPORTE_CALCULO")
    private Double importeCalculo;
    
    @Column(name="RPV_IMPORTE_FINAL")
    private Double importeFinal;	
	
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

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public DDTipoRecargoProveedor getTipoRecargo() {
		return tipoRecargo;
	}

	public void setTipoRecargo(DDTipoRecargoProveedor tipoRecargo) {
		this.tipoRecargo = tipoRecargo;
	}

	public DDTipoCalculo getTipoCalculo() {
		return tipoCalculo;
	}

	public void setTipoCalculo(DDTipoCalculo tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
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
	
	