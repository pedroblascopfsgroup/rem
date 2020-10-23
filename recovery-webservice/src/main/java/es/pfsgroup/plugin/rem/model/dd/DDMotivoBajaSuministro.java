

package es.pfsgroup.plugin.rem.model.dd;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de Motivo de Baja de Suministro
 */
@Entity
@Table(name = "DD_MBS_MOTIVO_BAJA_SUM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoBajaSuministro implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	public static final String CODIGO_MBS_COMUNIDAD_CONSTITUIDA = "CON";
	public static final String CODIGO_MBS_VENTA= "VEN";
	public static final String CODIGO_MBS_ALQUILADA= "ALQ";
	public static final String CODIGO_MBS_BAJA_PISO_PILOTO= "BPP";
	public static final String CODIGO_MBS_BAJA_SEGURIDAD= "BSE";
	public static final String CODIGO_MBS_BAJA_MANTENIMIENTO= "BMA";
	public static final String CODIGO_MBS_BAJA_VIGILANCIA= "BSU";
	public static final String CODIGO_MBS_OTROS= "OTR";
	
	@Id
	@Column(name = "DD_MBS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoBajaSuministroGenerator")
	@SequenceGenerator(name = "DDMotivoBajaSuministroGenerator", sequenceName = "S_DD_MBS_MOTIVO_BAJA_SUM")
	private Long id;
	    
	@Column(name = "DD_MBS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MBS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MBS_DESCRIPCION_LARGA")   
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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



