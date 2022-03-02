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
 * Modelo que gestiona el diccionario de la situación comercial de los activos.
 * 
 * @author Benjamín Guerrero
 *
 */
@Entity
@Table(name = "DD_SCM_SITUACION_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSituacionComercial implements Auditable, Dictionary {

	public static final String CODIGO_NO_COMERCIALIZABLE = "01";
	public static final String CODIGO_DISPONIBLE_VENTA = "02";
	public static final String CODIGO_DISPONIBLE_VENTA_OFERTA = "03";
	public static final String CODIGO_DISPONIBLE_VENTA_RESERVA = "04";
	public static final String CODIGO_VENDIDO = "05";
	public static final String CODIGO_TRASPASADO = "06";
	public static final String CODIGO_DISPONIBLE_ALQUILER = "07";
	public static final String CODIGO_DISPONIBLE_VENTA_ALQUILER = "08";
	public static final String CODIGO_DISPONIBLE_CONDICIONADO = "09";
	public static final String CODIGO_ALQUILADO = "10";
	public static final String CODIGO_DISPONIBLE_ALQUILER_OFERTA = "11";
	public static final String CODIGO_DISPONIBLE_VENTA_ALQUILER_OFERTA = "12";
	public static final String CODIGO_ALQUILADO_PARCIALMENTE = "13";
	public static final String CODIGO_RESERVADO_ALQUILER = "14";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "DD_SCM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSituacionComercialGenerator")
	@SequenceGenerator(name = "DDSituacionComercialGenerator", sequenceName = "S_DD_SCM_SITUACION_COMERCIAL")
	private Long id;
	 
	@Column(name = "DD_SCM_CODIGO")   
	private String codigo;
	
	/*@Column(name = "DD_SCM_CIF")   
	private String cif;*/
	 
	@Column(name = "DD_SCM_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SCM_DESCRIPCION_LARGA")   
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	
	/*public String getCif() {
		return cif;
	}

	public void setCif(String cif) {
		this.cif = cif;
	}*/

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
	
	public static boolean isAlquilado(DDSituacionComercial situacionComercial) {
		boolean isAlquilado = false;
		
		if(situacionComercial != null && CODIGO_ALQUILADO.equals(situacionComercial.getCodigo())) {
			isAlquilado = true;
		}
		
		return isAlquilado;
	}

}
