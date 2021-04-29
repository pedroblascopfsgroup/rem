package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTSPTipoCorreo;

/**
 * Modelo que gestiona los propietarios de los activos
 * 
 * @author  Daniel Gallego
 *
 */
@Entity
@Table(name = "TSC_CONFIG_SOCIEDAD_CORREO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class TSCConfigSociedadCorreo implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	 @Id
	 @Column(name = "TSC_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "TSCConfigSociedadCorreoGenerator")
	 @SequenceGenerator(name = "TSCConfigSociedadCorreoGenerator", sequenceName = "S_TSC_CONFIG_SOCIEDAD_CORREO")
	 private Long id;

	 @ManyToOne
     @JoinColumn(name = "DD_TSP_ID")
     private DDTSPTipoCorreo dDTSPTipoCorreo;
	 

	 @Column(name = "TSC_TIPO_CORREO")   
	 private boolean tipoCorreo;
	 
	 @Column(name = "TSC_CORREO")   
	 private String correo;
	
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

	

	public DDTSPTipoCorreo getdDTSPTipoCorreo() {
		return dDTSPTipoCorreo;
	}

	public void setdDTSPTipoCorreo(DDTSPTipoCorreo dDTSPTipoCorreo) {
		this.dDTSPTipoCorreo = dDTSPTipoCorreo;
	}

	public boolean isTipoCorreo() {
		return tipoCorreo;
	}

	public void setTipoCorreo(boolean tipoCorreo) {
		this.tipoCorreo = tipoCorreo;
	}

	public String getCorreo() {
		return correo;
	}

	public void setCorreo(String correo) {
		this.correo = correo;
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