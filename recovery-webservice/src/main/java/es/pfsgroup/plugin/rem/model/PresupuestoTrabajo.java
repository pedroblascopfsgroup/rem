package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresupuesto;


/**
 * Modelo que gestiona los presupuestos de los trabajos.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PRT_PRESUPUESTO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PresupuestoTrabajo implements Serializable, Auditable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "PRT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PresupuestoTrabajoGenerator")
    @SequenceGenerator(name = "PresupuestoTrabajoGenerator", sequenceName = "S_ACT_PRT_PRESUPUESTO_TRABAJO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;
	
    @ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;
    
    @ManyToOne
    @JoinColumn(name = "DD_ESP_ID")
    private DDEstadoPresupuesto estadoPresupuesto;
    
    @Column(name = "PRT_IMPORTE")
	private Double importe;
    
    @Column(name = "PRT_IMPORTE_CLIENTE")
	private Double importeCliente;
    
    @Column(name = "PRT_FECHA")
  	private Date fecha;
    
    @Column(name = "PRT_REPARTIR_PROPORCIONAL")
	private Integer repartir;
    
    @Column(name = "PRT_COMENTARIOS")
	private String comentarios;
    
    @Column(name = "PRT_REF_PRESUPUESTO_PROVEEDOR")
	private String refPresupuestoProveedor;
    
    @ManyToOne
    @JoinColumn(name = "PVC_ID")
    private ActivoProveedorContacto proveedorContacto;
    
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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public DDEstadoPresupuesto getEstadoPresupuesto() {
		return estadoPresupuesto;
	}

	public void setEstadoPresupuesto(DDEstadoPresupuesto estadoPresupuesto) {
		this.estadoPresupuesto = estadoPresupuesto;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Integer getRepartir() {
		return repartir;
	}

	public void setRepartir(Integer repartir) {
		this.repartir = repartir;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
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

	public String getRefPresupuestoProveedor() {
		return refPresupuestoProveedor;
	}

	public void setRefPresupuestoProveedor(String refPresupuestoProveedor) {
		this.refPresupuestoProveedor = refPresupuestoProveedor;
	}

	public ActivoProveedorContacto getProveedorContacto() {
		return proveedorContacto;
	}

	public void setProveedorContacto(ActivoProveedorContacto proveedorContacto) {
		this.proveedorContacto = proveedorContacto;
	}

	public Double getImporteCliente() {
		return importeCliente;
	}

	public void setImporteCliente(Double importeCliente) {
		this.importeCliente = importeCliente;
	}

	

}
