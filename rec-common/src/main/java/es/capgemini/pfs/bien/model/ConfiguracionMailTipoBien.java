package es.capgemini.pfs.bien.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Entidad CNF_CORREO_VERIF.
 * En la misma se guarda la configuraci�n para los mail según el tipo de bien.
 */
@Entity
@Table(name = "CNF_CORREO_VERIF", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ConfiguracionMailTipoBien implements Serializable, Auditable {

    /**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = 3387312183373610887L;

	@Id
    @Column(name = "CNF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfMailBienGenerator")
    @SequenceGenerator(name = "ConfMailBienGenerator", sequenceName = "S_CNF_CORREO_VERIF")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_TBI_ID")
    private DDTipoBien tipoBien;

    @Column(name = "CNF_DESTINATARIO")
    private String destinatario;

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
     * @return the tipoBien
     */
    public DDTipoBien getTipoBien() {
        return tipoBien;
    }

    /**
     * @param tipoBien the tipoBien to set
     */
    public void setTipoBien(DDTipoBien tipoBien) {
        this.tipoBien = tipoBien;
    }

    /**
     * @return the destinatario
     */
    public String getDestinatario() {
        return destinatario;
    }

    /**
     * @param destinatario the destinatario to set
     */
    public void setDestinatario(String destinatario) {
        this.destinatario = destinatario;
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
