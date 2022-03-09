

package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de tipos de gastos
 */
@Entity
@Table(name = "DD_STG_SUBTIPOS_GASTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoGasto implements Auditable, Dictionary {
	
    public static final String OTROS = "01";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final String COD_AGUA = "103"; 
	public static final String COD_ALCANTARILLADO = "104"; 
	public static final String COD_BASURA = "105"; 
	public static final String COD_EXACCIONES_MUNICIPALES = "106"; 
	public static final String COD_OTRAS_TASAS_MUNICIPALES = "107"; 
	public static final String COD_TASA_CANALONES = "108"; 
	public static final String COD_TASA_INCENDIOS = "109"; 
	public static final String COD_REGULACION_CATASTRAL = "110"; 
	public static final String COD_TASAS_ADMINISTRATIVAS = "111"; 
	public static final String COD_TRIBUTO_METROPOLITANO_MOVILIDAD = "112"; 
	public static final String COD_VADO = "113"; 
	public static final String COD_HONORARIOS_GESTION_ACTIVOS = "53";
	public static final String COD_REGISTRO = "43";
	public static final String COD_NOTARIA = "44";
	public static final String COD_ABOGADO = "45";
	public static final String COD_PROCURADOR = "46";
	public static final String COD_OTROS_SERVICIOS_JURIDICOS = "47";
	public static final String COD_ADMINISTRADOR_COMUNIDAD_PROPIETARIOS = "48";
	public static final String COD_ASESORIA = "49";
	public static final String COD_TECNICO = "50";
	public static final String COD_TASACION = "51";
	public static final String COD_OTROS = "52";
	public static final String COD_GESTION_DE_SUELO = "94";
	public static final String COD_ABOGADO_OCUPACIONAL = "95";
	public static final String COD_ABOGADO_ASUNTOS_GENERALES = "96";
	public static final String COD_ABOGADO_ASISTENCIA_JURIDiCA = "97";

	@Id
	@Column(name = "DD_STG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubTipoGastoGenerator")
	@SequenceGenerator(name = "DDSubTipoGastoGenerator", sequenceName = "S_DD_STG_SUBTIPOS_GASTO")
	private Long id;
	
	@JoinColumn(name = "DD_TGA_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoGasto tipoGasto;
	    
	@Column(name = "DD_STG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_STG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_STG_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_STG_GPV_PRO_BC")   
	private boolean gastoEnCaixa;
	
	@Transient
	private String tipoGastoCodigo;
	    
	
	    
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

	public DDTipoGasto getTipoGasto() {
		return tipoGasto;
	}

	public void setTipoGasto(DDTipoGasto tipoGasto) {
		this.tipoGasto = tipoGasto;
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

	public String getTipoGastoCodigo() {
		return !Checks.esNulo(tipoGasto) ? this.tipoGastoCodigo = tipoGasto.getCodigo(): null;
	}

	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = !Checks.esNulo(tipoGastoCodigo) ? tipoGastoCodigo : tipoGasto.getCodigo();
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

	public boolean isGastoEnCaixa() {
		return gastoEnCaixa;
	}

	public void setGastoEnCaixa(boolean gastoEnCaixa) {
		this.gastoEnCaixa = gastoEnCaixa;
	}
	
}