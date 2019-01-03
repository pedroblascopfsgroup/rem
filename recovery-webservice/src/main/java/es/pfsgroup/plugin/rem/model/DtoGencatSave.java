package es.pfsgroup.plugin.rem.model;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Dto para la subpestaña GENCAT de la pestaña Comercial del Activo, se utilizará para el guardado del formulario
 * 
 * @author Isidro Sotoca
 *
 */
public class DtoGencatSave extends DtoTabActivo {

	private static final long serialVersionUID = -1471368154602764594L;
	private SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
	
	//ID Activo
	private Long idActivo;
	
	//Datos comunicación
	private Date dateFechaPreBloqueo;
	private String fechaPreBloqueo;	
	private Date dateFechaComunicacion;
	private String fechaComunicacion;
	private Date dateFechaPrevistaSancion;
	private String fechaPrevistaSancion;
	private Date dateFechaSancion;	
	private String fechaSancion;
	
	private String sancion;
	private String nuevoCompradorNif;
	private String nuevoCompradorNombre;
	private String nuevoCompradorApellido1;
	private String nuevoCompradorApellido2;
	private String estadoComunicacion;
	private Date dateFechaAnulacion;
	private String fechaAnulacion;
	private Boolean comunicadoAnulacionAGencat;
	
	//Adecuacion
	private Boolean necesitaReforma;
	private Long importeReforma;
	private Date dateFechaRevision;
	private String fechaRevision;
	
	//Visita
	private Long idVisita;
	private String estadoVisita;
	private String apiRealizaLaVisita;
	private Date dateFechaRealizacionVisita;
	private String fechaRealizacionVisita;
	
	//Notificacion
	private Boolean checkNotificacion;
	private String fechaNotificacion;
	private Date dateFechaNotificacion;
	private String motivoNotificacion;
	private String documentoNotificion;
	private Date dateFechaSancionNotificacion;
	private String fechaSancionNotificacion;
	private Date dateCierreNotificacion;
	private String cierreNotificacion;
	
	//Oferta
	private Long ofertaGencat;
	private Long idOfertaAnterior;
	
	public Date getDateFechaPreBloqueo() {
		return dateFechaPreBloqueo;
	}
	public void setFechaPreBloqueo(String fechaPreBloqueo) {
		try { 
			if( fechaPreBloqueo!=null && !fechaPreBloqueo.isEmpty() ) {
				this.fechaPreBloqueo = fechaPreBloqueo;
				this.dateFechaPreBloqueo = dateformat.parse( fechaPreBloqueo );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Date getDateFechaComunicacion() {
		return dateFechaComunicacion;
	}
	public void setFechaComunicacion(String fechaComunicacion) {
		try { 
			if( fechaComunicacion!=null && !fechaComunicacion.isEmpty() ) {
				this.fechaComunicacion = fechaComunicacion;
				this.dateFechaComunicacion = dateformat.parse( fechaComunicacion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Date getDateFechaPrevistaSancion() {
		return dateFechaPrevistaSancion;
	}
	public void setFechaPrevistaSancion(String fechaPrevistaSancion) {
		try {
			if( fechaPrevistaSancion!=null && !fechaPrevistaSancion.isEmpty() ) {
				this.fechaPrevistaSancion = fechaPrevistaSancion;
				this.dateFechaPrevistaSancion = dateformat.parse( fechaPrevistaSancion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Date getDateFechaSancion() {
		return dateFechaSancion;
	}
	public void setFechaSancion(String fechaSancion) {
		try {
			if( fechaSancion!=null && !fechaSancion.isEmpty() ) {
				this.fechaSancion = fechaSancion;
				this.dateFechaSancion = dateformat.parse( fechaSancion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public SimpleDateFormat getDateformat() {
		return dateformat;
	}
	public void setDateformat(SimpleDateFormat dateformat) {
		this.dateformat = dateformat;
	}
	public void setDateFechaPreBloqueo(Date dateFechaPreBloqueo) {
		this.dateFechaPreBloqueo = dateFechaPreBloqueo;
	}
	public void setDateFechaComunicacion(Date dateFechaComunicacion) {
		this.dateFechaComunicacion = dateFechaComunicacion;
	}
	public void setDateFechaPrevistaSancion(Date dateFechaPrevistaSancion) {
		this.dateFechaPrevistaSancion = dateFechaPrevistaSancion;
	}
	public void setDateFechaSancion(Date dateFechaSancion) {
		this.dateFechaSancion = dateFechaSancion;
	}
	public void setDateFechaAnulacion(Date dateFechaAnulacion) {
		this.dateFechaAnulacion = dateFechaAnulacion;
	}
	public void setDateFechaRevision(Date dateFechaRevision) {
		this.dateFechaRevision = dateFechaRevision;
	}
	public void setDateFechaRealizacionVisita(Date dateFechaRealizacionVisita) {
		this.dateFechaRealizacionVisita = dateFechaRealizacionVisita;
	}
	public void setDateFechaNotificacion(Date dateFechaNotificacion) {
		this.dateFechaNotificacion = dateFechaNotificacion;
	}
	public void setDateFechaSancionNotificacion(Date dateFechaSancionNotificacion) {
		this.dateFechaSancionNotificacion = dateFechaSancionNotificacion;
	}
	public void setDateCierreNotificacion(Date dateCierreNotificacion) {
		this.dateCierreNotificacion = dateCierreNotificacion;
	}
	public String getSancion() {
		return sancion;
	}
	public void setSancion(String sancion) {
		this.sancion = sancion;
	}
	public String getNuevoCompradorNif() {
		return nuevoCompradorNif;
	}
	public void setNuevoCompradorNif(String nuevoCompradorNif) {
		this.nuevoCompradorNif = nuevoCompradorNif;
	}
	public String getNuevoCompradorNombre() {
		return nuevoCompradorNombre;
	}
	public void setNuevoCompradorNombre(String nuevoCompradorNombre) {
		this.nuevoCompradorNombre = nuevoCompradorNombre;
	}
	public String getNuevoCompradorApellido1() {
		return nuevoCompradorApellido1;
	}
	public void setNuevoCompradorApellido1(String nuevoCompradorApellido1) {
		this.nuevoCompradorApellido1 = nuevoCompradorApellido1;
	}
	public String getNuevoCompradorApellido2() {
		return nuevoCompradorApellido2;
	}
	public void setNuevoCompradorApellido2(String nuevoCompradorApellido2) {
		this.nuevoCompradorApellido2 = nuevoCompradorApellido2;
	}
	public Long getOfertaGencat() {
		return ofertaGencat;
	}
	public void setOfertaGencat(Long ofertaGencat) {
		this.ofertaGencat = ofertaGencat;
	}
	public String getEstadoComunicacion() {
		return estadoComunicacion;
	}
	public void setEstadoComunicacion(String estadoComunicacion) {
		this.estadoComunicacion = estadoComunicacion;
	}
	public Date getDateFechaAnulacion() {
		return this.dateFechaAnulacion;
	}
	public void setFechaAnulacion(String fechaAnulacion) {
		try {
			if( fechaAnulacion!=null && !fechaAnulacion.isEmpty() ) {
				this.fechaAnulacion = fechaAnulacion;
				this.dateFechaAnulacion = dateformat.parse( fechaAnulacion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Boolean getComunicadoAnulacionAGencat() {
		return comunicadoAnulacionAGencat;
	}
	public void setComunicadoAnulacionAGencat(Boolean comunicadoAnulacionAGencat) {
		this.comunicadoAnulacionAGencat = comunicadoAnulacionAGencat;
	}
	public Boolean getNecesitaReforma() {
		return necesitaReforma;
	}
	public void setNecesitaReforma(Boolean necesitaReforma) {
		this.necesitaReforma = necesitaReforma;
	}
	public Long getImporteReforma() {
		return importeReforma;
	}
	public void setImporteReforma(Long importeReforma) {
		this.importeReforma = importeReforma;
	}
	public Date getDateFechaRevision() {
		return dateFechaRevision;
	}
	public void setFechaRevision(String fechaRevision) {
		try {
			if( fechaRevision!=null && !fechaRevision.isEmpty() ) {
				this.fechaRevision = fechaRevision;
				this.dateFechaRevision = dateformat.parse( fechaRevision );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Long getIdVisita() {
		return idVisita;
	}
	public void setIdVisita(Long idVisita) {
		this.idVisita = idVisita;
	}
	public String getEstadoVisita() {
		return estadoVisita;
	}
	public void setEstadoVisita(String estadoVisita) {
		this.estadoVisita = estadoVisita;
	}
	public String getApiRealizaLaVisita() {
		return apiRealizaLaVisita;
	}
	public void setApiRealizaLaVisita(String apiRealizaLaVisita) {
		this.apiRealizaLaVisita = apiRealizaLaVisita;
	}
	public Date getDateFechaRealizacionVisita() {
		return dateFechaRealizacionVisita;
	}
	public void setFechaRealizacionVisita(String fechaRealizacionVisita) {
		try {
			if( fechaRealizacionVisita!=null && !fechaRealizacionVisita.isEmpty() ) {
				this.fechaRealizacionVisita = fechaRealizacionVisita;
				this.dateFechaRealizacionVisita = dateformat.parse( fechaRealizacionVisita );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Boolean getCheckNotificacion() {
		return checkNotificacion;
	}
	public void setCheckNotificacion(Boolean checkNotificacion) {
		this.checkNotificacion = checkNotificacion;
	}
	public Date getDateFechaNotificacion() {
		return dateFechaNotificacion;
	}
	public void setFechaNotificacion(String fechaNotificacion) {
		try {
			if( fechaNotificacion!=null && !fechaNotificacion.isEmpty() ) {
				this.fechaNotificacion = fechaNotificacion;
				this.dateFechaNotificacion = dateformat.parse( fechaNotificacion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public String getMotivoNotificacion() {
		return motivoNotificacion;
	}
	public void setMotivoNotificacion(String motivoNotificacion) {
		this.motivoNotificacion = motivoNotificacion;
	}
	public String getDocumentoNotificion() {
		return documentoNotificion;
	}
	public void setDocumentoNotificion(String documentoNotificion) {
		this.documentoNotificion = documentoNotificion;
	}

	public Date getDateFechaSancionNotificacion() {
		return dateFechaSancionNotificacion;
	}
	public void setFechaSancionNotificacion(String fechaSancionNotificacion) {
		try {
			if( fechaSancionNotificacion!=null && !fechaSancionNotificacion.isEmpty() ) {
				this.fechaSancionNotificacion = fechaSancionNotificacion;
				this.dateFechaSancionNotificacion = dateformat.parse( fechaSancionNotificacion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public Date getDateCierreNotificacion() {
		return dateCierreNotificacion;
	}
	public void setCierreNotificacion(String cierreNotificacion) {
		try {
			if( cierreNotificacion!=null && !cierreNotificacion.isEmpty() ) {
				this.cierreNotificacion = cierreNotificacion;
				this.dateCierreNotificacion = dateformat.parse( cierreNotificacion );
			}
		}   catch (ParseException e) { e.printStackTrace(); }
	}
	public void setRealizacionVisita(Date fechaRealizacionVisita) {
		this.dateFechaRealizacionVisita = fechaRealizacionVisita;
	}	
	
	public String getFechaPreBloqueo() {
        return fechaPreBloqueo;
    }
    public String getFechaComunicacion() {
        return fechaComunicacion;
    }

    public String getFechaPrevistaSancion() {
        return fechaPrevistaSancion;
    }

    public String getFechaSancion() {
        return fechaSancion;
    }

    public String getFechaAnulacion() {
        return fechaAnulacion;
    }
    public String getFechaRevision() {
        return fechaRevision;
    }

    public String getFechaRealizacionVisita() {
        return fechaRealizacionVisita;
    }

    public String getFechaNotificacion() {
        return fechaNotificacion;
    }
    
    public String getFechaSancionNotificacion() {
        return fechaSancionNotificacion;
    }
    
    public String getCierreNotificacion() {
        return cierreNotificacion;
    }
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdOfertaAnterior() {
		return idOfertaAnterior;
	}
	public void setIdOfertaAnterior(Long idOfertaAnterior) {
		this.idOfertaAnterior = idOfertaAnterior;
	}

}