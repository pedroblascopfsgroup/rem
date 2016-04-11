 package es.capgemini.pfs.asunto.model;


import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * JAVADOC FO.
 * @author dgg
 *
 */
@Entity
@Table(name = "DD_TAS_TIPOS_ASUNTO", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class DDTiposAsunto implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;
    public static final String LITIGIO = "01";
    public static final String CONCURSAL = "02";
    public static final String ESPECIALIZADA = "03";
    public static final String ESPECIALIZADA_SAREB = "04";
    public static final String ACUERDO = "ACU";

    @Id
    @Column(name = "DD_TAS_ID")
    private Long id;

    @Column(name = "DD_TAS_CODIGO")
    private String codigo;

    @Column(name = "DD_TAS_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TAS_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @OneToMany(mappedBy = "tipoAsunto", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAS_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<DDTipoActuacion> tiposActuacion;

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
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
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
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
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
    
    public List<DDTipoActuacion> getTiposActuacion() {
		return tiposActuacion;
	}

	public void setTiposActuacion(List<DDTipoActuacion> tiposActuacion) {
		this.tiposActuacion = tiposActuacion;
	}
}


