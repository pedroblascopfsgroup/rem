package es.capgemini.pfs.itinerario.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.politica.model.DDTipoPolitica;

/**
 * Modelo de la tabla de itinerarios.
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "ITI_ITINERARIOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Itinerario implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;
    public static final String ITINERARIO_ID_KEY = "itinerarioId";

    @Id
    @Column(name = "ITI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ItinerarioGenerator")
    @SequenceGenerator(name = "ItinerarioGenerator", sequenceName = "Itinerario_Seq")
    private Long id;

    @Column(name = "ITI_NOMBRE")
    private String nombre;

    @OneToMany(mappedBy = "itinerario")
    @JoinColumn(name = "ITI_ID")
    @OrderBy("estadoItinerario ASC")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Estado> estados; 

    @ManyToOne
    @JoinColumn(name = "DD_TIT_ID")
    private DDTipoItinerario dDtipoItinerario;

    @ManyToOne
    @JoinColumn(name = "DD_AEX_ID ")
    private DDAmbitoExpediente ambitoExpediente;
    
    @ManyToOne
    @JoinColumn(name = "TPL_ID")
    private DDTipoPolitica prePolitica;
    
    @Transient
    private Map<String, Estado> estadosByCodigo;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @param codigo string
     * @return Estado
     */
    public Estado getEstado(String codigo) {
        if (estadosByCodigo == null) {
            estadosByCodigo = new HashMap<String, Estado>();
            for (Estado estado : estados) {
                estadosByCodigo.put(estado.getEstadoItinerario().getCodigo(), estado);
            }
        }
        return estadosByCodigo.get(codigo);
    }

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
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param estados the estados to set
     */
    public void setEstados(List<Estado> estados) {
        this.estados = estados;
    }

    /**
     * @return the estados
     */
    public List<Estado> getEstados() {
        return estados;
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
     * @param dDtipoItinerario the dDtipoItinerario to set
     */
    public void setdDtipoItinerario(DDTipoItinerario dDtipoItinerario) {
        this.dDtipoItinerario = dDtipoItinerario;
    }

    /**
     * @return the dDtipoItinerario
     */
    public DDTipoItinerario getdDtipoItinerario() {
        return dDtipoItinerario;
    }

    /**
     * @param ambitoExpediente the ambitoExpediente to set
     */
    public void setAmbitoExpediente(DDAmbitoExpediente ambitoExpediente) {
        this.ambitoExpediente = ambitoExpediente;
    }

    /**
     * @return the ambitoExpediente
     */
    public DDAmbitoExpediente getAmbitoExpediente() {
        return ambitoExpediente;
    }

	public DDTipoPolitica getPrePolitica() {
		return prePolitica;
	}

	public void setPrePolitica(DDTipoPolitica prePolitica) {
		this.prePolitica = prePolitica;
	}

}
