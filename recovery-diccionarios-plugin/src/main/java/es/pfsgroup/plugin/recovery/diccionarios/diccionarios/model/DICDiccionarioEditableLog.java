package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DIC_DICCIONARIOS_LOG", schema = "${entity.schema}")
public class DICDiccionarioEditableLog implements DICDiccionarioEditableLogInterface<DICDiccionarioEditable>{

	private static final long serialVersionUID = -3992763049481723134L;

	@Id
	@Column(name = "DIL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "diccionarioEditableLogGenerator")
	@SequenceGenerator(name = "diccionarioEditableLogGenerator", sequenceName = "S_DIC_DICCIONARIOS_LOG")
	private Long id;	
	
	@ManyToOne
    @JoinColumn(name = "DIL_DICCIONARIO_ID")
	private DICDiccionarioEditable diccionario;
	
	@Column(name = "DIL_USUARIO")
	private String usuario;
	
	@Column(name = "DIL_ACCION")
	private String accion;
	
	@Column(name = "DIL_FECHA")
	private Date fecha;
	
	@Column(name = "DIL_VALOR_ANTERIOR")
	private String valorAnterior;
	
	@Column(name = "DIL_VALOR_NUEVO")
	private String valorNuevo;

	@Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DICDiccionarioEditable getDiccionario() {
		return diccionario;
	}

	public void setDiccionario(DICDiccionarioEditable diccionario) {
		this.diccionario = diccionario;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getAccion() {
		return accion;
	}

	public void setAccion(String accion) {
		this.accion = accion;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public String getValorAnterior() {
		return valorAnterior;
	}

	public void setValorAnterior(String valorAnterior) {
		this.valorAnterior = valorAnterior;
	}

	public String getValorNuevo() {
		return valorNuevo;
	}

	public void setValorNuevo(String valorNuevo) {
		this.valorNuevo = valorNuevo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}	
	
}
