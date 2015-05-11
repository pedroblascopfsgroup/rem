package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.web.util.HtmlUtils;

public class DtoCrearAnotacion {

	private List<DtoCrearAnotacionUsuario> usuarios;

	private Long idUg;

	private String codUg;

	private List<String> direccionesMailPara;

	private List<String> direccionesMailCc;

	private String asuntoMail;

	private String tipoAnotacion;

	private Date fechaTodas;

	private String cuerpoEmail;

	private List<DtoAdjuntoMail> adjuntosList;

	public List<DtoCrearAnotacionUsuario> getUsuarios() {
		return usuarios;
	}

	public void setUsuarios(List<DtoCrearAnotacionUsuario> usuarios) {
		this.usuarios = usuarios;
	}

	public Date getFechaTodas() {
		return fechaTodas != null ? ((Date) fechaTodas.clone()) : null;
	}

	public void setFechaTodas(Date fechaTodas) {
		this.fechaTodas = fechaTodas != null ? ((Date) fechaTodas.clone())
				: null;
	}

	public String getCuerpoEmail() {
		return HtmlUtils.htmlUnescape(cuerpoEmail);
	}

	public void setCuerpoEmail(String cuerpoEmail) {
		this.cuerpoEmail = cuerpoEmail;
	}

	public String getAsuntoMail() {
		return asuntoMail;
	}

	public void setAsuntoMail(String asuntoMail) {
		this.asuntoMail = asuntoMail;
	}

	public List<String> getDireccionesMailPara() {
		return direccionesMailPara;
	}

	public void setDireccionesMailPara(List<String> direccionesMailPara) {
		this.direccionesMailPara = direccionesMailPara;
	}

	public List<String> getDireccionesMailCc() {
		return direccionesMailCc;
	}

	public void setDireccionesMailCc(List<String> direccionesMailCc) {
		this.direccionesMailCc = direccionesMailCc;
	}

	public String getTipoAnotacion() {
		return tipoAnotacion;
	}

	public void setTipoAnotacion(String tipoAnotacion) {
		this.tipoAnotacion = tipoAnotacion;
	}

	public void setCodUg(String codUg) {
		this.codUg = codUg;
	}

	public String getCodUg() {
		return codUg;
	}

	public void setIdUg(Long idUg) {
		this.idUg = idUg;
	}

	public Long getIdUg() {
		return idUg;
	}

	public List<DtoAdjuntoMail> getAdjuntosList() {
		return adjuntosList;
	}

	public void setAdjuntosList(List<DtoAdjuntoMail> adjuntosList) {
		this.adjuntosList = adjuntosList;
	}
	
	/**
	 * Metodo que crea una nueva anotacion
	 * 
	 * @param dto
	 * @param model
	 * @return
	 */
	public static DtoCrearAnotacion crearAnotacionDTO(List<Long> listIdUsuarioGestor,
			boolean isEmail, boolean isIncorporar, Date fecha, String asunto,
			String cuerpoEmail, Long idEntidad, String codigoEntidad,
			String tipoAnotacion) {
		DtoCrearAnotacion serviceDto = new DtoCrearAnotacion();
		List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();
		for (Long idUsuario : listIdUsuarioGestor) {
			DtoCrearAnotacionUsuario dtoCrearAnotacionUsuario = new DtoCrearAnotacionUsuario();
			dtoCrearAnotacionUsuario.setId(idUsuario);
			dtoCrearAnotacionUsuario.setEmail(isEmail);
			dtoCrearAnotacionUsuario.setIncorporar(isIncorporar);
			dtoCrearAnotacionUsuario.setFecha(fecha);
			listaUsuarios.add(dtoCrearAnotacionUsuario);
		}
		serviceDto.setUsuarios(listaUsuarios);
		serviceDto.setAsuntoMail(asunto);
		serviceDto.setCuerpoEmail(cuerpoEmail);
		serviceDto.setIdUg(idEntidad);
		serviceDto.setCodUg(codigoEntidad);

		serviceDto.setTipoAnotacion(tipoAnotacion);
		return serviceDto;
	}

}
