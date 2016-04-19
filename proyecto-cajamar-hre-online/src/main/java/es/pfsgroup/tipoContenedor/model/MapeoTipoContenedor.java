package es.pfsgroup.tipoContenedor.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
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
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

/**
 * Modelo que gestiona el diccionario de los tipos de documentos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "MTC_MAPEO_TIPO_CONTENEDOR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class MapeoTipoContenedor implements Serializable, Auditable {

	@Id
	@Column(name = "MTC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MapeoTipoContenedorGenerator")
	@SequenceGenerator(name = "MapeoTipoContenedorGenerator", sequenceName = "S_MTC_MAPEO_TIPO_CONTENEDOR")
	private Long id;
	 
	@Column(name = "MTC_TDN2_CODIGO")   
	private String codigoTDN2;
	 
	@OneToOne
    @JoinColumn(name = "DD_TFA_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)  
	private DDTipoFicheroAdjunto tipoFichero;
	    
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

	public String getCodigoTDN2() {
		return codigoTDN2;
	}

	public void setCodigoTDN2(String codigoTDN2) {
		this.codigoTDN2 = codigoTDN2;
	}

	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
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
