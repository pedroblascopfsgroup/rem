package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;

@Entity
@Table(name = "MRA_REL_MODELO_ARQ" , schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ARQModeloArquetipo implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7991447028104210173L;

	@Id
	@Column(name = "MRA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "modeloArquetipoGenerator")
	@SequenceGenerator(name = "modeloArquetipoGenerator", sequenceName = "S_MRA_REL_MODELO_ARQ")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name="MOA_ID")
	private ARQModelo modelo;
	
	@ManyToOne
	@JoinColumn(name="LIA_ID")
	private ARQListaArquetipo arquetipo;
	
	@Column(name="MRA_NIVEL")
	private Long nivel;
	
	@ManyToOne
	@JoinColumn(name="ITI_ID")
	private Itinerario itinerario;
	
	@Column (name="MRA_PRIORIDAD")
	private Long prioridad;
	
	@Column (name="MRA_PLAZO_DISPARO")
	private Long plazoDisparo;
	
	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;


	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setModelo(ARQModelo modelo) {
		this.modelo = modelo;
	}

	public ARQModelo getModelo() {
		return modelo;
	}

	public void setArquetipo(ARQListaArquetipo arqListaArquetipo) {
		this.arquetipo = arqListaArquetipo;
	}

	public ARQListaArquetipo getArquetipo() {
		return arquetipo;
	}

	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}

	public Long getNivel() {
		return nivel;
	}

	public void setItinerario(Itinerario itinerario) {
		this.itinerario = itinerario;
	}

	public Itinerario getItinerario() {
		return itinerario;
	}

	public void setPrioridad(Long prioridad) {
		this.prioridad = prioridad;
	}

	public Long getPrioridad() {
		return prioridad;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public Long getPlazoDisparo() {
		return plazoDisparo;
	}

	public void setPlazoDisparo(Long plazoDisparo) {
		this.plazoDisparo = plazoDisparo;
	}
}
