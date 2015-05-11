package es.capgemini.pfs.politica.model;

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
 * Diccionario de los campos destino de los tipos de objetivos.
 * @author Pablo Müller
  */
@Entity
@Table(name = "CDO_CAMPO_DESTINO_OBJETIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DDCampoDestinoObjetivo implements Dictionary, Auditable {

    public static final String RIESGO_DIRECTO_PERSONA = "RDP";
    public static final String RIESGO_INDIRECTO_PERSONA = "RIP";
    public static final String RIESGO_IRREGULAR_PERSONA = "RIrrP";
    public static final String RIESGO_GARANTIZADO_PERSONA = "RGP";
    public static final String RIESGO_NO_GARANTIZADO_PRSONA = "RNGP";
    public static final String PORCENTAJE_RNG_RD_PERSONA = "RNG/RD";
    public static final String PORCENTAJE_RIRR_RD_PERSONA = "RIrr/RD";

    public static final String RIESGO_CONTRATO = "RC";
    public static final String RIESGO_IRREGULAR_CONTRATO = "RIrrC";
    public static final String RIESGO_GARANTIZADO_CONTRATO = "RGC";
    public static final String RIESGO_NO_GARANTIZADO_CONTRATO = "RNGC";
    public static final String LIMITE_DESCUBIERTO_CONTRATO = "LDC";
    public static final String DISPUESTO_CONTRATO = "DC";

    private static final long serialVersionUID = 1874444097813176638L;

    @Id
    @Column(name = "CDO_ID")
    private Long id;

    @Column(name = "CDO_CODIGO")
    private String codigo;

    @Column(name = "CDO_DESCRIPCION")
    private String descripcion;

    @Column(name = "CDO_DESCRIPCION_LARGA")
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
}
