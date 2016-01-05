package es.capgemini.pfs.tareaNotificacion.model;

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

@Entity
@Table(name = "DD_ENTIDAD_ACUERDO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEntidadAcuerdo implements Auditable, Dictionary {
	
		private static final long serialVersionUID = 170365419645533021L;
		
		public static final String CODIGO_ENTIDAD_EXPEDIENTE = "EXP";
	    public static final String CODIGO_ENTIDAD_ASUNTO = "ASU";
	    public static final String CODIGO_ENTIDAD_AMBAS = "AMBAS";
	    
	    @Id
	    @Column(name="DD_ENT_ACU_ID")
	    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEntidadAcuerdoGenerator")
	    @SequenceGenerator(name = "DDEntidadAcuerdoGenerator", sequenceName = "S_DD_ENTIDAD_ACUERDO")
	    private Long id;
	    
	    @Column(name="DD_ENT_ACU_COD")
	    private String codigo;
	    
	    @Column(name="DD_ENT_ACU_DESCRIPCION")
	    private String descripcion;
	    
	    @Embedded
	    private Auditoria auditoria;
	    @Version
	    private Integer version;
	    
	    
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
		
		public Auditoria getAuditoria() {
			return auditoria;
		}
		
		public void setAuditoria(Auditoria auditoria) {
			this.auditoria = auditoria;
		}
		
		public Integer getVersion() {
			return version;
		}
		
		public void setVersion(Integer version) {
			this.version = version;
		}

		@Override
		public String getDescripcionLarga() {
			// TODO Auto-generated method stub
			return null;
		}

}
