package es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto;

import java.io.Serializable;
import java.util.Date;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;


public class RECRecordatorioDto extends PaginationParamsImpl implements Serializable{

	private static final long serialVersionUID = 2981071737733535390L;
	

	    private Long id;
	    private Date fecha;
	    private String titulo;
	    private String descripcion;	
		private TareaNotificacion tareaUno; 	
		private TareaNotificacion tareaDos; 	
		private TareaNotificacion tareaTres;
		private Usuario usuario;
		private Boolean open;
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