package es.pfsgroup.plugin.recovery.procuradores.tareas.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

public class PCDProcuradoresDto extends PaginationParamsImpl{
	private static final long serialVersionUID = -2459022087089362585L;
	
	private Long usuario;
	private Long tarea;
	private Long asunto;
	private String tareaTarea;
	private String tareaDescripcion;
	private Long procedimiento;
	private Date fechaVencimiento;
	private String resolucion;
	private Long idResolucion;
	private Long idCategoria;
	private Long idCategorizacion;
	private Long idTipoResolucion;
	private String estadoProcesoCodigo;
	
	/*
	 * Atributos DtoBuscarTareaNotificacion
	 */
	
    private Long id;
    private Long idEntidadInformacion;
    private String idTipoEntidadInformacion;
    
	private String codigoSubtipoTarea;
    private boolean enEspera;
    private boolean esAlerta;
    private Integer plazo;
    private String descripcion;
    private Long perfilUsuario;
    private String codigoTipoTarea;
    private String fechaFinComunicacion;
    private String situacion;
    private Date fechaCrear;
    private List<Perfil> perfiles;
    private List<DDZona> zonas;
    private Usuario usuarioLogado;

    private Boolean tienePerfilGestor;
    private Boolean tienePerfilSupervisor;
    
    //Campos para busqueda
    private boolean busqueda;
    private String fechaVencimientoDesde;
    private String fechaVencDesdeOperador;
    private String fechaVencimientoHasta;
    private String fechaVencimientoHastaOperador;

    private String fechaInicioDesde;
    private String fechaInicioDesdeOperador;
    private String fechaInicioHasta;
    private String fechaInicioHastaOperador;

    private String nombreTarea;
    private String descripcionTarea;

    private Boolean traerGestionVencidos;
	
    private String tipoAccionCodigo;
    
	public Long getUsuario() {
		return usuario;
	}
	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}
	public Long getTarea() {
		return tarea;
	}
	public void setTarea(Long tarea) {
		this.tarea = tarea;
	}
	public Long getAsunto() {
		return asunto;
	}
	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}
	public String getTareaTarea() {
		return tareaTarea;
	}
	public void setTareaTarea(String tareaTarea) {
		this.tareaTarea = tareaTarea;
	}
	public String getTareaDescripcion() {
		return tareaDescripcion;
	}
	public void setTareaDescripcion(String tareaDescripcion) {
		this.tareaDescripcion = tareaDescripcion;
	}
	public Long getProcedimiento() {
		return procedimiento;
	}
	public void setProcedimiento(Long procedimiento) {
		this.procedimiento = procedimiento;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getResolucion() {
		return resolucion;
	}
	public void setResolucion(String resolucion) {
		this.resolucion = resolucion;
	}
	public Long getIdResolucion() {
		return idResolucion;
	}
	public void setIdResolucion(Long idResolucion) {
		this.idResolucion = idResolucion;
	}
	public Long getIdCategoria() {
		return idCategoria;
	}
	public void setIdCategoria(Long idCategoria) {
		this.idCategoria = idCategoria;
	}
	
	
	/*
	 * Getter/Setter DtoBuscarTareaNotificacion
	 * */
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdEntidadInformacion() {
		return idEntidadInformacion;
	}
	public void setIdEntidadInformacion(Long idEntidadInformacion) {
		this.idEntidadInformacion = idEntidadInformacion;
	}
	public String getIdTipoEntidadInformacion() {
		return idTipoEntidadInformacion;
	}
	public void setIdTipoEntidadInformacion(String idTipoEntidadInformacion) {
		this.idTipoEntidadInformacion = idTipoEntidadInformacion;
	}
	public String getCodigoSubtipoTarea() {
		return codigoSubtipoTarea;
	}
	public void setCodigoSubtipoTarea(String codigoSubtipoTarea) {
		this.codigoSubtipoTarea = codigoSubtipoTarea;
	}
	public boolean isEnEspera() {
		return enEspera;
	}
	public void setEnEspera(boolean enEspera) {
		this.enEspera = enEspera;
	}
	public boolean isEsAlerta() {
		return esAlerta;
	}
	public void setEsAlerta(boolean esAlerta) {
		this.esAlerta = esAlerta;
	}
	public Integer getPlazo() {
		return plazo;
	}
	public void setPlazo(Integer plazo) {
		this.plazo = plazo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Long getPerfilUsuario() {
		return perfilUsuario;
	}
	public void setPerfilUsuario(Long perfilUsuario) {
		this.perfilUsuario = perfilUsuario;
	}
	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}
	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}
	public String getFechaFinComunicacion() {
		return fechaFinComunicacion;
	}
	public void setFechaFinComunicacion(String fechaFinComunicacion) {
		this.fechaFinComunicacion = fechaFinComunicacion;
	}
	public String getSituacion() {
		return situacion;
	}
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	public List<Perfil> getPerfiles() {
		return perfiles;
	}
	public void setPerfiles(List<Perfil> perfiles) {
		this.perfiles = perfiles;
	}
	public List<DDZona> getZonas() {
		return zonas;
	}
	public void setZonas(List<DDZona> zonas) {
		this.zonas = zonas;
	}
	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}
	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}
	public Boolean getTienePerfilGestor() {
		return tienePerfilGestor;
	}
	public void setTienePerfilGestor(Boolean tienePerfilGestor) {
		this.tienePerfilGestor = tienePerfilGestor;
	}
	public Boolean getTienePerfilSupervisor() {
		return tienePerfilSupervisor;
	}
	public void setTienePerfilSupervisor(Boolean tienePerfilSupervisor) {
		this.tienePerfilSupervisor = tienePerfilSupervisor;
	}
	public boolean isBusqueda() {
		return busqueda;
	}
	public void setBusqueda(boolean busqueda) {
		this.busqueda = busqueda;
	}
	public String getFechaVencimientoDesde() {
		return fechaVencimientoDesde;
	}
	public void setFechaVencimientoDesde(String fechaVencimientoDesde) {
		this.fechaVencimientoDesde = fechaVencimientoDesde;
	}
	public String getFechaVencDesdeOperador() {
		return fechaVencDesdeOperador;
	}
	public void setFechaVencDesdeOperador(String fechaVencDesdeOperador) {
		this.fechaVencDesdeOperador = fechaVencDesdeOperador;
	}
	public String getFechaVencimientoHasta() {
		return fechaVencimientoHasta;
	}
	public void setFechaVencimientoHasta(String fechaVencimientoHasta) {
		this.fechaVencimientoHasta = fechaVencimientoHasta;
	}
	public String getFechaVencimientoHastaOperador() {
		return fechaVencimientoHastaOperador;
	}
	public void setFechaVencimientoHastaOperador(
			String fechaVencimientoHastaOperador) {
		this.fechaVencimientoHastaOperador = fechaVencimientoHastaOperador;
	}
	public String getFechaInicioDesde() {
		return fechaInicioDesde;
	}
	public void setFechaInicioDesde(String fechaInicioDesde) {
		this.fechaInicioDesde = fechaInicioDesde;
	}
	public String getFechaInicioDesdeOperador() {
		return fechaInicioDesdeOperador;
	}
	public void setFechaInicioDesdeOperador(String fechaInicioDesdeOperador) {
		this.fechaInicioDesdeOperador = fechaInicioDesdeOperador;
	}
	public String getFechaInicioHasta() {
		return fechaInicioHasta;
	}
	public void setFechaInicioHasta(String fechaInicioHasta) {
		this.fechaInicioHasta = fechaInicioHasta;
	}
	public String getFechaInicioHastaOperador() {
		return fechaInicioHastaOperador;
	}
	public void setFechaInicioHastaOperador(String fechaInicioHastaOperador) {
		this.fechaInicioHastaOperador = fechaInicioHastaOperador;
	}
	public String getNombreTarea() {
		return nombreTarea;
	}
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
	public Boolean getTraerGestionVencidos() {
		return traerGestionVencidos;
	}
	public void setTraerGestionVencidos(Boolean traerGestionVencidos) {
		this.traerGestionVencidos = traerGestionVencidos;
	}
	public Long getIdCategorizacion() {
		return idCategorizacion;
	}
	public void setIdCategorizacion(Long idCategorizacion) {
		this.idCategorizacion = idCategorizacion;
	}
	public Long getIdTipoResolucion() {
		return idTipoResolucion;
	}
	public void setIdTipoResolucion(Long idTipoResolucion) {
		this.idTipoResolucion = idTipoResolucion;
	}
	public String getEstadoProcesoCodigo() {
        return estadoProcesoCodigo;
    }
    public void setEstadoProcesoCodigo(String estadoProcesoCodigo) {
        this.estadoProcesoCodigo = estadoProcesoCodigo;
    }
	public String getTipoAccionCodigo() {
        return tipoAccionCodigo;
    }
	public void setTipoAccionCodigo(String tipoAccionCodigo) {
        this.tipoAccionCodigo = tipoAccionCodigo;
    }
}