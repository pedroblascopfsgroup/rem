

package es.pfsgroup.plugin.rem.model.dd;

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

/**
 * 
 * HREOS-7359
 * 
 * Modelo que gestiona la informacion de Juntas de un activo
 *  
 * @author Alfonso Rodriguez Verdera
 *
 */

@Entity
@Table(name = "DD_TDJ_TIPO_DOC_JUNTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocJuntas implements Auditable, Dictionary {


	public static final String CODIGO_COMUNIDAD_PROPIETARIOS_EXTRAORDINARIA_DERRAMA_JUSTIFICANTE = "01";
    public static final String CODIGO_COMUNIDAD_PROPIETARIOS_EXTRAORDINARIA_DERRAMA_RECIBO = "02";
    public static final String CODIGO_COMUNIDAD_PROPIETARIOS_ORDINARIA_JUSTIFICANTE= "03";
    public static final String CODIGO_COMUNIDAD_PROPIETARIOS_ORDINARIA_RECIBO = "04";
    public static final String CODIGO_JUNTA_COMPENSACION_CUOTAS_DERRAMAS_JUSTIFICANTE = "05";
    public static final String CODIGO_JUNTA_COMPENSACION_CUOTAS_DERRAMAS_RECIBO= "06";
    public static final String CODIGO_JUNTA_COMPENSACION_EUC_GASTOS_GENERALES_JUSTIFICANTE = "07";
    public static final String CODIGO_JUNTA_COMPENSACION_EUC_GASTOS_GENERALES_RECIBO = "08";
    public static final String CODIGO_RECEPCION_CONVOCATORIA = "09";
	
	
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TDJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocJuntasGenerator")
	@SequenceGenerator(name = "DDTipoDocJuntasGenerator", sequenceName = "S_DD_TDJ_TIPO_DOC_JUNTAS")
	private Long id;
	    
	@Column(name = "DD_TDJ_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDJ_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDJ_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_TDJ_MATRICULA_GD")   
	private String matriculaGD;
	
	@Column(name= "DD_TDJ_VINCULABLE")
	private Integer vinculable;
	    
	@OneToOne
    @JoinColumn(name= "DD_TDJ_TPD_ID")
	private DDTipoDocumentoActivo tipoDocumentoActivo;
	    
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

	public String getMatriculaGD() {
		return matriculaGD;
	}

	public void setMatriculaGD(String matriculaGD) {
		this.matriculaGD = matriculaGD;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Integer getVinculable() {
		return vinculable;
	}

	public void setVinculable(Integer vinculable) {
		this.vinculable = vinculable;
	}

	public DDTipoDocumentoActivo getTipoDocumentoActivo() {
		return tipoDocumentoActivo;
	}

	public void setTipoDocumentoActivo(DDTipoDocumentoActivo tipoDocumentoActivo) {
		this.tipoDocumentoActivo = tipoDocumentoActivo;
	}
	
	
}



