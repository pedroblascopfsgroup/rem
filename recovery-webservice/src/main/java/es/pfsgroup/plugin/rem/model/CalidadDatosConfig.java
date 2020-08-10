package es.pfsgroup.plugin.rem.model;

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
@Table(name = "CDC_CALIDAD_DATOS_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CalidadDatosConfig implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CDC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CalidadDatosConfigGenerator")
	@SequenceGenerator(name = "CalidadDatosConfigGenerator", sequenceName = "S_CDC_CALIDAD_DATOS_CONFIG")
	private Long id;

	@Column(name = "TABLA")
	private String tabla;

	@Column(name = "CAMPO")
	private String campo;

	@Column(name = "COD_CAMPO")
	private String codCampo;
	
	@Column(name = "CAMPO_ID")
	private String campoId;

	@Column(name = "VALIDACION")
	private String validacion;

	@Column(name = "TABLA_AUX")
	private String tablaAux;
	
	@Column(name = "CAMPO_ID_TABLA_AUX")
	private String campoIdTablaAux;
	
	@Column(name = "CLAVE_DICCIONARIO")
	private String claveDiccionario;	

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

	public String getCodCampo() {
		return codCampo;
	}

	public void setCodCampo(String codCampo) {
		this.codCampo = codCampo;
	}

	public String getCampoId() {
		return campoId;
	}

	public void setCampoId(String campoId) {
		this.campoId = campoId;
	}

	public String getValidacion() {
		return validacion;
	}

	public void setValidacion(String validacion) {
		this.validacion = validacion;
	}

	public String getTablaAux() {
		return tablaAux;
	}

	public void setTablaAux(String tablaAux) {
		this.tablaAux = tablaAux;
	}

	public String getCampoIdTablaAux() {
		return campoIdTablaAux;
	}

	public void setCampoIdTablaAux(String campoIdTablaAux) {
		this.campoIdTablaAux = campoIdTablaAux;
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

	public String getClaveDiccionario() {
		return claveDiccionario;
	}

	public void setClaveDiccionario(String claveDiccionario) {
		this.claveDiccionario = claveDiccionario;
	}	

}
