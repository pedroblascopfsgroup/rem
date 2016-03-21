package es.capgemini.pfs.dsm.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.MapKey;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

/**
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "entidad", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class Entidad implements Serializable {

    private static final long serialVersionUID = 1L;
    public static final String WORKING_CODE_KEY = "workingCode";

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EntidadGenerator")
    @SequenceGenerator(name = "EntidadGenerator", sequenceName = "${master.schema}.S_ENTIDAD")
    private Long id;

    @Column(name = "DESCRIPCION")
    private String descripcion;

    @OneToMany(mappedBy = "entidad", fetch = FetchType.EAGER)
    @MapKey(columns = { @Column(name = "dataKey") })
    private Map<String, EntidadConfig> configuracion;
    
    @ManyToMany(fetch = FetchType.LAZY)
    @OrderBy("descripcion ASC")
	@JoinTable(name = "${master.schema}.ETG_ENTIDAD_TIPO_GESTOR",  joinColumns = {@JoinColumn(name = "ENTIDAD_ID", referencedColumnName = "ID",nullable = false, updatable = false) }, inverseJoinColumns = { @JoinColumn(name = "DD_TGE_ID", nullable = false, updatable = false) })
    private List<EXTDDTipoGestor> tiposDeGestores;
    

	/**
     * @param key string
     * @param defaultValue string
     * @return string
     */
    public String configValue(String key, String defaultValue) {
        EntidadConfig entidadConfig = getConfiguracion().get(key);
        if (entidadConfig != null) { return entidadConfig.getDataValue(); }
        return defaultValue;
    }

    /**
     * @param key string
     * @return string
     */
    public String configValue(String key) {
        return configValue(key, null);
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
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @param config the configuracion to set
     */
    public void setConfiguracion(Map<String, EntidadConfig> config) {
        this.configuracion = config;
    }

    /**
     * @return the configuracion
     */
    public Map<String, EntidadConfig> getConfiguracion() {
        return configuracion;
    }
    
    
    public List<EXTDDTipoGestor> getTiposDeGestores() {
		return tiposDeGestores;
	}

	public void setTiposDeGestores(List<EXTDDTipoGestor> tiposDeGestores) {
		this.tiposDeGestores = tiposDeGestores;
	}

}
