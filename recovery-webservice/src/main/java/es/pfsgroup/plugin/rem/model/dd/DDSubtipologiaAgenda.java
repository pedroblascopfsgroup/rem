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
 * Modelo que gestiona el diccionario de Subtipologia Agenda
 * 
 * TIJ/Título judicial
 * SUN/Subasta notarial
 * DEP/Dación en pago
 * CV/Compraventa
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "DD_STA_SUBTIPOLOGIA_AGENDA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipologiaAgenda implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_TITULO_JUDICIAL = "TIJ";
	public static final String CODIGO_SUBASTA_NOTARIAL = "SUN";
	public static final String CODIGO_DACION_EN_PAGO = "DEP";
	public static final String CODIGO_COMPRAVENTA = "CV";

	@Id
	@Column(name = "DD_STA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipologiaAgenda")
	@SequenceGenerator(name = "DDSubtipologiaAgenda", sequenceName = "S_DD_STA_SUBTIPOLOGIA_AGENDA")
	private Long id;

	@Column(name = "DD_STA_CODIGO")
	private String codigo;
	 
	@Column(name = "DD_STA_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_STA_DESCRIPCION_LARGA")
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