package es.capgemini.pfs.dsm.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "entidadConfig", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class EntidadConfig implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EntidadConfigGenerator")
    @SequenceGenerator(name = "EntidadConfigGenerator", sequenceName = "${master.schema}.S_ENTIDAD_CONFIG")
    private Long id;

    @Column(name = "ENTIDAD_ID")
    private Long entidadId;

    private String dataKey;

    private String dataValue;

    @ManyToOne
    private Entidad entidad;

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
     * @return the dataKey
     */
    @Column(name = "DATAKEY")
    public String getDataKey() {
        return dataKey;
    }

    /**
     * @param dataKey the dataKey to set
     */
    public void setDataKey(String dataKey) {
        this.dataKey = dataKey;
    }

    /**
     * @return the dataValue
     */
    @Column(name = "DATAVALUE")
    public String getDataValue() {
        return dataValue;
    }

    /**
     * @param dataValue the dataValue to set
     */
    public void setDataValue(String dataValue) {
        this.dataValue = dataValue;
    }

    /**
     * @param entidadId the entidadId to set
     */
    public void setEntidadId(Long entidadId) {
        this.entidadId = entidadId;
    }

    /**
     * @return the entidadId
     */
    public Long getEntidadId() {
        return entidadId;
    }

    /**
     * @param entidad the entidad to set
     */
    public void setEntidad(Entidad entidad) {
        this.entidad = entidad;
    }

    /**
     * @return the entidad
     */
    public Entidad getEntidad() {
        return entidad;
    }

}
