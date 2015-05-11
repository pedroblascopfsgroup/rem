package es.capgemini.pfs.metrica.model;

import java.io.Serializable;
import java.util.Date;

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
import org.hibernate.annotations.Type;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * Modelo de la tabla donde se guardan el arhivo binario de las métricas cargadas.
 * Esta tabla tiene datos que también están en la tablas de métricas.
 * El motivo es que se necesitan para identificar el fichero en caso de que se borre
 * físicamente la métrica de la BBDD.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "FME_FICHERO_METRICAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class FicheroMetrica implements Serializable, Auditable {

    private static final long serialVersionUID = 219811738386260203L;

    @Id
    @Column(name = "FME_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FMEGenerator")
    @SequenceGenerator(name = "FMEGenerator", sequenceName = "S_FME_FICHERO_METRICAS")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPersona tipoPersona;

    @OneToOne
    @JoinColumn(name = "DD_SCE_ID")
    private DDSegmento segmento;

    @Column(name = "FME_FICHERO")
    //BLOB
    @Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
    private FileItem fileItem;

    @Column(name = "FME_FECHA_CARGA")
    private Date fechaCarga;

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
     * @return the tipoPersona
     */
    public DDTipoPersona getTipoPersona() {
        return tipoPersona;
    }

    /**
     * @param tipoPersona the tipoPersona to set
     */
    public void setTipoPersona(DDTipoPersona tipoPersona) {
        this.tipoPersona = tipoPersona;
    }

    /**
     * @return the segmento
     */
    public DDSegmento getSegmento() {
        return segmento;
    }

    /**
     * @param segmento the segmento to set
     */
    public void setSegmento(DDSegmento segmento) {
        this.segmento = segmento;
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
     * @return the fileItem
     */
    public FileItem getFileItem() {
        return fileItem;
    }

    /**
     * @param fileItem the fileItem to set
     */
    public void setFileItem(FileItem fileItem) {
        this.fileItem = fileItem;
    }

}
