package es.pfsgroup.plugin.recovery.liquidaciones.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DD_TIM_TIPO_IMPUTACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class DDTipoImputacion implements Auditable, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4828134585141618353L;

	@Id
    @Column(name = "TIM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoImputacionGenerator")
    @SequenceGenerator(name = "TipoImputacionGenerator", sequenceName = "S_DD_TIM_TIPO_IMPUTACION")
    private Long id;

    @Column(name = "TIM_CODIGO")
    private String codigo;

    @Column(name = "TIM_DESCRIPCION")
    private String descripcion;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
