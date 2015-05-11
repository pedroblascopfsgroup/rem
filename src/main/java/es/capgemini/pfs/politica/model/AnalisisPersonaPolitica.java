package es.capgemini.pfs.politica.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la tabla APP_ANALISIS_PERSONA_POLITICA.
 * @author pamuller
 *
 */
@Entity
@Table(name = "APP_ANALISIS_PERSONA_POLITICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisPersonaPolitica implements Auditable, Serializable {

    private static final long serialVersionUID = -473258219653560808L;

    @Id
    @Column(name = "APP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisPersonaPoliticaGenerator")
    @SequenceGenerator(name = "AnalisisPersonaPoliticaGenerator", sequenceName = "S_APP_ANALISIS_PER_POL")
    private Long id;

    @OneToOne
    @JoinColumn(name = "CMP_ID")
    private CicloMarcadoPolitica cicloMarcadoPolitica;

    @Column(name = "APP_COMENTARIO_GESTOR")
    private String comentarioGestor;

    @Column(name = "APP_COMENTARIO_SUPERVISOR")
    private String comentarioSupervisor;

    @Column(name = "APP_OBS_GEST_REALIZADAS")
    private String observacionesGestionesRealizadas;

    @OneToMany(mappedBy = "analisisPersonaPolitica", cascade = CascadeType.ALL)
    @JoinColumn(name = "APP_ID")
    private List<AnalisisParcelaPersona> analisisParcelasPersonas;

    @OneToMany(mappedBy = "analisisPersonaPolitica", cascade = CascadeType.ALL)
    @JoinColumn(name = "APP_ID")
    private List<AnalisisPersonaOperacion> analisisPersonaOperacion;

    @OneToMany
    @JoinTable(name = "APP_TIG", joinColumns = @JoinColumn(name = "APP_ID", referencedColumnName = "APP_ID"), inverseJoinColumns = @JoinColumn(name = "DD_TIG_ID", referencedColumnName = "DD_TIG_ID"))
    private List<DDTipoGestion> gestionesRealizadas;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

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
     * @return the comentarioGestor
     */
    public String getComentarioGestor() {
        return comentarioGestor;
    }

    /**
     * @param comentarioGestor the comentarioGestor to set
     */
    public void setComentarioGestor(String comentarioGestor) {
        this.comentarioGestor = comentarioGestor;
    }

    /**
     * @return the comentarioSupervisor
     */
    public String getComentarioSupervisor() {
        return comentarioSupervisor;
    }

    /**
     * @param comentarioSupervisor the comentarioSupervisor to set
     */
    public void setComentarioSupervisor(String comentarioSupervisor) {
        this.comentarioSupervisor = comentarioSupervisor;
    }

    /**
     * @return the observacionesGestionesRealizadas
     */
    public String getObservacionesGestionesRealizadas() {
        return observacionesGestionesRealizadas;
    }

    /**
     * @param observacionesGestionesRealizadas the observacionesGestionesRealizadas to set
     */
    public void setObservacionesGestionesRealizadas(String observacionesGestionesRealizadas) {
        this.observacionesGestionesRealizadas = observacionesGestionesRealizadas;
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
     * @return the analisisParcelasPersonas
     */
    public List<AnalisisParcelaPersona> getAnalisisParcelasPersonas() {
        return analisisParcelasPersonas;
    }

    /**
     * @param analisisParcelasPersonas the analisisParcelasPersonas to set
     */
    public void setAnalisisParcelasPersonas(List<AnalisisParcelaPersona> analisisParcelasPersonas) {
        this.analisisParcelasPersonas = analisisParcelasPersonas;
    }

    /**
     * @return the analisisPersonaOperacion
     */
    public List<AnalisisPersonaOperacion> getAnalisisPersonaOperacion() {
        return analisisPersonaOperacion;
    }

    /**
     * @param analisisPersonaOperacion the analisisPersonaOperacion to set
     */
    public void setAnalisisPersonaOperacion(List<AnalisisPersonaOperacion> analisisPersonaOperacion) {
        this.analisisPersonaOperacion = analisisPersonaOperacion;
    }

    /**
     * @return the gestionesRealizadas
     */
    public List<DDTipoGestion> getGestionesRealizadas() {
        return gestionesRealizadas;
    }

    /**
     * @param gestionesRealizadas the gestionesRealizadas to set
     */
    public void setGestionesRealizadas(List<DDTipoGestion> gestionesRealizadas) {
        this.gestionesRealizadas = gestionesRealizadas;
    }

    /**
     * @param cicloMarcadoPolitica the cicloMarcadoPolitica to set
     */
    public void setCicloMarcadoPolitica(CicloMarcadoPolitica cicloMarcadoPolitica) {
        this.cicloMarcadoPolitica = cicloMarcadoPolitica;
    }

    /**
     * @return the cicloMarcadoPolitica
     */
    public CicloMarcadoPolitica getCicloMarcadoPolitica() {
        return cicloMarcadoPolitica;
    }

}
