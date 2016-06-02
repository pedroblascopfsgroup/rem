package es.capgemini.pfs.politica.model;

import java.io.Serializable;
import java.util.Collections;
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
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que representa el ciclo de marcado de una politica con todas sus políticas (una por estado, prepolítica, CE, RE, DC, Vigente).
 * @author Pablo Jiménez
*/
@Entity
@Table(name = "CMP_CICLO_MARCADO_POLITICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class CicloMarcadoPolitica implements Auditable, Serializable {

    private static final long serialVersionUID = 1388934242934118491L;

    @Id
    @Column(name = "CMP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloMarcadoPoliticaGenerator")
    @SequenceGenerator(name = "CicloMarcadoPoliticaGenerator", sequenceName = "S_CMP_CICLO_MARCADO_POLITICA")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @ManyToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @OneToMany(mappedBy = "cicloMarcadoPolitica")
    @JoinColumn(name = "CMP_ID")
    @OrderBy("id ASC")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Politica> politicas;

    @OneToOne(mappedBy = "cicloMarcadoPolitica", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "CMP_ID")
    private AnalisisPersonaPolitica analisisPersonaPolitica;

    @Embedded
    private Auditoria auditoria;

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
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param politicas the politicas to set
     */
    public void setPoliticas(List<Politica> politicas) {
        this.politicas = politicas;
    }

    /**
     * @return the politicas
     */
    public List<Politica> getPoliticas() {
        return politicas;
    }

    /**
     * @return Politica
     */
    public Politica getUltimaPolitica() {
        if (politicas == null || politicas.size() == 0) { return null; }

        Collections.sort(politicas, new Politica().getEstadoItinerarioComparator());
        
        return politicas.get(politicas.size() - 1);
    }

    /**
     * @param analisisPersonaPolitica the analisisPersonaPolitica to set
     */
    public void setAnalisisPersonaPolitica(AnalisisPersonaPolitica analisisPersonaPolitica) {
        this.analisisPersonaPolitica = analisisPersonaPolitica;
    }

    /**
     * @return the analisisPersonaPolitica
     */
    public AnalisisPersonaPolitica getAnalisisPersonaPolitica() {
        return analisisPersonaPolitica;
    }
}
