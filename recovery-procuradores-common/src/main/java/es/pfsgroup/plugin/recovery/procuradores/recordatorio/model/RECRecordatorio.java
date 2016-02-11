package es.pfsgroup.plugin.recovery.procuradores.recordatorio.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;

@Entity
@Table(name = "REC_RECORDATORIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class RECRecordatorio implements Serializable{

	private static final long serialVersionUID = 2981071737733535390L;
	
	 	@Id
	    @Column(name = "REC_ID")
		@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecRecordatorio")
		@SequenceGenerator(name = "RecRecordatorio", sequenceName = "S_REC_RECORDATORIO")
	    private Long id;
	
	    @Column(name = "REC_FECHA")
	    private Date fecha;
	
	    @Column(name = "REC_TITULO")
	    private String titulo;
	    
	    @Column(name = "REC_DESCRIPCION")
	    private String descripcion;
	    
		@ManyToOne
		@JoinColumn(name = "TAR_ID_UNO")	
		private TareaNotificacion tareaUno; 
	
		@ManyToOne
		@JoinColumn(name = "TAR_ID_DOS")	
		private TareaNotificacion tareaDos; 
		
		@ManyToOne
		@JoinColumn(name = "TAR_ID_TRES")	
		private TareaNotificacion tareaTres;
		
		@ManyToOne
		@JoinColumn(name = "USU_ID")	
		private Usuario usuario;
	
	    @Column(name = "REC_OPEN")
	    private Boolean open;
	    
		@ManyToOne
		@JoinColumn(name = "CAT_ID")	
		private Categoria categoria;
		
	
		public Long getId() {
			return id;
		}

		public void setId(Long id) {
			this.id = id;
		}

		public Date getFecha() {
			return fecha;
		}

		public void setFecha(Date fecha) {
			this.fecha = fecha;
		}
		
		public String getTitulo() {
			return titulo;
		}

		public void setTitulo(String titulo) {
			this.titulo = titulo;
		}
		
		public String getDescripcion() {
			return descripcion;
		}

		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}
		
		public TareaNotificacion getTareaUno() {
			return tareaUno;
		}

		public void setTareaUno(TareaNotificacion tareaUno) {
			this.tareaUno = tareaUno;
		}
		
		public TareaNotificacion getTareaDos() {
			return tareaDos;
		}

		public void setTareaDos(TareaNotificacion tareaDos) {
			this.tareaDos = tareaDos;
		}
		
		public TareaNotificacion getTareaTres() {
			return tareaTres;
		}

		public void setTareaTres(TareaNotificacion tareaTres) {
			this.tareaTres = tareaTres;
		}
		
		public Usuario getUsuario() {
			return usuario;
		}

		public void setUsuario(Usuario usuario) {
			this.usuario = usuario;
		}
		
		public Boolean getOpen() {
			return open;
		}

		public void setOpen(Boolean open) {
			this.open = open;
		}
		
		public Categoria getCategoria() {
			return categoria;
		}

		public void setCategoria(Categoria categoria) {
			this.categoria = categoria;
		}
		
	 
}