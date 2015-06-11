
package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_DAD_DOC_ADJUDICACION", schema = "${master.schema}")
public class DDDocAdjudicacion implements Auditable, Dictionary {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7196051752813668307L;
	
	public static final String DECRETO = "DECRETO";
	public static final String ESCRITURA = "ESCRITURA";

	@Id
    @Column(name = "DD_DAD_ID")
    private Long id;

    @Column(name = "DD_DAD_CODIGO")
    private String codigo;

    @Column(name = "DD_DAD_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_DAD_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
	@Override
	public Long getId() {
		return id;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;	
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

}
