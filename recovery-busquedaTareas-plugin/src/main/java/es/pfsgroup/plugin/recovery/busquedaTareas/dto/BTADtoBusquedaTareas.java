package es.pfsgroup.plugin.recovery.busquedaTareas.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;

/**
 * Clase que transfiere informaci�n desde la vista hacia el modelo.
 * @author Sergio Alarc�n
 *
 */
public class BTADtoBusquedaTareas extends ExtensibleDto implements es.capgemini.devon.pagination.PaginationParams{


    private static final long serialVersionUID = 6015680735564006220L;

    private Long id;
    private Long idEntidadInformacion;
    private String idTipoEntidadInformacion;
    private boolean enEspera;
    private boolean esAlerta;
	private Integer plazo;
	private String descripcion;
	private Long perfilUsuario;
	private String fechaFinComunicacion;
	private String situacion;
	private Date fechaCrear;
	private List<Perfil> perfiles;
	private List<DDZona> zonas;
	private Usuario usuarioLogado;

    private Boolean tienePerfilGestor;
    private Boolean tienePerfilSupervisor;
    
    private boolean busqueda;
    
    private Boolean traerGestionVencidos;
    private String gestorSupervisorUsuario;
    
    private String nombreUsuario;
    private String apellidoUsuario;
    private String usernameUsuario;
	private Boolean usuarioExterno;
	private Long usuarioId;

    //Campos para busqueda
    // Basicos
    private String nombreTarea;
    private String descripcionTarea;
    private String ugGestion;
    private String codigoTipoTarea;
    private String codigoTipoSubTarea;
    private String estadoTarea;
    private String ambitoTarea;
      
    // Fechas
    private String fechaFinDesde;
    private String fechaFinDesdeOperador;
    private String fechaFinHasta;
    private String fechaFinHastaOperador;
    private String fechaVencimientoDesde;
    private String fechaVencDesdeOperador;
    private String fechaVencimientoHasta;
    private String fechaVencimientoHastaOperador;
    private String fechaInicioDesde;
    private String fechaInicioDesdeOperador;
    private String fechaInicioHasta;
    private String fechaInicioHastaOperador;
    
    // Individual
    private String busquedaUsuario;
    private Long despacho;
    private String gestores;
    private String tipoGestor;
    private String tipoGestorTarea; 
        
    // Grupo
    private String perfilesAbuscar;
    private Long nivelEnTarea;
    private String zonasAbuscar;
    
    // Campos para la exportacion
    public static final String SALIDA_XLS = "xls";
    //public static final String SALIDA_LISTADO = "listado";
    

    public Long getDespacho() {
        return despacho;
    }

    public void setDespacho(Long despacho) {
        this.despacho = despacho;
    }

    public String getGestores() {
       return gestores;
    }

    public void setGestores(String gestores) {
       this.gestores = gestores;
    }

    public String getApellidoUsuario() {
        return apellidoUsuario;
    }

    public void setApellidoUsuario(String apellidoUsuario) {
        this.apellidoUsuario = apellidoUsuario;
    }

    public String getUsernameUsuario() {
        return usernameUsuario;
    }

    public void setUsernameUsuario(String usernameUsuario) {
        this.usernameUsuario = usernameUsuario;
    }

	/**
	 * @return the perfiles
	 */
	public List<Perfil> getPerfiles() {
		return perfiles;
	}

	/**
	 * @param perfiles
	 *            the perfiles to set
	 */
	public void setPerfiles(List<Perfil> perfiles) {
		this.perfiles = perfiles;
	}

	/**
	 * @return the situacion
	 */
	public String getSituacion() {
		return situacion;
	}

	/**
	 * @param situacion
	 *            the situacion to set
	 */
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}

	/**
	 * @return the fechaCrear
	 */
	public Date getFechaCrear() {
		return fechaCrear;
	}

	/**
	 * @param fechaCrear
	 *            the fechaCrear to set
	 */
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}

	/**
	 * @return the fechaFinComunicacion
	 */
	public String getFechaFinComunicacion() {
		return fechaFinComunicacion;
	}

	/**
	 * @param fechaFinComunicacion
	 *            the fechaFinComunicacion to set
	 */
	public void setFechaFinComunicacion(String fechaFinComunicacion) {
		this.fechaFinComunicacion = fechaFinComunicacion;
	}

	/**
	 * Retorna el atributo idEntidadInformacion.
	 * 
	 * @return idEntidadInformacion
	 */
	public Long getIdEntidadInformacion() {
		return idEntidadInformacion;
	}

	/**
	 * Setea el atributo idEntidadInformacion.
	 * 
	 * @param idEntidadInformacion
	 *            Long
	 */
	public void setIdEntidadInformacion(Long idEntidadInformacion) {
		this.idEntidadInformacion = idEntidadInformacion;
	}

	/**
	 * Retorna el atributo idEntidadInformacion.
	 * 
	 * @return idEntidadInformacion
	 */
	public String getIdTipoEntidadInformacion() {
		return idTipoEntidadInformacion;
	}

	/**
	 * Setea el atributo idEntidadInformacion.
	 * 
	 * @param idTipoEntidadInformacion
	 *            String
	 */
	public void setIdTipoEntidadInformacion(String idTipoEntidadInformacion) {
		this.idTipoEntidadInformacion = idTipoEntidadInformacion;
	}

	/**
	 * Retorna el atributo idEntidadInformacion.
	 * 
	 * @return idEntidadInformacion
	 */
	public boolean isEnEspera() {
		return enEspera;
	}

	/**
	 * Setea el atributo idEntidadInformacion.
	 * 
	 * @param enEspera
	 *            boolean
	 */
	public void setEnEspera(boolean enEspera) {
		this.enEspera = enEspera;
	}

	/**
	 * Retorna el atributo idEntidadInformacion.
	 * 
	 * @return idEntidadInformacion
	 */
	public boolean isEsAlerta() {
		return esAlerta;
	}

	/**
	 * Setea el atributo esAlerta.
	 * 
	 * @param esAlerta
	 *            boolean
	 */
	public void setEsAlerta(boolean esAlerta) {
		this.esAlerta = esAlerta;
	}

	/**
	 * Retorna el atributo idEntidadInformacion.
	 * 
	 * @return idEntidadInformacion
	 */
	public Integer getPlazo() {
		return plazo;
	}

	/**
	 * Setea el atributo idEntidadInformacion.
	 * 
	 * @param plazo
	 *            Integer
	 */
	public void setPlazo(Integer plazo) {
		this.plazo = plazo;
	}

	/**
	 * Retorna el atributo descripcion.
	 * 
	 * @return descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * Setea el atributo descripcion.
	 * 
	 * @param descripcion
	 *            String
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * Retorna el atributo id.
	 * 
	 * @return id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * Setea el atributo id.
	 * 
	 * @param id
	 *            Long
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the perfilUsuario
	 */
	public Long getPerfilUsuario() {
		return perfilUsuario;
	}

	/**
	 * @param perfilUsuario
	 *            the perfilUsuario to set
	 */
	public void setPerfilUsuario(Long perfilUsuario) {
		this.perfilUsuario = perfilUsuario;
	}

	/**
	 * @return the codigoTipoTarea
	 */
	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}

	/**
	 * @param codigoTipoTarea
	 *            the codigoTipoTarea to set
	 */
	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}

	/**
	 * @return the zonas
	 */
	public List<DDZona> getZonas() {
		return zonas;
	}

	/**
	 * @param zonas
	 *            the zonas to set
	 */
	public void setZonas(List<DDZona> zonas) {
		this.zonas = zonas;
	}

	/**
	 * @return the tienePerfilGestor
	 */
	public Boolean getTienePerfilGestor() {
		return tienePerfilGestor;
	}

	/**
	 * @param tienePerfilGestor
	 *            the tienePerfilGestor to set
	 */
	public void setTienePerfilGestor(Boolean tienePerfilGestor) {
		this.tienePerfilGestor = tienePerfilGestor;
	}

	/**
	 * @return the tienePerfilSupervisor
	 */
	public Boolean getTienePerfilSupervisor() {
		return tienePerfilSupervisor;
	}

	/**
	 * @param tienePerfilSupervisor
	 *            the tienePerfilSupervisor to set
	 */
	public void setTienePerfilSupervisor(Boolean tienePerfilSupervisor) {
		this.tienePerfilSupervisor = tienePerfilSupervisor;
	}

	/**
	 * @return the usuarioLogado
	 */
	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}

	/**
	 * @param usuarioLogado
	 *            the usuarioLogado to set
	 */
	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}

	/**
	 * @return the busqueda
	 */
	public boolean isBusqueda() {
		return busqueda;
	}

	/**
	 * @param busqueda
	 *            the busqueda to set
	 */
	public void setBusqueda(boolean busqueda) {
		this.busqueda = busqueda;
	}

	/**
	 * @return the fechaVencimientoDesde
	 */
	public String getFechaVencimientoDesde() {
		return fechaVencimientoDesde;
	}

	/**
	 * @param fechaVencimientoDesde
	 *            the fechaVencimientoDesde to set
	 */
	public void setFechaVencimientoDesde(String fechaVencimientoDesde) {
		this.fechaVencimientoDesde = fechaVencimientoDesde;
	}

	/**
	 * @return the fechaVencDesdeOperador
	 */
	public String getFechaVencDesdeOperador() {
		return fechaVencDesdeOperador;
	}

	/**
	 * @param fechaVencDesdeOperador
	 *            the fechaVencDesdeOperador to set
	 */
	public void setFechaVencDesdeOperador(String fechaVencDesdeOperador) {
		this.fechaVencDesdeOperador = fechaVencDesdeOperador;
	}

	/**
	 * @return the fechaVencimientoHasta
	 */
	public String getFechaVencimientoHasta() {
		return fechaVencimientoHasta;
	}

	/**
	 * @param fechaVencimientoHasta
	 *            the fechaVencimientoHasta to set
	 */
	public void setFechaVencimientoHasta(String fechaVencimientoHasta) {
		this.fechaVencimientoHasta = fechaVencimientoHasta;
	}

	/**
	 * @return the fechaVencimientoHastaOperador
	 */
	public String getFechaVencimientoHastaOperador() {
		return fechaVencimientoHastaOperador;
	}

	/**
	 * @param fechaVencimientoHastaOperador
	 *            the fechaVencimientoHastaOperador to set
	 */
	public void setFechaVencimientoHastaOperador(
			String fechaVencimientoHastaOperador) {
		this.fechaVencimientoHastaOperador = fechaVencimientoHastaOperador;
	}

	/**
	 * @return the fechaInicioDesde
	 */
	public String getFechaInicioDesde() {
		return fechaInicioDesde;
	}

	/**
	 * @param fechaInicioDesde
	 *            the fechaInicioDesde to set
	 */
	public void setFechaInicioDesde(String fechaInicioDesde) {
		this.fechaInicioDesde = fechaInicioDesde;
	}

	/**
	 * @return the fechaInicioDesdeOperador
	 */
	public String getFechaInicioDesdeOperador() {
		return fechaInicioDesdeOperador;
	}

	/**
	 * @param fechaInicioDesdeOperador
	 *            the fechaInicioDesdeOperador to set
	 */
	public void setFechaInicioDesdeOperador(String fechaInicioDesdeOperador) {
		this.fechaInicioDesdeOperador = fechaInicioDesdeOperador;
	}

	/**
	 * @return the fechaInicioHasta
	 */
	public String getFechaInicioHasta() {
		return fechaInicioHasta;
	}

	/**
	 * @param fechaInicioHasta
	 *            the fechaInicioHasta to set
	 */
	public void setFechaInicioHasta(String fechaInicioHasta) {
		this.fechaInicioHasta = fechaInicioHasta;
	}

	/**
	 * @return the fechaInicioHastaOperador
	 */
	public String getFechaInicioHastaOperador() {
		return fechaInicioHastaOperador;
	}

	/**
	 * @param fechaInicioHastaOperador
	 *            the fechaInicioHastaOperador to set
	 */
	public void setFechaInicioHastaOperador(String fechaInicioHastaOperador) {
		this.fechaInicioHastaOperador = fechaInicioHastaOperador;
	}

	/**
	 * @return the nombreTarea
	 */
	public String getNombreTarea() {
		return nombreTarea;
	}

	/**
	 * @param nombreTarea
	 *            the nombreTarea to set
	 */
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}

	/**
	 * @return the descripcionTarea
	 */
	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	/**
	 * @param descripcionTarea
	 *            the descripcionTarea to set
	 */
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	/**
	 * @return the traerGestionVencidos
	 */
	public Boolean getTraerGestionVencidos() {
		return traerGestionVencidos;
	}

	/**
	 * @param traerGestionVencidos
	 *            the traerGestionVencidos to set
	 */
	public void setTraerGestionVencidos(Boolean traerGestionVencidos) {
		this.traerGestionVencidos = traerGestionVencidos;
	}

	public void setCodigoTipoSubTarea(String codigoTipoSubTarea) {
		this.codigoTipoSubTarea = codigoTipoSubTarea;
	}

	public String getCodigoTipoSubTarea() {
		return codigoTipoSubTarea;
	}

	public void setUgGestion(String ugGestion) {
		this.ugGestion = ugGestion;
	}

	public String getUgGestion() {
		return ugGestion;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setGestorSupervisorUsuario(String gestorSupervisorUsuario) {
		this.gestorSupervisorUsuario = gestorSupervisorUsuario;
	}

	public String getGestorSupervisorUsuario() {
		return gestorSupervisorUsuario;
	}

	public void setNivelEnTarea(Long nivelEnTarea) {
		this.nivelEnTarea = nivelEnTarea;
	}

	public Long getNivelEnTarea() {
		return nivelEnTarea;
	}

	public void setZonasAbuscar(String zonasAbuscar) {
		this.zonasAbuscar = zonasAbuscar;
	}

	public String getZonasAbuscar() {
		return zonasAbuscar;
	}

	public void setFechaFinDesde(String fechaFinDesde) {
		this.fechaFinDesde = fechaFinDesde;
	}

	public String getFechaFinDesde() {
		return fechaFinDesde;
	}

	public String getFechaFinDesdeOperador() {
		return fechaFinDesdeOperador;
	}

	public void setFechaFinDesdeOperador(String fechaFinDesdeOperador) {
		this.fechaFinDesdeOperador = fechaFinDesdeOperador;
	}

	public String getFechaFinHasta() {
		return fechaFinHasta;
	}

	public void setFechaFinHasta(String fechaFinHasta) {
		this.fechaFinHasta = fechaFinHasta;
	}

	public String getFechaFinHastaOperador() {
		return fechaFinHastaOperador;
	}

	public void setFechaFinHastaOperador(String fechaFinHastaOperador) {
		this.fechaFinHastaOperador = fechaFinHastaOperador;
	}

	public void setPerfilesAbuscar(String perfilesAbuscar) {
		this.perfilesAbuscar = perfilesAbuscar;
	}

	public String getPerfilesAbuscar() {
		return perfilesAbuscar;
	}

	public void setEstadoTarea(String estadoTarea) {
		this.estadoTarea = estadoTarea;
	}

	public String getEstadoTarea() {
		return estadoTarea;
	}

	public void setAmbitoTarea(String ambitoTarea) {
		this.ambitoTarea = ambitoTarea;
	}

	public String getAmbitoTarea() {
		return ambitoTarea;
	}

	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public String getTipoGestor() {
		return tipoGestor;
	}

	public String getTipoGestorTarea() {
		return tipoGestorTarea;
	}

	public void setTipoGestorTarea(String tipoGestorTarea) {
		this.tipoGestorTarea = tipoGestorTarea;
	}

	public String getBusquedaUsuario() {
		return busquedaUsuario;
	}

	public void setBusquedaUsuario(String busquedaUsuario) {
		this.busquedaUsuario = busquedaUsuario;
	}

	public Long getUsuarioId() {
		return usuarioId;
	}

	public void setUsuarioId(Long usuarioId) {
		this.usuarioId = usuarioId;
	}

	public Boolean getUsuarioExterno() {
		return usuarioExterno;
	}

	public void setUsuarioExterno(Boolean usuarioExterno) {
		this.usuarioExterno = usuarioExterno;
	}
	
}