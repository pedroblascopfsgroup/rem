package es.capgemini.pfs.contrato.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Tipos de intervención de la personas en los contratos.
 */
@Entity
@Table(name = "DD_EIC_ESTADO_INTERNO_ENTIDAD", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class DDEstadoInternoEntidad implements Dictionary, Auditable{
	
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = -4482681645687691124L;

		@Id
	    @Column(name = "DD_EIC_ID")
	 	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoInternoEntidadGenerator")
		@SequenceGenerator(name = "DDEstadoInternoEntidadGenerator", sequenceName = "S_DD_EIC_EDO_INTERNO_ENTIDAD")
	    private Long id;

	    @Column(name = "DD_EIC_CODIGO")
	    private String codigo;

	    @Column(name = "DD_EIC_DESCRIPCION")
	    private String descripcion;

	    @Column(name = "DD_EIC_DESCRIPCION_LARGA")
	    private String descripcionLarga;

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

}
