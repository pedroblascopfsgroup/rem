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
 * Modelo que gestiona el diccionario de Tipo de Incidencia.
 * 
 * @author Gabriel De Toni
 *
 */
@Entity
@Table(name = "DD_TDA_TIPO_INCIDENCIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoIncidencia implements Auditable, Dictionary {

	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_EXCESO_CABIDA_MAYOR_AL_20_PORCIERTO = "01";
	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_EXCESO_CABIDA_MENOR_AL_20_PORCIERTO = "02";
	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_SIN_INMATRICULAR = "03";
	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_CAMBIO_DE_USO = "04";
	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_CAMBIO_DESCRIPCION_REGISTRAL = "05";
	public static final String CODIGO_DISCREPANCIA_FISICO_JURIDICA_DIVISION_HORIZONTAL = "06";
	public static final String CODIGO_CONSTRUCCION_ILEGAL_IRREGULARIDADES_URBANISTICAS = "07";
	public static final String CODIGO_CONSTRUCCION_ILEGAL_FUERA_DE_ORDENACION = "08";
	public static final String CODIGO_ACTIVO_IRREGULAR = "09";

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TDA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoIncidenciaGenerator")
	@SequenceGenerator(name = "DDTipoIncidenciaGenerator", sequenceName = "S_DD_TDA_TIPO_INCIDENCIA")
	private Long id;
	 
	@Column(name = "DD_TDA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDA_DESCRIPCION_LARGA")   
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

}
