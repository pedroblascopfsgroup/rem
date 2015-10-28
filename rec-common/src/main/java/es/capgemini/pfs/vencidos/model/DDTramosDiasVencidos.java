package es.capgemini.pfs.vencidos.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Entidad Tramos Dias Vencidos
 * @author abarrantes
 *
 */

@Entity
@Table(name = "DD_TDV_TRAMOS_DIAS_VENCIDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTramosDiasVencidos implements Dictionary, Auditable {
	

	private static final long serialVersionUID = 8865695202076306454L;
	
	@Id
	@Column(name = "DD_TDV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTramosDiasVencidosGenerator")
	@SequenceGenerator(name="DDTramosDiasVencidosGenerator", sequenceName="S_DD_TDV_TRAMOS_DIAS_VENCIDOS")
	private Long id;
	
	@Column(name = "DD_TDV_CODIGO")
	private String codigo;

	@Column(name = "DD_TDV_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_TDV_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "DD_TDV_DIA_INICIO")
	private Integer diaInicio;
	
	@Column(name = "DD_TDV_DIA_FIN")
	private Integer diaFin;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
	private Integer version;

	/**
	 * @return id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	/**
	 * @return descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return descripcionLarga
	 */
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	/**
	 * @param descripcionLarga
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * @return diaInicio
	 */
	public Integer getDiaInicio() {
		return diaInicio;
	}

	/**
	 * @param diaInicio
	 */
	public void setDiaInicio(Integer diaInicio) {
		this.diaInicio = diaInicio;
	}

	/**
	 * @return diaFin
	 */
	public Integer getDiaFin() {
		return diaFin;
	}

	/**
	 * @param diaFin
	 */
	public void setDiaFin(Integer diaFin) {
		this.diaFin = diaFin;
	}
	
	/**
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}
	

}
