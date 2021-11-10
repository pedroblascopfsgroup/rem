package es.pfsgroup.plugin.rem.model.dd;

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
 * Modelo que gestiona el diccionario de estados contraste listas.
 * 
 * @author Carlos Augusto
 *
 */

@Entity
@Table(name = "DD_ECL_ESTADO_CONT_LISTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoContrasteListas implements Auditable, Dictionary {
	public static final String NO_SOLICITADO = "NS";
	public static final String PENDIENTE = "PEND";
	public static final String NEGATIVO = "NEG";
	public static final String FALSO_POSITIVO = "FP";
	public static final String POSITIVO_REAL_APROBADO = "PRA";
	public static final String POSITIVO_REAL_DENEGADO = "PRD";


	

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_ECL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoContrasteListasGenerator")
	@SequenceGenerator(name = "DDEstadoContrasteListasGenerator", sequenceName = "S_DD_ECL_ESTADO_CONT_LISTAS")
	private Long id;
	    
	@Column(name = "DD_ECL_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_ECL_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ECL_DESCRIPCION_LARGA")   
	private String descripcionLarga;	    

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

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
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

}