package es.pfsgroup.recovery.recobroCommon.ranking.model;

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
 * Clase diccionario que mapea las variables para ranking
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_DD_VAR_VARIABLES_RANKING", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroDDVariableRanking implements Auditable, Dictionary{

	public static final String CODIGO_EFICACIA_SOBRE_STOCK = "EFS";
	public static final String CODIGO_EFICACION_SOBRE_ENTRADAS = "ESE";
	public static final String CODIGO_CONTACTABILIDAD = "COT";	
	public static final String CODIGO_CALIDAD_GESTION ="CAG";
	public static final String CODIGO_CALIDAD_ACUERDOS = "CAA";
	public static final String CODIGO_COBERTURA = "COB";	
	
	private static final long serialVersionUID = 3423602833308967504L;

	@Id
    @Column(name = "RCF_DD_VAR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "VariableRankingGenerator")
	@SequenceGenerator(name = "VariableRankingGenerator", sequenceName = "S_RCF_DD_VAR_VARIABLES_RANKING")
    private Long id;

    @Column(name = "RCF_DD_VAR_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_VAR_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_VAR_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
}
