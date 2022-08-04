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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de categoria de conducta inapropiada
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "DD_CCI_CAT_CONDUC_INAPROP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCategoriaConductaInapropiada implements Auditable, Dictionary {
	
	public static final String COD_PERDIDA = "01";
	public static final String COD_NO_DEVUELVE_LLAVES = "02";
	public static final String COD_NO_TRASPASA_LLAVES = "03";
	public static final String COD_CEDE_LLAVES_TERCERO = "04";
	public static final String COD_NO_REALIZA_INFORME = "05";
	public static final String COD_PUBLICA_IMPORTE_INCORRECTO = "06";
	public static final String COD_NO_LLAMA_CLIENTE = "07";
	public static final String COD_CIERRA_OPORTUNIDAD = "08";
	public static final String COD_NO_PRESENTA_VISITA = "09";
	public static final String COD_COBRO_COMISION = "10";
	public static final String COD_PRESENTA_OFERTA_PROPIA = "11";

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_CCI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCategoriaConductaInapropiadaGenerator")
	@SequenceGenerator(name = "DDCategoriaConductaInapropiadaGenerator", sequenceName = "S_DD_CCI_CAT_CONDUC_INAPROP")
	private Long id;
	  
	@JoinColumn(name = "DD_TCI_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoConductaInapropiada tipoConducta;
	
	@JoinColumn(name = "DD_NCI_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDNivelConductaInapropiada nivelConducta;
	
	@Column(name = "DD_CCI_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_CCI_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_CCI_DESCRIPCION_LARGA")   
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

	public DDTipoConductaInapropiada getTipoConducta() {
		return tipoConducta;
	}

	public void setTipoConducta(DDTipoConductaInapropiada tipoConducta) {
		this.tipoConducta = tipoConducta;
	}

	public DDNivelConductaInapropiada getNivelConducta() {
		return nivelConducta;
	}

	public void setNivelConducta(DDNivelConductaInapropiada nivelConducta) {
		this.nivelConducta = nivelConducta;
	}

}
