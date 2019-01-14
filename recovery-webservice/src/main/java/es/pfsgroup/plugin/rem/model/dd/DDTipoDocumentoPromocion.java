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
	 * Modelo que gestiona el diccionario de los tipos de documentos adjuntados de los activos de agrupaciones de tipo proyecto
	 * @author jros
	 *
	 */
	@Entity
	@Table(name = "DD_TDP_TIPO_DOC_PRO", schema = "${entity.schema}")
	@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	public class DDTipoDocumentoPromocion implements Auditable, Dictionary {
		
		//public static final String CODIGO_IDENTIFICACION= "01";
	    //public static final String CODIGO_TANTEO = "02";
	    //public static final String CODIGO_RESERVA = "03";
	    //public static final String CODIGO_FORMALIZACION = "04";
	    //public static final String CODIGO_SANCION = "05";
	    
		    
		/**
		 * 
		 */
		private static final long serialVersionUID = 4995317294002266864L;

		@Id
		@Column(name = "DD_TDP_ID")
		@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoPromocionGenerator")
		@SequenceGenerator(name = "DDTipoDocumentoPromocionGenerator", sequenceName = "S_DD_TDP_TIPO_DOC_PRO")
		private Long id;
		 
		@Column(name = "DD_TDP_CODIGO")   
		private String codigo;
		 
		@Column(name = "DD_TDP_DESCRIPCION")   
		private String descripcion;
		    
		@Column(name = "DD_TDP_DESCRIPCION_LARGA")   
		private String descripcionLarga;
		
		@Column(name = "DD_TDP_MATRICULA_GD")
		private String matricula;
		    
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

		public String getMatricula() {
			return matricula;
		}

		public void setMatricula(String matricula) {
			this.matricula = matricula;
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
