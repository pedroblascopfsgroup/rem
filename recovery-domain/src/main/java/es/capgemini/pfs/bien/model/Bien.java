package es.capgemini.pfs.bien.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;
import javax.validation.constraints.Max;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Entidad Bien.
 */
@Entity
@Table(name = "BIE_BIEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Bien implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "BIE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BienGenerator")
    @SequenceGenerator(name = "BienGenerator", sequenceName = "S_BIE_BIEN")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_TBI_ID")
    private DDTipoBien tipoBien;

    @Max(value = 100, message = "bienes.validacion.participacionMenor100")
    @NotNull(message = "bienes.validacion.participacionNoNulo")
    @Column(name = "BIE_PARTICIPACION")
    private Integer participacion;

    @Column(name = "BIE_VALOR_ACTUAL")
    private BigDecimal valorActual;

    @Column(name = "BIE_IMPORTE_CARGAS")
    private BigDecimal importeCargas;

    @Column(name = "BIE_SUPERFICIE")
    private BigDecimal superficie;

    @Column(name = "BIE_POBLACION")
    private String poblacion;

    @Column(name = "BIE_DATOS_REGISTRALES")
    private String datosRegistrales;

    @Column(name = "BIE_REFERENCIA_CATASTRAL")
    private String referenciaCatastral;

    @Column(name = "BIE_DESCRIPCION")
    private String descripcionBien;

    @Column(name = "BIE_FECHA_VERIFICACION")
    private Date fechaVerificacion;

    @ManyToMany(mappedBy = "bienes")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Persona> personas;

    @OneToOne(mappedBy = "bien")
    @JoinColumn(name = "BIE_ID")
    private EmbargoProcedimiento embargoProcedimiento;

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
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the tipoBien
     */
    public DDTipoBien getTipoBien() {
        return tipoBien;
    }

    /**
     * @param tipoBien
     *            the tipoBien to set
     */
    public void setTipoBien(DDTipoBien tipoBien) {
        this.tipoBien = tipoBien;
    }

    /**
     * @return the participacion
     */
    public Integer getParticipacion() {
        return participacion;
    }

    /**
     * @param participacion
     *            the participacion to set
     */
    public void setParticipacion(Integer participacion) {
        this.participacion = participacion;
    }

    /**
     * @return the valorActual
     */
    public BigDecimal getValorActual() {
        return valorActual;
    }

    /**
     * @param valorActual
     *            the valorActual to set
     */
    public void setValorActual(BigDecimal valorActual) {
        this.valorActual = valorActual;
    }

    /**
     * @return the importeCargas
     */
    public BigDecimal getImporteCargas() {
        return importeCargas;
    }

    /**
     * @param importeCargas
     *            the importeCargas to set
     */
    public void setImporteCargas(BigDecimal importeCargas) {
        this.importeCargas = importeCargas;
    }

    /**
     * @return the superficie
     */
    public BigDecimal getSuperficie() {
        return superficie;
    }

    /**
     * @param superficie
     *            the superficie to set
     */
    public void setSuperficie(BigDecimal superficie) {
        this.superficie = superficie;
    }

    /**
     * @return the poblacion
     */
    public String getPoblacion() {
        return poblacion;
    }

    /**
     * @param poblacion
     *            the poblacion to set
     */
    public void setPoblacion(String poblacion) {
        this.poblacion = poblacion;
    }

    /**
     * @return the datosRegistrales
     */
    public String getDatosRegistrales() {
        return datosRegistrales;
    }

    /**
     * @param datosRegistrales
     *            the datosRegistrales to set
     */
    public void setDatosRegistrales(String datosRegistrales) {
        this.datosRegistrales = datosRegistrales;
    }

    /**
     * @return the referenciaCatastral
     */
    public String getReferenciaCatastral() {
        return referenciaCatastral;
    }

    /**
     * @param referenciaCatastral
     *            the referenciaCatastral to set
     */
    public void setReferenciaCatastral(String referenciaCatastral) {
        this.referenciaCatastral = referenciaCatastral;
    }

    /**
     * @return the descripcionBien
     */
    public String getDescripcionBien() {
        return descripcionBien;
    }

    /**
     * @param descripcionBien
     *            the descripcionBien to set
     */
    public void setDescripcionBien(String descripcionBien) {
        this.descripcionBien = descripcionBien;
    }

    /**
     * @return the personas
     */
    public Set<Persona> getPersonas() {
        return personas;
    }

    /**
     * @param personas
     *            the personas to set
     */
    public void setPersonas(Set<Persona> personas) {
        this.personas = personas;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the fechaVerificacion
     */
    public Date getFechaVerificacion() {
        return fechaVerificacion;
    }

    /**
     * @param fechaVerificacion
     *            the fechaVerificacion to set
     */
    public void setFechaVerificacion(Date fechaVerificacion) {
        this.fechaVerificacion = fechaVerificacion;
    }

    /**
     * getEmbargoProcedimiento.
     * @return EmbargoProcedimiento
     */
    public EmbargoProcedimiento getEmbargoProcedimiento() {
        return embargoProcedimiento;
    }

    /**
     * setEmbargoProcedimiento.
     * @param embargoProcedimiento embargoProcedimiento
     */
    public void setEmbargoProcedimiento(EmbargoProcedimiento embargoProcedimiento) {
        this.embargoProcedimiento = embargoProcedimiento;
    }

}
