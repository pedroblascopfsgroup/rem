package es.capgemini.pfs.acuerdo.model;

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
 * Diccionario Resultado Revision
 * @author asoler
 *
 */
@Entity
@Table(name = "DD_RRE_RESULTADO_REVISION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDResultadoRevision implements Dictionary, Auditable {

	private static final long serialVersionUID = 2808173385544678371L;
	public static final String CANCELAR_PDV = "CANCE";
    public static final String RENOVACION = "RENOV";
    public static final String RECONSIDERACION = "RECON";

	@Id
    @Column(name = "DD_RRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDResultadoRevisionGenerator")
	@SequenceGenerator(name = "DDResultadoRevisionGenerator", sequenceName = "S_DD_RRE_RESULTADO_REVISION")
    private Long id;

    @Column(name = "DD_RRE_CODIGO")
    private String codigo;

    @Column(name = "DD_RRE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_RRE_DESCRIPCION_LARGA")
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
