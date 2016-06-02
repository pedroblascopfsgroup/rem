package es.pfsgroup.plugin.recovery.mejoras.procedimiento.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Tipos procedimientos iniciadores
 * @author asoler
 *
 */
@Entity
@Table(name = "DD_TPI_TIPO_PRC_INICIADOR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoPrcIniciador implements Dictionary, Auditable {

	private static final long serialVersionUID = 8648425513556688553L;
	
	public static final String HIPOTECARIO = "H001";
    public static final String TITULO_JUDICIAL = "H018";
    public static final String TITULO_NO_JUDICIAL = "H020";
    public static final String ORDINARIO = "H024";
    public static final String MONITORIO = "H022";
    public static final String CAMBIARIO = "H016";
    public static final String VERBAL = "H026";
    public static final String VERBAL_DESDE_MONITORIO = "H028";
    public static final String PREP_EXP_JUDICIAL = "PCO";

	@Id
    @Column(name = "DD_TPI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoPrcIniciadorGenerator")
	@SequenceGenerator(name = "DDTipoPrcIniciadorGenerator", sequenceName = "S_DD_TPI_TIPO_PRC_INICIADOR")
    private Long id;

    @Column(name = "DD_TPI_CODIGO")
    private String codigo;

    @Column(name = "DD_TPI_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TPI_DESCRIPCION_LARGA")
    private String descripcionLarga;

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

}
