package es.capgemini.pfs.telecobro.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Estados de telecobro.
 */
@Entity
@Table(name = "TEL_ESTADO_TELECOBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EstadoTelecobro implements Serializable, Auditable {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787116506547314L;

    @Id
    @Column(name = "TEL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EstadoTelecobroGenerator")
    @SequenceGenerator(name = "EstadoTelecobroGenerator", sequenceName = "S_TEL_ESTADO_TELECOBRO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PTE_ID")
    private ProveedorTelecobro proveedor;

    @Column(name = "TEL_PLAZO_INI")
    private Long plazoInicial;

    @Column(name = "TEL_PLAZO_FIN")
    private Long plazoFinal;

    @Column(name = "TEL_DIAS_ANTELACION")
    private Long diasAntelacion;

    @Column(name = "TEL_PLAZO_RESPUESTA")
    private Long plazoRespuesta;

    @Column(name = "TEL_AUTOMATICO")
    private Boolean automatico;

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
     * @return the proveedor
     */
    public ProveedorTelecobro getProveedor() {
        return proveedor;
    }

    /**
     * @param proveedor the proveedor to set
     */
    public void setProveedor(ProveedorTelecobro proveedor) {
        this.proveedor = proveedor;
    }

    /**
     * @return the plazoInicial
     */
    public Long getPlazoInicial() {
        return plazoInicial;
    }

    /**
     * @param plazoInicial the plazoInicial to set
     */
    public void setPlazoInicial(Long plazoInicial) {
        this.plazoInicial = plazoInicial;
    }

    /**
     * @return the plazoFinal
     */
    public Long getPlazoFinal() {
        return plazoFinal;
    }

    /**
     * @param plazoFinal the plazoFinal to set
     */
    public void setPlazoFinal(Long plazoFinal) {
        this.plazoFinal = plazoFinal;
    }

    /**
     * @return the diasAntelacion
     */
    public Long getDiasAntelacion() {
        return diasAntelacion;
    }

    /**
     * @param diasAntelacion the diasAntelacion to set
     */
    public void setDiasAntelacion(Long diasAntelacion) {
        this.diasAntelacion = diasAntelacion;
    }

    /**
     * @return the plazoRespuesta
     */
    public Long getPlazoRespuesta() {
        return plazoRespuesta;
    }

    /**
     * @param plazoRespuesta the plazoRespuesta to set
     */
    public void setPlazoRespuesta(Long plazoRespuesta) {
        this.plazoRespuesta = plazoRespuesta;
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
