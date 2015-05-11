package es.capgemini.pfs.embargoProcedimiento.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;

/**
 * CREATE TABLE EMP_EMBARGOS_PROCEDIMIENTOS ( EMP_ID NUMBER(16) NOT NULL, CAB_ID
 * NUMBER(16) NOT NULL, PRC_ID NUMBER(16) NOT NULL, EMP_FECHA_SOLICITUD_EMBARGO
 * TIMESTAMP, EMP_FECHA_DECRETO_EMBARGO TIMESTAMP, EMP_FECHA_REGISTRO_EMBARGO
 * TIMESTAMP, EMP_FECHA_ADJUDICACION_EMBARGO TIMESTAMP.
 **/
@Entity
@Table(name = "EMP_EMBARGOS_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class EmbargoProcedimiento implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = 5414882878147166023L;

    @Id
    @Column(name = "EMP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EmbargoProcedimientoGenerator")
    @SequenceGenerator(name = "EmbargoProcedimientoGenerator", sequenceName = "S_EMP_EMBARGOS_PROCEDIMIENTOS")
    private Long id;

    @Column(name = "EMP_FECHA_SOLICITUD_EMBARGO")
    private Date fechaSolicitud;
    @Column(name = "EMP_FECHA_DECRETO_EMBARGO")
    private Date fechaDecreto;
    @Column(name = "EMP_FECHA_REGISTRO_EMBARGO")
    private Date fechaRegistro;
    @Column(name = "EMP_FECHA_ADJUDICACION_EMBARGO")
    private Date fechaAdjudicacion;

    @Column(name = "EMP_IMPORTE_AVAL")
    private Float importeAval;
    @Column(name = "EMP_FECHA_AVAL")
    private Date fechaAval;
    @Column(name = "EMP_IMPORTE_TASACION")
    private Float importeTasacion;
    @Column(name = "EMP_FECHA_TASACION")
    private Date fechaTasacion;
    @Column(name = "EMP_IMPORTE_ADJUDICACION")
    private Float importeAdjudicacion;
    @Column(name = "EMP_IMPORTE_VALOR")
    private Float importeValor;
    @Column(name = "EMP_LETRA")
    private String letra;

    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @OneToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "BIE_ID")
    private Bien bien;

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
     * @return the fechaSolicitud
     */
    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }

    /**
     * @param fechaSolicitud the fechaSolicitud to set
     */
    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    /**
     * @return the fechaDecreto
     */
    public Date getFechaDecreto() {
        return fechaDecreto;
    }

    /**
     * @param fechaDecreto the fechaDecreto to set
     */
    public void setFechaDecreto(Date fechaDecreto) {
        this.fechaDecreto = fechaDecreto;
    }

    /**
     * @return the fechaRegistro
     */
    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    /**
     * @param fechaRegistro the fechaRegistro to set
     */
    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    /**
     * @return the fechaAdjudicacion
     */
    public Date getFechaAdjudicacion() {
        return fechaAdjudicacion;
    }

    /**
     * @param fechaAdjudicacion the fechaAdjudicacion to set
     */
    public void setFechaAdjudicacion(Date fechaAdjudicacion) {
        this.fechaAdjudicacion = fechaAdjudicacion;
    }

    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the bien
     */
    public Bien getBien() {
        return bien;
    }

    /**
     * @param bien the bien to set
     */
    public void setBien(Bien bien) {
        this.bien = bien;
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
     * @return the importeAval
     */
    public Float getImporteAval() {
        return importeAval;
    }

    /**
     * @param importeAval the importeAval to set
     */
    public void setImporteAval(Float importeAval) {
        this.importeAval = importeAval;
    }

    /**
     * @return the fechaAval
     */
    public Date getFechaAval() {
        return fechaAval;
    }

    /**
     * @param fechaAval the fechaAval to set
     */
    public void setFechaAval(Date fechaAval) {
        this.fechaAval = fechaAval;
    }

    /**
     * @return the importeTasacion
     */
    public Float getImporteTasacion() {
        return importeTasacion;
    }

    /**
     * @param importeTasacion the importeTasacion to set
     */
    public void setImporteTasacion(Float importeTasacion) {
        this.importeTasacion = importeTasacion;
    }

    /**
     * @return the fechaTasacion
     */
    public Date getFechaTasacion() {
        return fechaTasacion;
    }

    /**
     * @param fechaTasacion the fechaTasacion to set
     */
    public void setFechaTasacion(Date fechaTasacion) {
        this.fechaTasacion = fechaTasacion;
    }

    /**
     * @return the importeAdjudicacion
     */
    public Float getImporteAdjudicacion() {
        return importeAdjudicacion;
    }

    /**
     * @param importeAdjudicacion the importeAdjudicacion to set
     */
    public void setImporteAdjudicacion(Float importeAdjudicacion) {
        this.importeAdjudicacion = importeAdjudicacion;
    }

    /**
     * @return the importeValor
     */
    public Float getImporteValor() {
        return importeValor;
    }

    /**
     * @param importeValor the importeValor to set
     */
    public void setImporteValor(Float importeValor) {
        this.importeValor = importeValor;
    }

    /**
     * @return the letra
     */
    public String getLetra() {
        return letra;
    }

    /**
     * @param letra the letra to set
     */
    public void setLetra(String letra) {
        this.letra = letra;
    }

}
