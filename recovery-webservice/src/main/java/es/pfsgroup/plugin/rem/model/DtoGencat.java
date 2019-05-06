package es.pfsgroup.plugin.rem.model;
import java.util.Date;

/**
 * Dto para la subpestaña GENCAT de la pestaña Comercial del Activo
 * 
 * @author Isidro Sotoca
 *
 */
public class DtoGencat extends DtoTabActivo {

	private static final long serialVersionUID = -1471368154602764594L;
	
	//ID Activo
	private Long idActivo;
	
	//Datos comunicación
	private Long idComunicacion;
	private Date fechaPreBloqueo;
	private Date fechaComunicacion;
	private Date fechaPrevistaSancion;
	private Date fechaSancion;
	
	private String sancion;
	private String nuevoCompradorNif;
	private String nuevoCompradorNombre;
	private String nuevoCompradorApellido1;
	private String nuevoCompradorApellido2;
	private String estadoComunicacion;
	private Date fechaAnulacion;
	private Boolean comunicadoAnulacionAGencat;
	private Boolean usuarioCompleto;
	private Boolean comunicadoAnulacionAGencat2;	
	private Boolean ofertasAsociadasEstanAnuladas;	
	//Adecuacion
	private Boolean necesitaReforma;
	private Double importeReforma;
	private Date fechaRevision;
	
	//Visita
	private Long idVisita;
	private String estadoVisita;
	private String apiRealizaLaVisita;
	private Date fechaRealizacionVisita;
	private String idLeadSF;
	
	//Oferta
	private Long ofertaGencat;
	private Long idOfertaAnterior;
	
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
	public Double getImporteReforma() {
		return importeReforma;
	}
	public void setImporteReforma(Double importeReforma) {
		this.importeReforma = importeReforma;
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
	public Date getFechaPreBloqueo() {
		return fechaPreBloqueo;
	}
	public void setFechaPreBloqueo(Date fechaPreBloqueo) {
		this.fechaPreBloqueo = fechaPreBloqueo;
	}
	public Date getFechaComunicacion() {
		return fechaComunicacion;
	}
	public void setFechaComunicacion(Date fechaComunicacion) {
		this.fechaComunicacion = fechaComunicacion;
	}
	public Date getFechaPrevistaSancion() {
		return fechaPrevistaSancion;
	}
	public void setFechaPrevistaSancion(Date fechaPrevistaSancion) {
		this.fechaPrevistaSancion = fechaPrevistaSancion;
	}
	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}
	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}
	public Date getFechaRevision() {
		return fechaRevision;
	}
	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
	}
	public Date getFechaRealizacionVisita() {
		return fechaRealizacionVisita;
	}
	public void setFechaRealizacionVisita(Date fechaRealizacionVisita) {
		this.fechaRealizacionVisita = fechaRealizacionVisita;
	}
	public Boolean getUsuarioCompleto() {
		return usuarioCompleto;
	}
	public void setUsuarioCompleto(Boolean usuarioCompleto) {
		this.usuarioCompleto = usuarioCompleto;
	}
	public Boolean getComunicadoAnulacionAGencat2() {
		return comunicadoAnulacionAGencat2;
	}
	public void setComunicadoAnulacionAGencat2(Boolean comunicadoAnulacionAGencat2) {
		this.comunicadoAnulacionAGencat2 = comunicadoAnulacionAGencat2;
	}

	public Boolean getOfertasAsociadasEstanAnuladas() {
		return ofertasAsociadasEstanAnuladas;
	}
	public void setOfertasAsociadasEstanAnuladas(Boolean ofertasAsociadasEstanAnuladas) {
		this.ofertasAsociadasEstanAnuladas = ofertasAsociadasEstanAnuladas;
	}
	public String getIdLeadSF() {
		return idLeadSF;
	}
	public void setIdLeadSF(String idLeadSF) {
		this.idLeadSF = idLeadSF;
	}
	public Long getIdComunicacion() {
		return idComunicacion;
	}
	public void setIdComunicacion(Long idComunicacion) {
		this.idComunicacion = idComunicacion;
	}

}
