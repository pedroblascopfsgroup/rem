package es.pfsgroup.recovery.bpmframework.config.model;

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

@Entity
@Table(name = "BPM_DD_TAC_TIPO_ACCION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkDDTipoAccion implements Auditable, Dictionary, Serializable{
    
    private static final long serialVersionUID = 3227324776357805955L;

    public static final String INFORMAR_DATOS = "INFO";

    public static final String AVANZAR_BPM = "ADVANCE";

    public static final String FORWARD = "FORWARD";
    
    public static final String GEN_DOC = "GDOC";
    
    public static final String CHAIN_BO = "CHAIN_BO";
    
    public static final String INFORMAR_DATOS_RECALCULAR = "INFO_RECALCULAR";

    @Id
    @Column(name = "BPM_DD_TAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkDDTipoAccionGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkDDTipoAccionGenerator", sequenceName = "S_BPM_DD_TAC_TIPO_ACCION")
    private Long id;
    
    @Column(name = "BPM_DD_TAC_CODIGO")
    private String codigo;
    
    @Column(name = "BPM_DD_TAC_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "BPM_DD_TAC_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    public Long getId() {
        return id;
    }

    public void setId(final Long id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(final String codigo) {
        this.codigo = codigo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(final String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcionLarga() {
        return descripcionLarga;
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
