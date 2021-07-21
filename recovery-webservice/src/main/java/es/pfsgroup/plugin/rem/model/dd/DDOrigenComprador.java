package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

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

@Entity
@Table(name = "DD_ORC_ORIGEN_COMPRADOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDOrigenComprador implements Serializable, Auditable {

	private static final long serialVersionUID = 4588953069603608041L;
	
	public static final String CODIGO_ORC_HRE = "01";
	public static final String CODIGO_ORC_API_PROPIO = "02";
	public static final String CODIGO_ORC_OFICINA = "03";
	public static final String CODIGO_ORC_FDV = "04";
	public static final String CODIGO_ORC_API_AJENO = "05";

	@Id
    @Column(name = "DD_ORC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDOrigenCompradorGenerator")
    @SequenceGenerator(name = "DDOrigenCompradorGenerator", sequenceName = "S_DD_ORC_ORIGEN_COMPRADOR")
    private Long id;

	@Column(name = "DD_ORC_CODIGO")
	private String codigo;

	@Column(name = "DD_ORC_CODIGO_C4C")
	private String codigoC4C;
	
	@Column(name = "DD_ORC_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_ORC_DESCRIPCION_LARGA")
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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}
}
