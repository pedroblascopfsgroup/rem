package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
 * Modelo que gestiona el diccionario de tributo a terceros 
 * 
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "DD_TRT_TRIBUTOS_A_TERCEROS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTributosTerceros implements Auditable, Dictionary {
	

	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_RECARGOS_Y_SANCIONES = "K01";
	public static final String CODIGO_IBI_ANTERIOR_A_COMPRA = "K03";
	public static final String CODIGO_PLUSVALIA_COMPRA = "K04";
	public static final String CODIGO_OTRAS_TASAS_TRIB_ANT = "K06";
	

	@Id
	@Column(name = "DD_TRT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTributosTercerosGenerator")
	@SequenceGenerator(name = "DDTributosTercerosGenerator", sequenceName = "DD_TRT_TRIBUTOS_A_TERCEROS")
	private Long id;
	
	@Column(name = "DD_TRT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TRT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TRT_DESCRIPCION_LARGA")   
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

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}
}
