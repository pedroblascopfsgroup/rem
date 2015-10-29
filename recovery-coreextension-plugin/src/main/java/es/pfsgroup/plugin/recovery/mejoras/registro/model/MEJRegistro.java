package es.pfsgroup.plugin.recovery.mejoras.registro.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJDDTipoRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;

@Entity
@Table(name = "MEJ_REG_REGISTRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MEJRegistro implements Serializable, Auditable,MEJRegistroInfo{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8481896550364371655L;
	
	@Id
	@Column(name = "REG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MEJRegistroGenerator")
	@SequenceGenerator(name = "MEJRegistroGenerator", sequenceName = "S_MEJ_REG_REGISTRO")
	private Long id;
	
	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "DD_TRG_ID")
    @NotNull
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private MEJDDTipoRegistro tipo;
	
	
	@Column(name="TRG_EIN_CODIGO")
	@NotNull
	@NotEmpty
	private String tipoEntidadInformacion;
	
	@Column(name="TRG_EIN_ID")
	@NotNull
	private Long idEntidadInformacion;
	
	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "USU_ID")
    @NotNull
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Usuario usuario;
	
	@OneToMany(mappedBy = "registro", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "REG_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<MEJInfoRegistro> infoRegistro = new ArrayList<MEJInfoRegistro>();
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	
	

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
		
	}

	@Override
	public Date getFecha() {
		if (auditoria == null){
			return null;
		}
		return auditoria.getFechaCrear();
	}

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id){
		this.id=id;
	}
	
	@Override
	public Long getIdEntidadInformacion() {
		return idEntidadInformacion;
	}
	
	public void setIdEntidadInformacion(Long idEntidadInformacion){
		this.idEntidadInformacion=idEntidadInformacion;
	}

	@Override
	public List<? extends ClaveValor> getInfoRegistro() {
		return infoRegistro;
	}
	
	public void setInfoRegistro(List<MEJInfoRegistro> infoRegistro){
		this.infoRegistro=infoRegistro;
	}

	@Override
	public MEJDDTipoRegistroInfo getTipo() {
		return tipo;
	}
	
	public void setTipo(MEJDDTipoRegistro tipo){
		this.tipo=tipo;
	}

	@Override
	public String getTipoEntidadInformacion() {
		return tipoEntidadInformacion;
	}
	
	public void setTipoEntidadInformacion(String tipoEntidadInformacion){
		this.tipoEntidadInformacion=tipoEntidadInformacion;
	}

	@Override
	public Usuario getUsuario() {
		return usuario;
	}
	
	public void setUsuario(Usuario usuario){
		this.usuario=usuario;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}
	
	public void addInfo(MEJInfoRegistro info) {
		if (info != null){
			this.infoRegistro.add(info);
		}
		
	}

}
