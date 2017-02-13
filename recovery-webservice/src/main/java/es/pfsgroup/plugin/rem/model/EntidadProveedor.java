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

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoColaboracion;


/**
 * Modelo que gestiona la relación de proveedores con las entidades propietarias de los activos.
 *  
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_ETP_ENTIDAD_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EntidadProveedor implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ETP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EntidadProveedorGenerator")
    @SequenceGenerator(name = "EntidadProveedorGenerator", sequenceName = "S_ACT_ETP_ENTIDAD_PROVEEDOR")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
	
    @ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;
    
    @ManyToOne
    @JoinColumn(name = "DD_TCL_ID")
    private DDTipoColaboracion tipoColaboracion;
    
    @Column(name = "ETP_FECHA_CONTRATO")
	private Date fechaContrato;
    
    @Column(name = "ETP_FECHA_INICIO")
  	private Date fechaInicio;
    
    @Column(name = "ETP_FECHA_FIN")
  	private Date fechaFin;
    
	@Column(name = "ETP_ESTADO")
	private String estado;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public DDTipoColaboracion getTipoColaboracion() {
		return tipoColaboracion;
	}

	public void setTipoColaboracion(DDTipoColaboracion tipoColaboracion) {
		this.tipoColaboracion = tipoColaboracion;
	}

	public Date getFechaContrato() {
		return fechaContrato;
	}

	public void setFechaContrato(Date fechaContrato) {
		this.fechaContrato = fechaContrato;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
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
