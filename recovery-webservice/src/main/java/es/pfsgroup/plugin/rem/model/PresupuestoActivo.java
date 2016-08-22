package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo.ActivoTrabajoPk;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;



/**
 * Modelo que gestiona la información de los presupuestos de los activos..
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PTO_PRESUPUESTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PresupuestoActivo implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;		
	

	 
	@Id
    @Column(name = "PTO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PresupuestoActivoGenerator")
    @SequenceGenerator(name = "PresupuestoActivoGenerator", sequenceName = "S_ACT_PTO_PRESUPUESTO")
    private Long id;	

    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne
    @JoinColumn(name = "EJE_ID")
	private Ejercicio ejercicio;
	
	@Column(name = "PTO_IMPORTE_INICIAL")
	private Double importeInicial;
	
	@Column(name = "PTO_FECHA_ASIGNACION")
	private Date fechaAsignacion;
	
    @OneToMany(mappedBy = "presupuestoActivo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "PTO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<IncrementoPresupuesto> incrementoPresupuesto;
    
	
	
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

	public Ejercicio getEjercicio() {
		return ejercicio;
	}

	public void setEjercicio(Ejercicio ejercicio) {
		this.ejercicio = ejercicio;
	}

	public Double getImporteInicial() {
		return importeInicial;
	}

	public void setImporteInicial(Double importeInicial) {
		this.importeInicial = importeInicial;
	}

	public Date getFechaAsignacion() {
		return fechaAsignacion;
	}

	public void setFechaAsignacion(Date fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
	}

	public List<IncrementoPresupuesto> getIncrementoPresupuesto() {
		return incrementoPresupuesto;
	}

	public void setIncrementoPresupuesto(
			List<IncrementoPresupuesto> incrementoPresupuesto) {
		this.incrementoPresupuesto = incrementoPresupuesto;
	}


	//BARRA ROJA
	public Double getImporteDispuesto() {
		try{
			
			Double total = Double.valueOf(0);
			Activo activo = getActivo();
			
			if(activo != null){
				if(activo.getActivoTrabajos() != null && activo.getActivoTrabajos().size()>0){
					Iterator<ActivoTrabajo> it = activo.getActivoTrabajos().iterator();
					while (it.hasNext()) {
						ActivoTrabajo activoTrabajo = (ActivoTrabajo) it.next();
						if(activoTrabajo.getPrimaryKey().getTrabajo()!= null && activoTrabajo.getPrimaryKey().getTrabajo().getEstado() != null){
							if(activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_PAGADO)){
								total += activoTrabajo.getPrimaryKey().getTrabajo().getImporteTotal();
							}
						}
					}		
				}	
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}	
	}
	
	
	//BARRA AMARILLA
	public Double getImportePendientePago() {
		try{
			
			Double total = Double.valueOf(0);
			Activo activo = getActivo();
			
			if(activo != null){
				if(activo.getActivoTrabajos() != null && activo.getActivoTrabajos().size()>0){
					Iterator<ActivoTrabajo> it = activo.getActivoTrabajos().iterator();
					while (it.hasNext()) {
						ActivoTrabajo activoTrabajo = (ActivoTrabajo) it.next();
						if(activoTrabajo.getPrimaryKey().getTrabajo()!= null && activoTrabajo.getPrimaryKey().getTrabajo().getEstado() != null){
							if(activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_EN_TRAMITE) ||
								activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO) ||
								activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_IMPOSIBLE_OBTENCION) ||
								activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_FALLIDO) ||
								activoTrabajo.getPrimaryKey().getTrabajo().getEstado().getCodigo().equalsIgnoreCase(DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA)){
								total += activoTrabajo.getPrimaryKey().getTrabajo().getImporteTotal();
							}
						}
					}		
				}	
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}	
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
