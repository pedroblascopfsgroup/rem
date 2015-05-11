package es.capgemini.pfs.subfase.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Entidad subfase.
 * @author Andrés Esteban
 */
@Entity
@Table(name = "DD_SMG_SUBFASES_MAPA_GLOBAL", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Subfase implements Serializable {

    private static final long serialVersionUID = 1L;
    public static final String SUBFASE_NV = "NV";
    public static final String SUBFASE_CAR = "CAR";
    public static final String SUBFASE_GV15 = "GV15";
    public static final String SUBFASE_GV15_30 = "GV15-30";
    public static final String SUBFASE_GV30_60 = "GV30-60";
    public static final String SUBFASE_GV60 = "GV60";
    public static final String SUBFASE_CE = "CE";
    public static final String SUBFASE_RE = "RE";
    public static final String SUBFASE_DC = "DC";

    @Id
    @Column(name = "DD_SMG_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_FMG_ID")
    private DDFase fase;

    @Column(name = "DD_SMG_CODIGO")
    private String codigo;

    @Column(name = "DD_SMG_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SMG_DESCRIPCION_LARGA")
    private String descripcionLarga;

    /**
     * Determina el orden de la subfase en el tiempo entre las
     * distintas que hay.
     */
    @Column(name = "DD_SMG_ORDEN")
    private Integer orden;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * @return the fase
     */
    public DDFase getFase() {
        return fase;
    }

    /**
     * @param fase the fase to set
     */
    public void setFase(DDFase fase) {
        this.fase = fase;
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
	 * @return Orden de la subfase en el tiempo entre las distintas que hay
	 */
	public Integer getOrden() {
		return orden;
	}

	/**
	 * @param orden the orden to set
	 */
	public void setOrden(Integer orden) {
		this.orden = orden;
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
}
