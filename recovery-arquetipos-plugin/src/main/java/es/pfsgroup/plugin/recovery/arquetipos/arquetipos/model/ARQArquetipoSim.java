package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model;

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

import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.ruleengine.state.RuleEndState;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

@Entity
@Table(name = "ARQ_ARQUETIPOS_SIM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ARQArquetipoSim implements Serializable, Auditable, RuleEndState{

	private static final long serialVersionUID = -995141458489599512L;
	
    public static final String ARQUETIPO_ID_KEY = "arquetipoId";
    
    public static final String ARQUETIPO_GEN_RECOBRO = "GENERICO EXPEDIENTE DE RECOBRO";

    @Id
    @Column(name = "ARQ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ArquetipoGenerator")
    @SequenceGenerator(name = "ArquetipoGenerator", sequenceName = "S_ARQ_ARQUETIPOS_SIM")
    private Long id;

    @Embedded
    private Auditoria auditoria;

    @OneToOne
    @JoinColumn(name = "ITI_ID")
    private Itinerario itinerario;

    @OneToOne
    @JoinColumn(name = "RD_ID")
    private RuleDefinition rule;

    @Column(name = "ARQ_NOMBRE")
    private String nombre;

    @Column(name = "ARQ_PRIORIDAD")
    private Long prioridad;

    @Column(name = "ARQ_GESTION")
    private Boolean gestion;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the itinerario
     */
    public Itinerario getItinerario() {
        return itinerario;
    }

    /**
     * @param itinerario the itinerario to set
     */
    public void setItinerario(Itinerario itinerario) {
        this.itinerario = itinerario;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the rule
     */
    public String getRuleDefinition() {
        if (rule != null) { return rule.getRuleDefinition(); }
        return null;
    }

    /**
     * @return rule 
     */
    public RuleDefinition getRule() {
        return rule;
    }

    /**
     * @param rule the rule to set
     */
    public void setRule(RuleDefinition rule) {
        this.rule = rule;
    }

    /**
     * @return the prioridad
     */
    public Long getPrioridad() {
        return prioridad;
    }

    /**
     * @param prioridad the prioridad to set
     */
    public void setPrioridad(Long prioridad) {
        this.prioridad = prioridad;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getName() {
        return nombre;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public long getPriority() {
        return getPrioridad();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getValue() {
        return id.toString();
    }

    /**
     * @param gestion the gestion to set
     */
    public void setGestion(Boolean gestion) {
        this.gestion = gestion;
    }

    /**
     * Indica si el arquetipo debe generar o no debe generar una gestión
     * @return the gestion
     */
    public Boolean getGestion() {
        return gestion;
    }
	
	@OneToOne
	@JoinColumn(name="MRA_ID")
	private ARQModeloArquetipo modeloArquetipo;
	
	@Column(name="ARQ_NIVEL")
	private Long nivel;
	
	@Column(name="ARQ_PLAZO_DISPARO")
	private Long plazoDisparo;
	
	@OneToOne
	@JoinColumn(name="DD_TSN_ID")
	private DDTipoSaltoNivel tipoSaltoNivel;

	public ARQModeloArquetipo getModeloArquetipo() {
		return modeloArquetipo;
	}

	public void setModeloArquetipo(ARQModeloArquetipo modeloArquetipo) {
		this.modeloArquetipo = modeloArquetipo;
	}

	public Long getNivel() {
		return nivel;
	}

	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}

	public Long getPlazoDisparo() {
		return plazoDisparo;
	}

	public void setPlazoDisparo(Long plazoDisparo) {
		this.plazoDisparo = plazoDisparo;
	}

	public DDTipoSaltoNivel getTipoSaltoNivel() {
		return tipoSaltoNivel;
	}

	public void setTipoSaltoNivel(DDTipoSaltoNivel tipoSaltoNivel) {
		this.tipoSaltoNivel = tipoSaltoNivel;
	}
	
	

}
