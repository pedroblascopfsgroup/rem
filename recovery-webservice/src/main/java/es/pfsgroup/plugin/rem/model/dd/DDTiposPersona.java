package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 *
 * Diccionario de tipo de persona.
 *
 */
@Entity
@Table(name = "DD_TPE_TIPO_PERSONA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTiposPersona implements Dictionary,Auditable {

    private static final long serialVersionUID = -8720493629497537187L;

    public static final String CODIGO_TIPO_PERSONA_FISICA = "1";
    public static final String CODIGO_TIPO_PERSONA_JURIDICA = "2";

    @Id
    @Column(name = "DD_TPE_ID")
    private Long id;

    @Column(name = "DD_TPE_CODIGO")
    private String codigo;

    @Column(name = "DD_TPE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TPE_DESCRIPCION_LARGA")
    private String descripcionLarga;

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
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return this.descripcion;
    }
    
    public static boolean isFisica(DDTiposPersona tipoPersona) {
    	boolean tipoFisica= false;
    	if (tipoPersona != null && CODIGO_TIPO_PERSONA_FISICA.equals(tipoPersona.getCodigo())) {
			tipoFisica = true;
		}
		return tipoFisica;    	
    }
    
    public static boolean isJuridico(DDTiposPersona tipoPersona) {
    	boolean tipoJuridico= false;
    	if (tipoPersona != null && CODIGO_TIPO_PERSONA_JURIDICA.equals(tipoPersona.getCodigo())) {
    		tipoJuridico = true;
		}
		return tipoJuridico;    	
    }
}
