package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;



/**
 * Modelo que gestiona la informacion de la distribucion de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
/**
 * @author anahuac
 *
 */
@Entity
@Table(name = "ACT_DIS_DISTRIBUCION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoDistribucion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6913655175961185833L;

	@Id
    @Column(name = "DIS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoDistribucionGenerator")
    @SequenceGenerator(name = "ActivoDistribucionGenerator", sequenceName = "S_ACT_DIS_DISTRIBUCION")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoVivienda vivienda;   

	@Column(name = "DIS_NUM_PLANTA")
	private Integer numPlanta;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPH_ID")
    private DDTipoHabitaculo tipoHabitaculo;   

	@Column(name = "DIS_CANTIDAD")
	private Integer cantidad;
	
	@Column(name = "DIS_SUPERFICIE")
	private Float superficie;
	
	
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

	public ActivoVivienda getVivienda() {
		return vivienda;
	}

	public void setVivienda(ActivoVivienda vivienda) {
		this.vivienda = vivienda;
	}

	public Integer getNumPlanta() {
		return numPlanta;
	}

	public void setNumPlanta(Integer numPlanta) {
		this.numPlanta = numPlanta;
	}

	public DDTipoHabitaculo getTipoHabitaculo() {
		return tipoHabitaculo;
	}

	public void setTipoHabitaculo(DDTipoHabitaculo tipoHabitaculo) {
		this.tipoHabitaculo = tipoHabitaculo;
	}

	public Integer getCantidad() {
		return cantidad;
	}

	public void setCantidad(Integer cantidad) {
		this.cantidad = cantidad;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
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
