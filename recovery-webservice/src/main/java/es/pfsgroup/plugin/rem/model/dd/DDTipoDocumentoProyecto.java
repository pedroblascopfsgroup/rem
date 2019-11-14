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
	 * @author Miguel Ángel Ávila Sánchez
	 *
	 */


	/**
	 * DD_TDY_ID (NUMBER(16,0))
	 * DD_TDY_CODIGO VARCHAR2(20 CHAR)
	 * DD_TDY_DESCRIPCION VARCHAR2(100 CHAR)
	 * DD_TDY_DESCRIPCION_LARGA VARCHAR2(250 CHAR)
	 * VERSION
	 * USUARIOCREAR
	 * FECHACREAR
	 * USUARIOMODIFICAR
	 * FECHAMODIFICAR
	 * USUARIOBORRAR
	 * FECHABORRAR
	 * BORRADO
	 * DD_TDY_MATRICULA_GD (VARCHAR2(20))
	 * DD_TDY_VISIBLE (NUMBER(1,0))
	 */

	@Entity
	@Table(name = "DD_TDY_TIPO_DOC_PROYECTO", schema = "${entity.schema}")
	@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	public class DDTipoDocumentoProyecto implements Auditable, Dictionary {
		
	    
		    
		/**
		 * 
		 */
		private static final long serialVersionUID = 7730561037355900493L;


		@Id
		@Column(name = "DD_TDY_ID")
		@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoProyectoGenerator")
		@SequenceGenerator(name = "DDTipoDocumentoProyectoGenerator", sequenceName = "S_DD_TDP_TIPO_DOC_PRO")
		private Long id;
		 
		@Column(name = "DD_TDY_CODIGO")   
		private String codigo;
		 
		@Column(name = "DD_TDY_DESCRIPCION")   
		private String descripcion;
		    
		@Column(name = "DD_TDY_DESCRIPCION_LARGA")   
		private String descripcionLarga;
		    
		@Version   
		private Long version;

		@Embedded
		private Auditoria auditoria;
		
		@Column(name = "DD_TDY_MATRICULA_GD")
		private String matricula;
		
		@Column(name = "DD_TDY_VISIBLE")
		private Integer visible = 0;
		
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
		
		public Integer getVisible() {
			return visible;
		}

		public void setVisible(Integer visible) {
			this.visible = visible;
		}
	
	
}
