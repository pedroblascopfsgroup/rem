package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de EstadoComunicacionC4C
 *
 * 
 * @author Javier Esbri
 *
 */
@Entity
@Table(name = "DD_VIC_VINCULO_CAIXA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDVinculoCaixa implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String COD_EMPLEADO = "10";	
	public static final String COD_FAMILIAR = "20";

	@Id
	@Column(name = "DD_VIC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDVinculoCaixaGenerator")
	@SequenceGenerator(name = "DDVinculoCaixaGenerator", sequenceName = "S_DD_VIC_VINCULO_CAIXA")
	private Long id;

	@Column(name = "DD_VIC_CODIGO")
	private String codigo;

	@Column(name = "DD_VIC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_VIC_DESCRIPCION_LARGA")
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