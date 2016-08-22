package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
 * Modelo que gestiona la informacion de la calidad de los solados de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_SOL_SOLADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSolado implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SOL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSoladoGenerator")
    @SequenceGenerator(name = "ActivoSoladoGenerator", sequenceName = "S_ACT_SOL_SOLADO")
    private Long id;
    				
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "SOL_TARIMA_FLOTANTE")
    private Integer tarimaFlotante;   
	
	@Column(name = "SOL_PARQUE")
	private Integer parque;
	 
	@Column(name = "SOL_MARMOL")
	private Integer soladoMarmol;
	
	@Column(name = "SOL_PLAQUETA")
	private Integer plaqueta;
	
	@Column(name = "SOL_SOLADO_OTROS")
	private String soladoOtros;

	
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

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public Integer getTarimaFlotante() {
		return tarimaFlotante;
	}

	public void setTarimaFlotante(Integer tarimaFlotante) {
		this.tarimaFlotante = tarimaFlotante;
	}

	public Integer getParque() {
		return parque;
	}

	public void setParque(Integer parque) {
		this.parque = parque;
	}

	public Integer getSoladoMarmol() {
		return soladoMarmol;
	}

	public void setSoladoMarmol(Integer soladoMarmol) {
		this.soladoMarmol = soladoMarmol;
	}

	public Integer getPlaqueta() {
		return plaqueta;
	}

	public void setPlaqueta(Integer plaqueta) {
		this.plaqueta = plaqueta;
	}

	public String getSoladoOtros() {
		return soladoOtros;
	}

	public void setSoladoOtros(String soladoOtros) {
		this.soladoOtros = soladoOtros;
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
