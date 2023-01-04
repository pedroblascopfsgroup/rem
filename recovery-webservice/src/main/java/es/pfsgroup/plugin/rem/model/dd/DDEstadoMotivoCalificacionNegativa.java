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

import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * 
 *
 * 
 */
@Entity
@Table(name = "DD_EMN_ESTADO_MOTIVO_CAL_NEG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDEstadoMotivoCalificacionNegativa implements Auditable, Dictionary {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7386173624274540595L;

	
	public static final String DD_PENDIENTE_CODIGO = "01";
	public static final String DD_SUBSANADO_CODIGO = "02";

	@Id
    @Column(name = "DD_EMN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoMotivoCalificacionNegativaGenerator")
    @SequenceGenerator(name = "DDEstadoMotivoCalificacionNegativaGenerator", sequenceName = "S_DD_EMN_ESTADO_MOTIVO_CAL_NEG")
    private Long id;

	@Column(name = "DD_EMN_CODIGO")
	private String codigo;
	
	@Column(name = "DD_EMN_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_EMN_DESCRIPCION_LARGA")
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
