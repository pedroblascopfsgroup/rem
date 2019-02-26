package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
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
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSubdivision;


/**
 * Modelo que gestiona la informacion de las subdivisiones de los activos.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_SDV_SUBDIVISION_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSubdivision implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "SDV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSubdivisionGenerator")
    @SequenceGenerator(name = "ActivoSubdivisionGenerator", sequenceName = "S_ACT_SDV_SUBDIVISION_ACTIVO")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoObraNueva obraNueva;
    
    @Column(name = "SDV_NOMBRE")
	private String nombre;
    
    @ManyToOne
    @JoinColumn(name = "DD_TSB_ID")
    private DDTipoSubdivision tipoSubdivision;   
    
    @Column(name = "SDV_NUM_HABITACIONES")
   	private Integer numHabitaciones;
    
    @Column(name = "SDV_NUM_PLANTAS_INTER")
   	private Integer numPlantas;
    
    @OneToMany(mappedBy = "subdivision", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "SDV_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Activo> activos;
    
    @OneToMany(mappedBy = "subdivision", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "SDV_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoFoto> fotos;
    
    
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

	public ActivoObraNueva getObraNueva() {
		return obraNueva;
	}

	public void setObraNueva(ActivoObraNueva obraNueva) {
		this.obraNueva = obraNueva;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public DDTipoSubdivision getTipoSubdivision() {
		return tipoSubdivision;
	}

	public void setTipoSubdivision(DDTipoSubdivision tipoSubdivision) {
		this.tipoSubdivision = tipoSubdivision;
	}

	public Integer getNumHabitaciones() {
		return numHabitaciones;
	}

	public void setNumHabitaciones(Integer numHabitaciones) {
		this.numHabitaciones = numHabitaciones;
	}

	public Integer getNumPlantas() {
		return numPlantas;
	}

	public void setNumPlantas(Integer numPlantas) {
		this.numPlantas = numPlantas;
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

	public List<Activo> getActivos() {
		return activos;
	}

	public void setActivos(List<Activo> activos) {
		this.activos = activos;
	}

	public List<ActivoFoto> getFotos() {
		return fotos;
	}

	public void setFotos(List<ActivoFoto> fotos) {
		this.fotos = fotos;
	}


}
