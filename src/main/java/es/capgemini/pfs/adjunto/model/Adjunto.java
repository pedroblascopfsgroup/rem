package es.capgemini.pfs.adjunto.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;

import es.capgemini.devon.files.FileItem;

/**
 * Clase que representa a un fichero adjunto.
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "ADJ_ADJUNTOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Adjunto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "ADJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntosGenerator")
    @SequenceGenerator(name = "AdjuntosGenerator", sequenceName = "S_ADJ_ADJUNTOS")
    private Long id;

    @Column(name = "ADJ_FICHERO")
    @Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
    private FileItem fileItem;

    /**
     * Constructor vacio.
     */
    public Adjunto() {
    }

    /**
     * Constructor.
     * @param fileItem FileItem
     */
    public Adjunto(FileItem fileItem) {
        this.fileItem = fileItem;
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
    public void setId(Long id) {
        this.id = id;
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
