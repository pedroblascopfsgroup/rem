package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DIC_DICCIONARIOS_EDITABLES",schema = "${entity.schema}")
public class DICDiccionarioEditable implements DICDiccionarioEditableInterface{

	private static final long serialVersionUID = -3992763049481723134L;

	@Id
	@Column(name = "DIC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "diccionarioEditableGenerator")
	@SequenceGenerator(name = "diccionarioEditableGenerator", sequenceName = "S_DIC_DICCIONARIOS_EDITABLES")
	private Long id;	
	
	@Column(name = "DIC_NBTABLA")
	private String nombreTabla;
	
	@Column(name = "DIC_CODIGO")
	private String codigo;
	
	@Column(name = "DIC_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DIC_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "DIC_EDICION")
	private boolean editable;
	
	@Column(name = "DIC_ADD")
	private boolean insertable;
	
	@Embedded
    private Auditoria auditoria;

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setNombreTabla(String nombreTabla) {
		this.nombreTabla = nombreTabla;
	}

	public String getNombreTabla() {
		return nombreTabla;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

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

	public void setEditable(boolean editable) {
		this.editable = editable;
	}

	public boolean isEditable() {
		return editable;
	}

	public void setInsertable(boolean insertable) {
		this.insertable = insertable;
	}

	public boolean isInsertable() {
		return insertable;
	}
	
}
