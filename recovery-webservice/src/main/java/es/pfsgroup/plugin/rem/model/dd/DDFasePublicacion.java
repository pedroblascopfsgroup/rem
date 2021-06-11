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

@Entity
@Table(name = "DD_FSP_FASE_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDFasePublicacion implements Auditable, Dictionary {
	

	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_NO_APLICA = "01";
	public static final String CODIGO_FASE_0_CALIDAD_PENDIENTE = "02";
	public static final String CODIGO_FASE_I_PENDIENTE_ACTUACIONES_PREVIAS = "03";
	public static final String CODIGO_FASE_II_PENDIENTE_LLAVES = "04";
	public static final String CODIGO_FASE_III_PENDIENTE_INFORMACION = "05";
	public static final String CODIGO_FASE_IV_PENDIENTE_PRECIO = "08";
	public static final String CODIGO_FASE_V_INCIDENCIAS_PUBLICACION = "09";
	public static final String CODIGO_FASE_VI_CALIDAD_COMPROBADA = "10";


	@Id
	@Column(name = "DD_FSP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDFasePublicacionGenerator")
	@SequenceGenerator(name = "DDFasePublicacionGenerator", sequenceName = "S_DD_FSP_FASE_PUBLICACION")
	private Long id;
	    
	@Column(name = "DD_FSP_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_FSP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_FSP_DESCRIPCION_LARGA")   
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

	public static boolean isFaseTres(DDFasePublicacion fase) {
		boolean esLaMisma = false;
		
		if(fase != null && CODIGO_FASE_III_PENDIENTE_INFORMACION.equals(fase.getCodigo())) {
			esLaMisma = true;
		}
		
		return esLaMisma;
	}
}