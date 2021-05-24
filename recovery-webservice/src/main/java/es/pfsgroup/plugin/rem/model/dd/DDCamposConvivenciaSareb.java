package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_CCS_CAMPOS_CONV_SAREB", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCamposConvivenciaSareb implements Auditable, Dictionary {

	private static final long serialVersionUID = 4508981007991542156L;
	
	@Id
	@Column(name = "DD_CCS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCampoConvicenciaSareb")
	@SequenceGenerator(name = "DDCampoConvicenciaSareb", sequenceName = "S_DD_CCS_CAMPOS_CONV_SAREB")
	private Long id;
	
	@Column(name = "DD_CCS_TABLA")   
	private String tabla;
	
	@Column(name = "DD_CCS_CAMPO")   
	private String campo;
	
	@Column(name = "DD_CCS_CRUCE")   
	private String cruce;
	
	@Column(name = "DD_CCS_DESCRIPCION")   
	private String descripcion;
	
	@JoinColumn(name = "DD_COS_ID")
	@OneToOne
	private DDCampoOrigenConvicenciaSareb cos;
	
	@JoinColumn(name = "DD_CTD_ID")
	@ManyToOne
	private DDCampoTipoDato tipoDato;
	
	
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

	public String getTabla() {
		return tabla;
	}

	public void setTabla(String tabla) {
		this.tabla = tabla;
	}

	public String getCampo() {
		return campo;
	}

	public void setCampo(String campo) {
		this.campo = campo;
	}

	public String getCruce() {
		return cruce;
	}

	public void setCruce(String cruce) {
		this.cruce = cruce;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public DDCampoOrigenConvicenciaSareb getCos() {
		return cos;
	}

	public void setCos(DDCampoOrigenConvicenciaSareb cos) {
		this.cos = cos;
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

	@Override
	public String getCodigo() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getDescripcionLarga() {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}
