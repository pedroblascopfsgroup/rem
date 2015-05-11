package es.pfsgroup.recovery.bpmframework.input.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * DD de tipos de input
 * @author bruno
 *
 */
@Entity
@Table(name = "BPM_DD_TIN_TIPO_INPUT", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkDDTipoInput implements Auditable, Dictionary, Serializable{

    private static final long serialVersionUID = 2699811810067228393L;
    
    @Id
    @Column(name = "BPM_DD_TIN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkDDTipoInputGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkDDTipoInputGenerator", sequenceName = "S_BPM_DD_TIN_TIPO_INPUT")
    private Long id;
    
    @Column(name = "BPM_DD_TIN_CODIGO")
    private String codigo;
    
    @Column(name = "BPM_DD_TIN_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "BPM_DD_TIN_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
   
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Override
    public Long getId() {
        return this.id;
    }

    @Override
    public String getCodigo() {
        return this.codigo;
    }

    @Override
    public String getDescripcion() {
        return this.descripcion;
    }

    @Override
    public String getDescripcionLarga() {
       return this.descripcionLarga;
    }

    public void setId(final Long id) {
        this.id = id;
    }

    public void setCodigo(final String codigo) {
        this.codigo = codigo;
    }

    public void setDescripcion(final String descripcion) {
        this.descripcion = descripcion;
    }

    public void setDescripcionLarga(final String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(final Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(final Integer version) {
        this.version = version;
    }

}
