package es.capgemini.pfs.despachoExterno.model;

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

@Entity
@Table(name = "DD_TDE_TIPO_DESPACHO", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoDespachoExterno implements Auditable, Dictionary {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public static final String CODIGO_DESPACHO_EXTERNO = "1";
    public static final String CODIGO_DESPACHO_PROCURADOR = "2";
    public static final String CODIGO_AGENCIA_RECOBRO ="AGER";
    public static final String CODIGO_GESTORIA_PCO = "GESTORIA_PREDOC";

    @Id
    @Column(name = "DD_TDE_ID")
    private Long id;
    @Column(name = "DD_TDE_DESCRIPCION")
    private String descripcion;
    @Column(name = "DD_TDE_DESCRIPCION_LARGA")
    private String descripcionLarga;
    @Column(name = "DD_TDE_CODIGO")
    private String codigo;
    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Long getVersion() {
        return version;
    }

    public void setVersion(Long version) {
        this.version = version;
    }

    public Auditoria getAuditoria() {
        return auditoria;
    }

    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    @Override
    public String toString() {
        return descripcion;
    }
}
