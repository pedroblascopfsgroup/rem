package es.capgemini.pfs.cobropago.model;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa los Cobros / Pagos de un asunto.
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "CPA_COBROS_PAGOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class CobroPago implements Auditable, Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "CPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CobroPagoGenerator")
    @SequenceGenerator(name = "CobroPagoGenerator", sequenceName = "S_CPA_COBROS_PAGOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @ManyToOne
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne
    @JoinColumn(name = "DD_ECP_ID")
    private DDEstadoCobroPago estado;

    @ManyToOne
    @JoinColumn(name = "DD_SCP_ID")
    private DDSubtipoCobroPago subTipo;

    @Column(name = "CPA_IMPORTE")
    private Float importe;

    @Column(name = "CPA_FECHA")
    private Date fecha;

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
     * @return the asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the estado
     */
    public DDEstadoCobroPago getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(DDEstadoCobroPago estado) {
        this.estado = estado;
    }

    /**
     * @return the subTipo
     */
    public DDSubtipoCobroPago getSubTipo() {
        return subTipo;
    }

    /**
     * @param subTipo the subTipo to set
     */
    public void setSubTipo(DDSubtipoCobroPago subTipo) {
        this.subTipo = subTipo;
    }

    /**
     * @return the importe
     */
    public Float getImporte() {
        return importe;
    }

    /**
     * @param importe the importe to set
     */
    public void setImporte(Float importe) {
        this.importe = importe;
    }

    /**
     * @return the fecha
     */
    public Date getFecha() {
        return fecha;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(Date fecha) {
        this.fecha = fecha;
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

}
