package es.pfsgroup.recovery.bpmframework.datosprc.model;

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

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "BPM_GVA_GRUPOS_VALORES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)

public class RecoveryBPMfwkDatosProcedimiento implements Serializable, Auditable {

    private static final long serialVersionUID = 8982292136043831883L;

    @Id
    @Column(name = "BPM_GVA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkDatosProcedimientoGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkDatosProcedimientoGenerator", sequenceName = "S_BPM_GVA_GRUPOS_VALORES")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PRC_ID", nullable = false)
    private Procedimiento procedimiento;

    @Column(name = "BPM_GVA_NOMBRE_GRUPO")
    private String nombreGrupo;

    @Column(name = "BPM_GVA_NOMBRE_DATO")
    private String nombreDato;

    @Column(name = "BPM_GVA_VALOR")
    private String valor;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * Procedimiento al que pertenece el dato
     * 
     * @return
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * Procedimiento al que pertenece el dato
     * 
     * @param procedimiento
     */
    public void setProcedimiento(final Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * Nombre del grupo para el dato
     * 
     * @return
     */
    public String getNombreGrupo() {
        return nombreGrupo;
    }

    /**
     * Nombre del grupo para el dato.
     * 
     * @param nombreGrupo
     */
    public void setNombreGrupo(final String nombreGrupo) {
        this.nombreGrupo = nombreGrupo;
    }

    /**
     * Nombre del dato.
     * 
     * @return
     */
    public String getNombreDato() {
        return nombreDato;
    }

    /**
     * Nombre del dato.
     * 
     * @param nombreDato
     */
    public void setNombreDato(final String nombreDato) {
        this.nombreDato = nombreDato;
    }

    /**
     * Valor que tiene el dato para el procedimiento.
     * 
     * @return
     */
    public String getValor() {
        return valor;
    }

    /**
     * Valor que tiene el dato para el procedimiento.
     * 
     * @param valor
     */
    public void setValor(final String valor) {
        this.valor = valor;
    }

    /**
     * Id
     * 
     * @return
     */
    public Long getId() {
        return id;
    }

    /**
     * Id
     * 
     * @param id
     */
    public void setId(final Long id) {
        this.id = id;
    }

    /**
     * Auditoría.
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Auditoría.
     */
    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Versión.
     * 
     * @return
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Versión.
     * 
     * @param version
     */
    public void setVersion(final Integer version) {
        this.version = version;
    }
}
