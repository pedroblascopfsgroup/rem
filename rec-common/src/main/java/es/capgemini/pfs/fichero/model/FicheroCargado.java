package es.capgemini.pfs.fichero.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Información de fecha de carga para todos los tipos de fichero del BATCH.
 * La idea es utilizar esta tabla para optiizar la busqueda de la ultima fecha.
 * @author aesteban
 */
@Entity
@Table(name = "FRC_FICHEROS_CARGADOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class FicheroCargado implements Serializable, Auditable {

    private static final long serialVersionUID = -1023101159061228237L;

    @Id
    @Column(name = "FRC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FicheroCargadoGenerator")
    @SequenceGenerator(name = "FicheroCargadoGenerator", sequenceName = "S_FRC_FICHEROS_CARGADOS")
    private Long id;

    @Column(name = "FRC_FECHA_EXTRACCION")
    private Date fechaCarga;

    @Column(name = "FRC_ULTIMO")
    private Boolean ultimo;

    @ManyToOne
    @JoinColumn(name = "DD_TFI_ID")
    private TipoFichero tipoFichero;

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
     * @return the fechaCarga
     */
    public Date getFechaCarga() {
        return fechaCarga;
    }

    /**
     * @param fechaCarga the fechaCarga to set
     */
    public void setFechaCarga(Date fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    /**
     * @return the ultimo
     */
    public Boolean getUltimo() {
        return ultimo;
    }

    /**
     * @param ultimo the ultimo to set
     */
    public void setUltimo(Boolean ultimo) {
        this.ultimo = ultimo;
    }

    /**
     * @return the tipoFichero
     */
    public TipoFichero getTipoFichero() {
        return tipoFichero;
    }

    /**
     * @param tipoFichero the tipoFichero to set
     */
    public void setTipoFichero(TipoFichero tipoFichero) {
        this.tipoFichero = tipoFichero;
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
