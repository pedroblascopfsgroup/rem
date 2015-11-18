package es.capgemini.pfs.itinerario.model;

import java.io.Serializable;
import java.util.List;

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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Estados de los itinerarios.
 */
@Entity
@Table(name = "EST_ESTADOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Estado implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "EST_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EstadoGenerator")
    @SequenceGenerator(name = "EstadoGenerator", sequenceName = "S_EST_ESTADOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ITI_ID")
    private Itinerario itinerario;

    @Column(name = "EST_PLAZO")
    private Long plazo;

    @ManyToOne
    @JoinColumn(name = "DD_EST_ID")
    @OrderBy("orden asc")
    private DDEstadoItinerario estadoItinerario;

    @ManyToOne(targetEntity = es.capgemini.pfs.users.domain.Perfil.class)
    @JoinColumn(name = "PEF_ID_GESTOR")
    private Perfil gestorPerfil;

    @ManyToOne
    @JoinColumn(name = "PEF_ID_SUPERVISOR")
    private Perfil supervisor;

    @Column(name = "EST_AUTOMATICO")
    private Boolean automatico;

    @ManyToOne
    @JoinColumn(name = "TEL_ID")
    private EstadoTelecobro estadoTelecobro;

    @ManyToOne
    @JoinColumn(name = "DCA_ID")
    private DecisionComiteAutomatico decisionComiteAutomatico;

    @Column(name = "EST_TELECOBRO")
    private Boolean telecobro;

    @OneToMany(mappedBy = "estadoItinerario", fetch = FetchType.LAZY)
    @JoinColumn(name = "EST_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ReglasVigenciaPolitica> reglasVigenciaPolitica;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return estadoItinerario.getCodigo();
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
     * @return the plazo
     */
    public Long getPlazo() {
        return plazo;
    }

    /**
     * @param plazo the plazo to set
     */
    public void setPlazo(Long plazo) {
        this.plazo = plazo;
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
     * @param itinerario the itinerario to set
     */
    public void setItinerario(Itinerario itinerario) {
        this.itinerario = itinerario;
    }

    /**
     * @return the itinerario
     */
    public Itinerario getItinerario() {
        return itinerario;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
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
     * @return the gestor
     */
    public Perfil getGestorPerfil() {
        return gestorPerfil;
    }

    /**
     * @param gestorPerfil the gestor to set
     */
    public void setGestorPerfil(Perfil gestorPerfil) {
        this.gestorPerfil = gestorPerfil;
    }

    /**
     * @return the supervisor
     */
    public Perfil getSupervisor() {
        return supervisor;
    }

    /**
     * @param supervisor the supervisor to set
     */
    public void setSupervisor(Perfil supervisor) {
        this.supervisor = supervisor;
    }

    /**
     * @return the automatico
     */
    public Boolean getAutomatico() {
        return automatico;
    }

    /**
     * @param automatico the automatico to set
     */
    public void setAutomatico(Boolean automatico) {
        this.automatico = automatico;
    }

    /**
     * @return the estadoTelecobro
     */
    public EstadoTelecobro getEstadoTelecobro() {
        return estadoTelecobro;
    }

    /**
     * @param estadoTelecobro the estadoTelecobro to set
     */
    public void setEstadoTelecobro(EstadoTelecobro estadoTelecobro) {
        this.estadoTelecobro = estadoTelecobro;
    }

    /**
     * @return the telecobro
     */
    public Boolean getTelecobro() {
        return telecobro;
    }

    /**
     * @param telecobro the telecobro to set
     */
    public void setTelecobro(Boolean telecobro) {
        this.telecobro = telecobro;
    }

    /**
     * @return the decisionComiteAutomatico
     */
    public DecisionComiteAutomatico getDecisionComiteAutomatico() {
        return decisionComiteAutomatico;
    }

    /**
     * @param decisionComiteAutomatico the decisionComiteAutomatico to set
     */
    public void setDecisionComiteAutomatico(DecisionComiteAutomatico decisionComiteAutomatico) {
        this.decisionComiteAutomatico = decisionComiteAutomatico;
    }

    /**
     * @param reglasVigenciaPolitica the reglasVigenciaPolitica to set
     */
    public void setReglasVigenciaPolitica(List<ReglasVigenciaPolitica> reglasVigenciaPolitica) {
        this.reglasVigenciaPolitica = reglasVigenciaPolitica;
    }

    /**
     * @return the reglasVigenciaPolitica
     */
    public List<ReglasVigenciaPolitica> getReglasVigenciaPolitica() {
        return reglasVigenciaPolitica;
    }

}
