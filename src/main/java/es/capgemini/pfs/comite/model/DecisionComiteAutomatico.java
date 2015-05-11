package es.capgemini.pfs.comite.model;

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

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Clase que representa la configuracion para la decision de comite automatica.
 */
@Entity
@Table(name = "DCA_DECISION_COMITE_AUTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DecisionComiteAutomatico implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = 3501189579530363285L;

    @Id
    @Column(name = "DCA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DecisionComiteAutomaticoGenerator")
    @SequenceGenerator(name = "DecisionComiteAutomaticoGenerator", sequenceName = "S_DCA_DECISION_COMITE_AUTO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "GAS_ID")
    private GestorDespacho gestor;

    @ManyToOne
    @JoinColumn(name = "SUP_ID")
    private GestorDespacho supervisor;

    @ManyToOne
    @JoinColumn(name = "COM_ID")
    private Comite comite;

    @ManyToOne
    @JoinColumn(name = "DD_TAC_ID")
    private DDTipoActuacion tipoActuacion;

    @ManyToOne
    @JoinColumn(name = "DD_TRE_ID")
    private DDTipoReclamacion tipoReclamacion;

    @ManyToOne
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;

    @Column(name = "DCA_PORCENTAJE_RECUPERACION")
    private Integer porcentajeRecuperacion;

    @Column(name = "DCA_PLAZO_RECUPERACION")
    private Integer plazoRecuperacion;

    @Column(name = "DCA_ACEPTACION_AUTO")
    private Boolean aceptacionAutomatico;

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
     * @return the gestor
     */
    public GestorDespacho getGestor() {
        return gestor;
    }

    /**
     * @param gestor the gestor to set
     */
    public void setGestor(GestorDespacho gestor) {
        this.gestor = gestor;
    }

    /**
     * @return the supervisor
     */
    public GestorDespacho getSupervisor() {
        return supervisor;
    }

    /**
     * @param supervisor the supervisor to set
     */
    public void setSupervisor(GestorDespacho supervisor) {
        this.supervisor = supervisor;
    }

    /**
     * @return the comite
     */
    public Comite getComite() {
        return comite;
    }

    /**
     * @param comite the comite to set
     */
    public void setComite(Comite comite) {
        this.comite = comite;
    }

    /**
     * @return the tipoActuacion
     */
    public DDTipoActuacion getTipoActuacion() {
        return tipoActuacion;
    }

    /**
     * @param tipoActuacion the tipoActuacion to set
     */
    public void setTipoActuacion(DDTipoActuacion tipoActuacion) {
        this.tipoActuacion = tipoActuacion;
    }

    /**
     * @return the tipoProcedimiento
     */
    public TipoProcedimiento getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    /**
     * @param tipoProcedimiento the tipoProcedimiento to set
     */
    public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }

    /**
     * @return the porcentajeRecuperacion
     */
    public Integer getPorcentajeRecuperacion() {
        return porcentajeRecuperacion;
    }

    /**
     * @param porcentajeRecuperacion the porcentajeRecuperacion to set
     */
    public void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
        this.porcentajeRecuperacion = porcentajeRecuperacion;
    }

    /**
     * @return the plazoRecuperacion
     */
    public Integer getPlazoRecuperacion() {
        return plazoRecuperacion;
    }

    /**
     * @param plazoRecuperacion the plazoRecuperacion to set
     */
    public void setPlazoRecuperacion(Integer plazoRecuperacion) {
        this.plazoRecuperacion = plazoRecuperacion;
    }

    /**
     * @return the aceptacionAutomatico
     */
    public Boolean getAceptacionAutomatico() {
        return aceptacionAutomatico;
    }

    /**
     * @param aceptacionAutomatico the aceptacionAutomatico to set
     */
    public void setAceptacionAutomatico(Boolean aceptacionAutomatico) {
        this.aceptacionAutomatico = aceptacionAutomatico;
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
     * @return the tipoReclamacion
     */
    public DDTipoReclamacion getTipoReclamacion() {
        return tipoReclamacion;
    }

    /**
     * @param tipoReclamacion the tipoReclamacion to set
     */
    public void setTipoReclamacion(DDTipoReclamacion tipoReclamacion) {
        this.tipoReclamacion = tipoReclamacion;
    }
}
