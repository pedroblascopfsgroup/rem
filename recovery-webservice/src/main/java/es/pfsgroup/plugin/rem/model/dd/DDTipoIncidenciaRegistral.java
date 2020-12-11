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
 * Modelo que gestiona el diccionario de Tipo Incidencia Registral,
 * relacionado con el expediente de la contingencia registral del activo
 * 
 * 01 / Discrepancia físico-jurídica/Exceso cabida > al 20%
 * 02 / Discrepancia físico-jurídica/Exceso cabida < al 20%
 * 03 / Discrepancia físico-jurídica/Sin inmatricular
 * 04 / Discrepancia físico-jurídica/Cambio de uso
 * 05 / Discrepancia físico-jurídica/Cambio descripción registral
 * 06 / Discrepancia físico-jurídica/División horizontal
 * 07 / Construcción ilegal/Irregularidades urbanísticas
 * 08 / Construcción ilegal/Fuera de ordenación
 * 09 / Activo irregular
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "DD_TIR_TIPO_INCI_REGISTRAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoIncidenciaRegistral implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_CABIDA_MAYOR_20 	= "01";
	public static final String CODIGO_CABIDA_MENOR_20 	= "02";
	public static final String CODIGO_SIN_INMATRICULAR 	= "03";
	public static final String CODIGO_CAMBIO_USO 		= "04";
	public static final String CODIGO_CAMBIO_REGISTRAL 	= "05";
	public static final String CODIGO_DIVISION_HORIZ 	= "06";
	public static final String CODIGO_IRREGULARIDAD_URB = "07";
	public static final String CODIGO_FUERA_ORDENACION 	= "08";
	public static final String CODIGO_ACTIVO_IRREGULAR 	= "09";

	@Id
	@Column(name = "DD_TIR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoIncidenciaRegistral")
	@SequenceGenerator(name = "DDTipoIncidenciaRegistral", sequenceName = "S_DD_TIR_TIPO_INCI_REGISTRAL")
	private Long id;

	@Column(name = "DD_TIR_CODIGO")
	private String codigo;

	@Column(name = "DD_TIR_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TIR_DESCRIPCION_LARGA")
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