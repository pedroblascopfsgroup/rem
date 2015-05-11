package es.pfsgroup.plugin.recovery.motorBusqueda.api.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

public abstract class DtoAbstractoTareas implements DtoTareas {

    protected Long id;
    protected Long idEntidadInformacion;
    protected String idTipoEntidadInformacion;
    protected boolean enEspera;
    protected boolean esAlerta;
    protected Integer plazo;
    protected String descripcion;
    protected Long perfilUsuario;
    protected String fechaFinComunicacion;
    protected String situacion;
    protected Date fechaCrear;
    protected List<Perfil> perfiles;
    protected List<DDZona> zonas;
    protected Usuario usuarioLogado;
    protected Boolean tienePerfilGestor;
    protected Boolean tienePerfilSupervisor;
    //Campos para busqueda
    protected String ugGestion;
    protected String codigoTipoTarea;
    protected String codigoTipoSubTarea;
    protected boolean busqueda;
    protected String fechaFinDesde;
    protected String fechaFinDesdeOperador;
    protected String fechaFinHasta;
    protected String fechaFinHastaOperador;
    protected String fechaVencimientoDesde;
    protected String fechaVencDesdeOperador;
    protected String fechaVencimientoHasta;
    protected String fechaVencimientoHastaOperador;
    protected String fechaInicioDesde;
    protected String fechaInicioDesdeOperador;
    protected String fechaInicioHasta;
    protected String fechaInicioHastaOperador;
    protected String nombreTarea;
    protected String descripcionTarea;
    protected Boolean traerGestionVencidos;
    protected String gestorSupervisorUsuario;
    protected Long nivelEnTarea;
    protected String zonasAbuscar;
    protected String perfilesAbuscar;
    protected String estadoTarea;
    protected String ambitoTarea;
    protected String nombreUsuario;
    protected String apellidoUsuario;
    protected String usernameUsuario;
    protected Long despacho;
    protected String gestores;
    protected String tipoGestor;
    protected String usuarioDestinoTarea;
    protected String usuarioOrigenTarea;
    protected String tipoAnotacion;
    protected Boolean flagEnvioCorreo;
    protected String tipoGestorTarea;
    protected String busquedaUsuario;
    protected Long idAsunto;
    protected Boolean tieneResponder;
    protected String respuesta;
    
    @Override
	public Long getId() {
		return id;
	}
    
    @Override
	public void setId(Long id) {
		this.id = id;
	}
    
    @Override
	public Long getIdEntidadInformacion() {
		return idEntidadInformacion;
	}
    
    @Override
	public void setIdEntidadInformacion(Long idEntidadInformacion) {
		this.idEntidadInformacion = idEntidadInformacion;
	}
    
    @Override
	public String getIdTipoEntidadInformacion() {
		return idTipoEntidadInformacion;
	}
    
    @Override
	public void setIdTipoEntidadInformacion(String idTipoEntidadInformacion) {
		this.idTipoEntidadInformacion = idTipoEntidadInformacion;
	}
    
    @Override
	public boolean isEnEspera() {
		return enEspera;
	}
    
    @Override
	public void setEnEspera(boolean enEspera) {
		this.enEspera = enEspera;
	}
	
    @Override
    public boolean isEsAlerta() {
		return esAlerta;
	}
    
    @Override
	public void setEsAlerta(boolean esAlerta) {
		this.esAlerta = esAlerta;
	}
    
    @Override
	public Integer getPlazo() {
		return plazo;
	}
    
    @Override
	public void setPlazo(Integer plazo) {
		this.plazo = plazo;
	}
    
    @Override
	public String getDescripcion() {
		return descripcion;
	}
    
    @Override
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
    
    @Override
	public Long getPerfilUsuario() {
		return perfilUsuario;
	}
    
    @Override
	public void setPerfilUsuario(Long perfilUsuario) {
		this.perfilUsuario = perfilUsuario;
	}
    
    @Override
	public String getFechaFinComunicacion() {
		return fechaFinComunicacion;
	}
    
    @Override
	public void setFechaFinComunicacion(String fechaFinComunicacion) {
		this.fechaFinComunicacion = fechaFinComunicacion;
	}
    
    @Override
	public String getSituacion() {
		return situacion;
	}
    
    @Override
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}
    
    @Override
	public Date getFechaCrear() {
		return fechaCrear;
	}
    
    @Override
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
    
    @Override
	public List<Perfil> getPerfiles() {
		return perfiles;
	}
    
    @Override
	public void setPerfiles(List<Perfil> perfiles) {
		this.perfiles = perfiles;
	}
    
    @Override
	public List<DDZona> getZonas() {
		return zonas;
	}
    
    @Override
	public void setZonas(List<DDZona> zonas) {
		this.zonas = zonas;
	}
    
    @Override
	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}
    
    @Override
	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}
    
    @Override
	public Boolean getTienePerfilGestor() {
		return tienePerfilGestor;
	}
    
    @Override
	public void setTienePerfilGestor(Boolean tienePerfilGestor) {
		this.tienePerfilGestor = tienePerfilGestor;
	}
    
    @Override
	public Boolean getTienePerfilSupervisor() {
		return tienePerfilSupervisor;
	}
    
    @Override
	public void setTienePerfilSupervisor(Boolean tienePerfilSupervisor) {
		this.tienePerfilSupervisor = tienePerfilSupervisor;
	}
    
    @Override
	public String getUgGestion() {
		return ugGestion;
	}
    
    @Override
	public void setUgGestion(String ugGestion) {
		this.ugGestion = ugGestion;
	}
    
    @Override
	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}
    
    @Override
	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}
    
    @Override
	public String getCodigoTipoSubTarea() {
		return codigoTipoSubTarea;
	}
    
    @Override
	public void setCodigoTipoSubTarea(String codigoTipoSubTarea) {
		this.codigoTipoSubTarea = codigoTipoSubTarea;
	}
    
    @Override
	public boolean isBusqueda() {
		return busqueda;
	}
    
    @Override
	public void setBusqueda(boolean busqueda) {
		this.busqueda = busqueda;
	}
    
    @Override
	public String getFechaFinDesde() {
		return fechaFinDesde;
	}
    
    @Override
	public void setFechaFinDesde(String fechaFinDesde) {
		this.fechaFinDesde = fechaFinDesde;
	}
    
    @Override
	public String getFechaFinDesdeOperador() {
		return fechaFinDesdeOperador;
	}
    
    @Override
	public void setFechaFinDesdeOperador(String fechaFinDesdeOperador) {
		this.fechaFinDesdeOperador = fechaFinDesdeOperador;
	}
    
    @Override
	public String getFechaFinHasta() {
		return fechaFinHasta;
	}
    
    @Override
	public void setFechaFinHasta(String fechaFinHasta) {
		this.fechaFinHasta = fechaFinHasta;
	}
    
    @Override
	public String getFechaFinHastaOperador() {
		return fechaFinHastaOperador;
	}
    
    @Override
	public void setFechaFinHastaOperador(String fechaFinHastaOperador) {
		this.fechaFinHastaOperador = fechaFinHastaOperador;
	}
    
    @Override
	public String getFechaVencimientoDesde() {
		return fechaVencimientoDesde;
	}
    
    @Override
	public void setFechaVencimientoDesde(String fechaVencimientoDesde) {
		this.fechaVencimientoDesde = fechaVencimientoDesde;
	}
    
    @Override
	public String getFechaVencDesdeOperador() {
		return fechaVencDesdeOperador;
	}
    
    @Override
	public void setFechaVencDesdeOperador(String fechaVencDesdeOperador) {
		this.fechaVencDesdeOperador = fechaVencDesdeOperador;
	}
    
    @Override
	public String getFechaVencimientoHasta() {
		return fechaVencimientoHasta;
	}
    
    @Override
	public void setFechaVencimientoHasta(String fechaVencimientoHasta) {
		this.fechaVencimientoHasta = fechaVencimientoHasta;
	}
    
    @Override
	public String getFechaVencimientoHastaOperador() {
		return fechaVencimientoHastaOperador;
	}
    
    @Override
	public void setFechaVencimientoHastaOperador(
			String fechaVencimientoHastaOperador) {
		this.fechaVencimientoHastaOperador = fechaVencimientoHastaOperador;
	}
    
    @Override
	public String getFechaInicioDesde() {
		return fechaInicioDesde;
	}
    
    @Override
	public void setFechaInicioDesde(String fechaInicioDesde) {
		this.fechaInicioDesde = fechaInicioDesde;
	}
    
    @Override
	public String getFechaInicioDesdeOperador() {
		return fechaInicioDesdeOperador;
	}
    
    @Override
	public void setFechaInicioDesdeOperador(String fechaInicioDesdeOperador) {
		this.fechaInicioDesdeOperador = fechaInicioDesdeOperador;
	}
    
    @Override
	public String getFechaInicioHasta() {
		return fechaInicioHasta;
	}
    
    @Override
	public void setFechaInicioHasta(String fechaInicioHasta) {
		this.fechaInicioHasta = fechaInicioHasta;
	}
    
    @Override
	public String getFechaInicioHastaOperador() {
		return fechaInicioHastaOperador;
	}
    
    @Override
	public void setFechaInicioHastaOperador(String fechaInicioHastaOperador) {
		this.fechaInicioHastaOperador = fechaInicioHastaOperador;
	}
    
    @Override
	public String getNombreTarea() {
		return nombreTarea;
	}
    
    @Override
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}
    
    @Override
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
    
    @Override
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
    
    @Override
	public Boolean getTraerGestionVencidos() {
		return traerGestionVencidos;
	}
    
    @Override
	public void setTraerGestionVencidos(Boolean traerGestionVencidos) {
		this.traerGestionVencidos = traerGestionVencidos;
	}
    
    @Override
	public String getGestorSupervisorUsuario() {
		return gestorSupervisorUsuario;
	}
    
    @Override
	public void setGestorSupervisorUsuario(String gestorSupervisorUsuario) {
		this.gestorSupervisorUsuario = gestorSupervisorUsuario;
	}
    
    @Override
	public Long getNivelEnTarea() {
		return nivelEnTarea;
	}
    
    @Override
	public void setNivelEnTarea(Long nivelEnTarea) {
		this.nivelEnTarea = nivelEnTarea;
	}
    
    @Override
	public String getZonasAbuscar() {
		return zonasAbuscar;
	}
    
    @Override
	public void setZonasAbuscar(String zonasAbuscar) {
		this.zonasAbuscar = zonasAbuscar;
	}
    
    @Override
	public String getPerfilesAbuscar() {
		return perfilesAbuscar;
	}
    
    @Override
	public void setPerfilesAbuscar(String perfilesAbuscar) {
		this.perfilesAbuscar = perfilesAbuscar;
	}
    
    @Override
	public String getEstadoTarea() {
		return estadoTarea;
	}
    
    @Override
	public void setEstadoTarea(String estadoTarea) {
		this.estadoTarea = estadoTarea;
	}
    
    @Override
	public String getAmbitoTarea() {
		return ambitoTarea;
	}
    
    @Override
	public void setAmbitoTarea(String ambitoTarea) {
		this.ambitoTarea = ambitoTarea;
	}
    
    @Override
	public String getNombreUsuario() {
		return nombreUsuario;
	}
    
    @Override
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
    
    @Override
	public String getApellidoUsuario() {
		return apellidoUsuario;
	}
    
    @Override
	public void setApellidoUsuario(String apellidoUsuario) {
		this.apellidoUsuario = apellidoUsuario;
	}
    
    @Override
	public String getUsernameUsuario() {
		return usernameUsuario;
	}
    
    @Override
	public void setUsernameUsuario(String usernameUsuario) {
		this.usernameUsuario = usernameUsuario;
	}
    
    @Override
	public Long getDespacho() {
		return despacho;
	}
    
    @Override
	public void setDespacho(Long despacho) {
		this.despacho = despacho;
	}
    
    @Override
	public String getGestores() {
		return gestores;
	}
    
    @Override
	public void setGestores(String gestores) {
		this.gestores = gestores;
	}
    
    @Override
	public String getTipoGestor() {
		return tipoGestor;
	}
    
    @Override
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
    
    @Override
	public String getUsuarioDestinoTarea() {
		return usuarioDestinoTarea;
	}
    
    @Override
	public void setUsuarioDestinoTarea(String usuarioDestinoTarea) {
		this.usuarioDestinoTarea = usuarioDestinoTarea;
	}
    
    @Override
	public String getUsuarioOrigenTarea() {
		return usuarioOrigenTarea;
	}
    
    @Override
	public void setUsuarioOrigenTarea(String usuarioOrigenTarea) {
		this.usuarioOrigenTarea = usuarioOrigenTarea;
	}
    
    @Override
	public String getTipoAnotacion() {
		return tipoAnotacion;
	}
    
    @Override
	public void setTipoAnotacion(String tipoAnotacion) {
		this.tipoAnotacion = tipoAnotacion;
	}
    
    @Override
	public Boolean getFlagEnvioCorreo() {
		return flagEnvioCorreo;
	}
    
    @Override
	public void setFlagEnvioCorreo(Boolean flagEnvioCorreo) {
		this.flagEnvioCorreo = flagEnvioCorreo;
	}
    
    @Override
	public String getTipoGestorTarea() {
		return tipoGestorTarea;
	}
    
    @Override
	public void setTipoGestorTarea(String tipoGestorTarea) {
		this.tipoGestorTarea = tipoGestorTarea;
	}
    
    @Override
	public String getBusquedaUsuario() {
		return busquedaUsuario;
	}
    
    @Override
	public void setBusquedaUsuario(String busquedaUsuario) {
		this.busquedaUsuario = busquedaUsuario;
	}  
    
    @Override
	public Long getIdAsunto() {
		return idAsunto;
	}
    
    @Override
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
    
    @Override
	public Boolean getTieneResponder() {
		return tieneResponder;
	}
    
    @Override
	public void setTieneResponder(Boolean tieneResponder) {
		this.tieneResponder = tieneResponder;
	}
	
    @Override
	public String getRespuesta() {
		return respuesta;
	}
    
    @Override
	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}  
}
