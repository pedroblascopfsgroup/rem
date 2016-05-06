package es.capgemini.pfs.actitudAptitudActuacion.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario Motivo No Litigar
 * @author asoler
 *
 */
@Entity
@Table(name = "DD_MNL_MOTIVO_NO_LITIGAR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDMotivoNoLitigar implements Dictionary, Auditable {

	private static final long serialVersionUID = 8295338809696286213L;
	
	public static final String CARGAS_ANTERIORES = "CARANT";
    public static final String PRIMERA_HIP_BANKIA = "1HIBAN";
    public static final String INSOLVENCIA = "INSOLV";
    public static final String CONCURSO = "CONCUR";
    public static final String PRECONCURSO = "PRECON";
    public static final String GARANTIA_SGR = "GARSGR";
    public static final String OTRA_GARANTIA_REAL = "OGAREA";
    public static final String IMPORTE_DEUDA = "IMPDEU";
    public static final String NO_CUMPLE_POLITICAS = "NOCUPO";
    public static final String OTROS = "OTROS";
    public static final String SIN_ESPECIFICAR = "SINESP";

	@Id
    @Column(name = "DD_MNL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoNoLitigarGenerator")
	@SequenceGenerator(name = "DDMotivoNoLitigarGenerator", sequenceName = "S_DD_MNL_MOTIVO_NO_LITIGAR")
    private Long id;

    @Column(name = "DD_MNL_CODIGO")
    private String codigo;

    @Column(name = "DD_MNL_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_MNL_DESCRIPCION_LARGA")
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

    public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
}
