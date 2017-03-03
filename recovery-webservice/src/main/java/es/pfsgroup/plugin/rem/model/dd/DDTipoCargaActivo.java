package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


/**
 * Modelo que gestiona el diccionario de los tipos de cargas
 * 
 * @author Anahuac de Vicente
 *
 */

@Entity
@Table(name = "DD_TCA_TIPO_CARGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDTipoCargaActivo implements  Auditable, Dictionary {

	private static final long serialVersionUID = -4497097910086775262L;

	public static final String CODIGO_TIPO_CARGA_REG = "REG";
	public static final String CODIGO_TIPO_CARGA_ECO = "ECO";
	public static final String CODIGO_TIPO_CARGA_REGECO = "REGECO";
	
	@Id
    @Column(name = "DD_TCA_ID")
    private Long id;

    @Column(name = "DD_TCA_CODIGO")
    private String codigo;   
    
    @Column(name = "DD_TCA_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_TCA_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
