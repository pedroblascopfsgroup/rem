package es.capgemini.pfs.decisionProcedimiento.model;

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
 * PONER JAVADOC FO.
 * @author fo
 *
 */
@Entity
@Table(name = "DD_DPA_DECISION_PARALIZAR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDCausaDecisionParalizar implements Auditable, Dictionary {

	/* Códigos motivo paralizar*/
	public static final String CODIGO_CONCURSO_ACREEDORES 						= "CONCUR";
	public static final String CODIGO_ACUERDO_EXTRAJUDICIAL 					= "ACUER";
	public static final String CODIGO_OPOSICION_LEY_HIPO 						= "OPOSI";
	public static final String CODIGO_INSTRUCCIONES_ENTIDAD 					= "INSTR";
	public static final String CODIGO_OTRAS_CAUSAS		 						= "OTRA";
	public static final String CODIGO_PDTE_RESOLUCION	 						= "RD";
	public static final String CODIGO_ATIPICO_GASTOS							= "ADG";
	public static final String CODIGO_CSR_ALTA_PARA_COMPROBAR		 			= "CSR";
	public static final String CODIGO_CARTERA_FALLIDA_ULISES_ALKALI				= "CFUA";
	public static final String CODIGO_CARTERA_FALLIDA_ALCALA_GESCOBRO			= "CFAG";
	public static final String CODIGO_APLAZAMIENTO_AUTORIZADO					= "APLAU";
	public static final String CODIGO_PLAN_PAGOS_AUTORIZADO		 				= "PPA";
	public static final String CODIGO_INSOLVENTE_PENDIENTE_ESTUDIO				= "IPE";
	public static final String CODIGO_INSOLVENTE_PENDIENTE_ASIGNACION			= "IPAEE";
		
	/**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -2162464343548933900L;

    @Id
    @Column(name = "DD_DPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCausaDecisionParalizarGenerator")
    @SequenceGenerator(name = "DDCausaDecisionParalizarGenerator", sequenceName = "S_DD_DPA_DECISION_PARALIZAR")
    private Long id;

    @Column(name = "DD_DPA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_DPA_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_DPA_CODIGO")
    private String codigo;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    /**
     * to string.
     * @return to string
     */
    @Override
    public String toString() {
        return descripcion;
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
     * @return the version
     */
    public Long getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Long version) {
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

}
