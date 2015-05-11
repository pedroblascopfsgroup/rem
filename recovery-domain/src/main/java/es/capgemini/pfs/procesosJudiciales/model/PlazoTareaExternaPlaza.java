package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la entidad TEX_TAREA_EXTERNA.
 *
 * @author pajimene
 *
 */
@Entity
@Table(name = "DD_PTP_PLAZOS_TAREAS_PLAZAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class PlazoTareaExternaPlaza implements Serializable, Auditable {

    /**
     * Serial version.
     */
    private static final long serialVersionUID = -3753995353825072584L;

    /**
     * Primary Key.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PlazoTareaExternaPlazaGenerator")
    @SequenceGenerator(name = "PlazoTareaExternaPlazaGenerator", sequenceName = "S_DD_PTP_PLAZOS_TAREAS_PLAZAS")
    @Column(name = "DD_PTP_ID")
    private Long id;

    /**
     * ID tarea procedimiento.
     */
    @Column(name = "TAP_ID")
    private Long idTareaProcedimiento;

    /**
     * Id tipo de juzgado.
     */
    @Column(name = "DD_JUZ_ID")
    private Long idTipoJuzgado;

    /**
     * id Tipo de plaza.
     */
    @Column(name = "DD_PLA_ID")
    private Long idTipoPlaza;

    /**
     * Id script de plazo.
     */
    @Column(name = "DD_PTP_PLAZO_SCRIPT")
    private String scriptPlazo;

    /**
     * Objeto embebido de auditoria.
     */
    @Embedded
    private Auditoria auditoria;

    /**
     * Objeto versión.
     */
    @Version
    private Integer version;

    /**
     * getter.
     * @return sting
     */
    public String getScriptPlazo() {
        return scriptPlazo;
    }

    /**
     * setteer.
     * @param scriptPlazo script
     */
    public void setScriptPlazo(final String scriptPlazo) {
        this.scriptPlazo = scriptPlazo;
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
    public void setId(final Long id) {
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
    public void setAuditoria(final Auditoria auditoria) {
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
    public void setVersion(final Integer version) {
        this.version = version;
    }

    /**
     * @param idTareaProcedimiento the idTareaProcedimiento to set
     */
    public void setIdTareaProcedimiento(final Long idTareaProcedimiento) {
        this.idTareaProcedimiento = idTareaProcedimiento;
    }

    /**
     * @return the idTareaProcedimiento
     */
    public Long getIdTareaProcedimiento() {
        return idTareaProcedimiento;
    }

    /**
     * @param idTipoJuzgado the idTipoJuzgado to set
     */
    public void setIdTipoJuzgado(final Long idTipoJuzgado) {
        this.idTipoJuzgado = idTipoJuzgado;
    }

    /**
     * @return the idTipoJuzgado
     */
    public Long getIdTipoJuzgado() {
        return idTipoJuzgado;
    }

    /**
     * @param idTipoPlaza the idTipoPlaza to set
     */
    public void setIdTipoPlaza(final Long idTipoPlaza) {
        this.idTipoPlaza = idTipoPlaza;
    }

    /**
     * @return the idTipoPlaza
     */
    public Long getIdTipoPlaza() {
        return idTipoPlaza;
    }

}
