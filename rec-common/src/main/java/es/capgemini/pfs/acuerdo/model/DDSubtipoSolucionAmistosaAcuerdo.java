package es.capgemini.pfs.acuerdo.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase que mapea el diccionario de datos de solicitantes.
 * @author pamuller / marruiz
 *
 */
@Entity
@Table(name = "DD_SSA_SUBTI_SOLUC_AMIST", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDSubtipoSolucionAmistosaAcuerdo implements Auditable, Dictionary {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "DD_SSA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConcTituloGenerator")
    @SequenceGenerator(name = "ConcTituloGenerator", sequenceName = "S_DD_SSA_SUBTI_SOLUC_AMIST")
    private Long id;

    @Column(name = "DD_SSA_CODIGO")
    private String codigo;

    @Column(name = "DD_SSA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SSA_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToOne
    @JoinColumn(name = "DD_TSA_ID")
    private DDTipoSolucionAmistosa ddTipoSolucionAmistosa;

    @Column(name = "DD_SSA_ACTIVO")
    private boolean activo;

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
     * @return the activo
     */
    public boolean isActivo() {
        return activo;
    }

    /**
     * @param activo the activo to set
     */
    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    /**
     * @return the ddTipoSolucionAmistosa
     */
    public DDTipoSolucionAmistosa getDdTipoSolucionAmistosa() {
        return ddTipoSolucionAmistosa;
    }

    /**
     * @param ddTipoSolucionAmistosa the ddTipoSolucionAmistosa to set
     */
    public void setDdTipoSolucionAmistosa(DDTipoSolucionAmistosa ddTipoSolucionAmistosa) {
        this.ddTipoSolucionAmistosa = ddTipoSolucionAmistosa;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean equals(Object o) {
        if(o == null){
        	return false;
        }
        
        if(this.getClass() != o.getClass()){
        	return false;
        }
        
        DDSubtipoSolucionAmistosaAcuerdo s = (DDSubtipoSolucionAmistosaAcuerdo) o;
        if (s.getId() == this.id) {
              return true;
        }
    
        return false;
    }

    /**
     * hashCode.
     * @return hashCode
     */
    @Override
    public int hashCode() {
        if (this.getId() != null) {
            return this.getId().hashCode();
        }
        return super.hashCode();
    }
}
