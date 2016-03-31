package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVNotificacionDemandadosApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDemandadosDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVFechasNotificacionDto;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoNotificacionFilter;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;
import es.pfsgroup.recovery.api.ProcedimientoApi;

/**
 * Manager que gestiona la informaci�n que se muestra en la pantalla de notificacion de demandados
 * Tambi�n es responsable de ordenar la actualizaci�n de las fechas involucradas 
 * en el proceso de notificaci�n.
 * @author manuel
 *
 */
@Service
public class MSVNotificacionDemandadosManager implements MSVNotificacionDemandadosApi{

	public static final String DATE_FORMAT = "dd/MM/yyyy";

	@Autowired
	MSVDemandadosDao msvDemandadosDao;
	
	@Autowired
	MSVDireccionFechaNotificacionDao msvDireccionFechaNotificacionDao;
	
	@Autowired
	ProcedimientoDao procedimientoDao;
	
	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
//	@Autowired
//	MSVInfoNotificacion msvInfoNotificacion;
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVNotificacionDemandadosApi#getResumenNotificaciones(java.lang.Long)
	 */
	
	@Override
	@BusinessOperation(MSV_BO_TODOS_NOTIFICADOS)
	public boolean todosNotificados(Long idProcedimiento){
		
		if (idProcedimiento == null)
			throw new BusinessOperationException("El campo idProcedimiento es nulo.");
		
		Procedimiento prc =  procedimientoDao.get(idProcedimiento);
		
		String resumen = getTipoNotificacionRequerimientoPago(prc);
		
		if (resumen == NOTIFICACION_TOTAL ){
			return true;
		} else {
			return false;
		}
	}
	
	
	@Override
	@BusinessOperation(MSV_BO_GET_RESUMEN_NOTIFICACIONES)
	public List<MSVInfoResumen> getResumenNotificaciones(Long idProcedimiento) throws Exception {
		
		if (idProcedimiento == null)
			throw new BusinessOperationException("El campo idProcedimiento es nulo.");
		
		MSVInfoNotificacion msvInfoNotificacion = this.getMSVInfoNotificacion(idProcedimiento);
		
		return msvInfoNotificacion.getInfoResumen();
	}



	@Override
	@BusinessOperation(MSV_BO_GET_DETALLE_NOTIFICACIONES)
	public List<MSVInfoResumenPersona> getDetalleNotificaciones(Long idProcedimiento, Long idPersona) throws Exception {
		if (idProcedimiento == null || idPersona == null)
			throw new BusinessOperationException("Los campos procedimiento y persona no pueden ser nulos.");
		
		MSVInfoNotificacion msvInfoNotificacion = this.getMSVInfoNotificacion(idProcedimiento);
		
		MSVInfoNotificacionFilter filtro = new MSVInfoNotificacionFilter();
		filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_PESONA);
		filtro.setIdPersona(idPersona);
		msvInfoNotificacion.addFiltro(filtro);
		msvInfoNotificacion.filtra();
		
		return msvInfoNotificacion.getInfoResumenPersona();
		
//		List<MSVDireccionFechaNotificacion> msvDireccionFechaNotificacion = msvDireccionFechaNotificacionDao.getFechasNotificacionPorPersona(idProcedimiento, idPersona);
//		return msvDireccionFechaNotificacion;
	}

	@Override
	@BusinessOperation(MSV_BO_GET_HISTORICO_DETALLE_NOTIFICACIONES)
	public List<MSVDireccionFechaNotificacion> getHistoricoDetalleNotificaciones(MSVFechasNotificacionDto dto) throws Exception {
		if (dto.getIdProcedimiento() == null || dto.getIdPersona() == null || dto.getTipoFecha() == null)
			throw new BusinessOperationException("Los campos procedimiento, persona y tipo fecha no pueden ser nulos.");
		
		MSVInfoNotificacion msvInfoNotificacion = this.getMSVInfoNotificacion(dto.getIdProcedimiento());
		MSVInfoNotificacionFilter filtro;

		filtro = new MSVInfoNotificacionFilter();
		filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_PESONA);
		filtro.setIdPersona(dto.getIdPersona());
		msvInfoNotificacion.addFiltro(filtro);

		if(dto.getIdDireccion() != null){
			filtro = new MSVInfoNotificacionFilter();
			filtro.setIdDireccion(dto.getIdDireccion());
			filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_DIRECCION);
			msvInfoNotificacion.addFiltro(filtro);
		}
		
		filtro = new MSVInfoNotificacionFilter();
		filtro.setTipoFecha(dto.getTipoFecha());
		filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
		msvInfoNotificacion.addFiltro(filtro);


		msvInfoNotificacion.filtra();
		
		return msvInfoNotificacion.getInfoFechasNotificacion();
		
//		List<MSVDireccionFechaNotificacion> msvDireccionFechaNotificacion = msvDireccionFechaNotificacionDao.getFechasNotificacionPorDireccion( idProcedimiento,  idPersona,  idDireccion);
//		return msvDireccionFechaNotificacion;
	}
	
	@Override
	@BusinessOperation(MSV_BO_UPDATE_NOTIFICACION)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)	
	public MSVDireccionFechaNotificacion updateNotificacion(MSVFechasNotificacionDto dto) throws Exception{
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = msvDireccionFechaNotificacionDao.get(dto.getId());
		if (msvDireccionFechaNotificacion == null)
			throw new BusinessOperationException("Error al actualizar datos. No existe la notificaci�n.");
		try{		
			this.populateFechasNotificacion(dto, msvDireccionFechaNotificacion);
		}catch(ParseException ex){
			throw new BusinessOperationException("Error en el formato de fechas.");
		}
		msvDireccionFechaNotificacionDao.saveOrUpdate(msvDireccionFechaNotificacion);

		
		return msvDireccionFechaNotificacion;
	}
	
	@Override
	@BusinessOperation(MSV_BO_INSERT_NOTIFICACION)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)	
	public MSVDireccionFechaNotificacion insertNotificacion(MSVFechasNotificacionDto dto) throws Exception {
		
		if (dto.getIdProcedimiento() == null || dto.getIdPersona()== null)
			throw new BusinessOperationException("Error al insertar datos. El procedimiento, la persona y la direcci�n no pueden ser nulos.");
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion(); 
		try{
			this.populateFechasNotificacion(dto, msvDireccionFechaNotificacion);			
		}catch(ParseException ex){
			throw new BusinessOperationException("Error en el formato de fechas.");
		}

		
		msvDireccionFechaNotificacionDao.save(msvDireccionFechaNotificacion);
		
		return msvDireccionFechaNotificacion;
	}

	
	@Override
	@BusinessOperation(MSV_BO_UPDATE_EXCLUIDO)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public MSVDireccionFechaNotificacion updateExcluido(MSVFechasNotificacionDto dto) throws Exception{
		//TODO actualmente se esta utilizando la entity de las direccionesFechas, se deber� cambiar a un objeto propio de demandados		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacionReturn = null;

		List<MSVDireccionFechaNotificacion> msvDireccionesFechaNotificacion = msvDireccionFechaNotificacionDao.getFechasNotificacionPorPersona(dto.getIdProcedimiento(), dto.getIdPersona());
		if (Checks.estaVacio(msvDireccionesFechaNotificacion)) {
			msvDireccionFechaNotificacionReturn = insertNotificacion(dto);
		} else {
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : msvDireccionesFechaNotificacion) {
				dto.setId(msvDireccionFechaNotificacion.getId());
				dto.setIdProcedimiento(msvDireccionFechaNotificacion.getProcedimiento().getId());
				dto.setIdPersona(msvDireccionFechaNotificacion.getPersona().getId());
				msvDireccionFechaNotificacionReturn = updateNotificacion(dto);
			}
		}
		
		return msvDireccionFechaNotificacionReturn;
	}

	private void populateFechasNotificacion(MSVFechasNotificacionDto dto, MSVDireccionFechaNotificacion msvDireccionFechaNotificacion) throws ParseException {

		SimpleDateFormat df = new SimpleDateFormat(DATE_FORMAT);

		if (!Checks.esNulo(dto.getFechaSolicitud()))
			msvDireccionFechaNotificacion .setFechaSolicitud(df.parse(dto.getFechaSolicitud()));
		if (!Checks.esNulo(dto.getFechaResultado()))
			msvDireccionFechaNotificacion.setFechaResultado(df.parse(dto.getFechaResultado()));
		if (!Checks.esNulo(dto.getResultado())) 
			msvDireccionFechaNotificacion.setResultado(dto.getResultado());

		//TODO actualmente se esta utilizando la entity de las direccionesFechas, se deber� cambiar a un objeto propio de demandados		
		if (!Checks.esNulo(dto.getExcluido()))
			msvDireccionFechaNotificacion.setExcluido(dto.getExcluido());
		
		//Es un insert, tenemos que a�adir el procedimiento, la persona y la direcci�n.
		if (dto.getId() == null){
			Procedimiento procedimiento = apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(dto.getIdProcedimiento());
			msvDireccionFechaNotificacion.setProcedimiento(procedimiento);
			msvDireccionFechaNotificacion.setTipoFecha(dto.getTipoFecha());
			List<Persona> personas = procedimiento.getPersonasAfectadas();
			if (personas != null){
				for(Persona persona: personas){
					if (persona.getId() != null && persona.getId().equals(dto.getIdPersona())){
						msvDireccionFechaNotificacion.setPersona(persona);
						List<Direccion> direcciones = persona.getDirecciones();
						if(direcciones != null){
							for(Direccion direccion: direcciones){
								if(direccion.getCodDireccion() != null && direccion.getCodDireccion().equals(dto.getIdDireccion()))
									msvDireccionFechaNotificacion.setDireccion(direccion);
							}
						}
					}
				}
			}
		}
	}
	
	/**
	 * Rellena el objeto MSVInfoNotificacion con toda la informaci�n sobre un procedimiento.
	 * @param idProcedimiento Id del procedimiento.
	 */
	private MSVInfoNotificacion getMSVInfoNotificacion(Long idProcedimiento) {
		MSVInfoNotificacion msvInfoNotificacion = new MSVInfoNotificacion();
		msvInfoNotificacion.clearAll();
		Procedimiento procedimiento = apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		
		msvInfoNotificacion.setProcedimiento(procedimiento);
		
		List<MSVInfoDemandado> msvInfoDemandados = msvDemandadosDao.getDemandadosYDomicilios(idProcedimiento);
		msvInfoNotificacion.setInfoDemandados(msvInfoDemandados);
		
		List<MSVDireccionFechaNotificacion> msvDireccionFechaNotificacion = msvDireccionFechaNotificacionDao.getFechasNotificacion(idProcedimiento);
		msvInfoNotificacion.setInfoFechasNotificacion(msvDireccionFechaNotificacion);
		
		return msvInfoNotificacion;
	}



	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVNotificacionDemandadosApi#getTipoNotificacion(es.capgemini.pfs.asunto.model.Procedimiento)
	 */
	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_NOTIFICACION)
	public String getTipoNotificacionRequerimientoPago(Procedimiento prc){
		
		String resultado = NOTIFICACION_NEGATIVO;
		int demandadosNotificados = 0;
		List<MSVInfoResumen> listaMSVInfoResumen;
		try {
			listaMSVInfoResumen = this.getResumenNotificaciones(prc.getId());
			if (listaMSVInfoResumen != null && listaMSVInfoResumen.size() > 0) {
				for (MSVInfoResumen msvInfoResumen : listaMSVInfoResumen) {
					if ((msvInfoResumen.getExcluido() != null && msvInfoResumen
							.getExcluido())
							|| (MSVDireccionFechaNotificacion.RESULTADO_POSITIVO
									.equals(msvInfoResumen
											.getResultadoReqPago())) 
							|| (MSVDireccionFechaNotificacion.RESULTADO_POSITIVO
									.equals(msvInfoResumen
											.getResultadoReqEdicto()))) {
						demandadosNotificados++;
					}
				}
			}
			if (demandadosNotificados > 0) {
				if (demandadosNotificados == listaMSVInfoResumen.size())
					resultado = NOTIFICACION_TOTAL;
				else
					resultado = NOTIFICACION_PARCIAL;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultado;
	}



	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_NOTIFICACION_OFICIO_LOCALIZACION)
	public String getTipoNotificacionOficioLocalizacion(Procedimiento prc,
			Long idDemandado) {
//OFI_LOC_PRESENT, si s�lo se ha solicitado.
//OFI_LOC_POS_REP, positivo repetido.
//OFI_LOC_POS, positivo sin preintento.
//OFI_LOC_NEG_PAR, negativo parcial.
//OFI_LOC_NEG_TOT, negativo total.

		String resultado = OFI_LOC_NEG_TOT;
		
		boolean tieneSolicitudAvDomiciliaria = compruebaSolicitudAveriguacionDomiciliaria(prc.getId(), idDemandado);
		
		List<MSVInfoResumen> listaMSVInfoResumen;
		try {
			listaMSVInfoResumen = this.getResumenNotificaciones(prc.getId());
			if (listaMSVInfoResumen != null && listaMSVInfoResumen.size() > 0) {
				for (MSVInfoResumen msvInfoResumen : listaMSVInfoResumen) {
					//Comprobar si la fila corresponde al demandado
					if (msvInfoResumen.getIdDemandado().equals(idDemandado)) {
						// Si es un excluido, lo consideramos OFI_LOC_POS, positivo sin preintento.
						if ((msvInfoResumen.getExcluido() != null && msvInfoResumen
								.getExcluido())) {
							resultado = OFI_LOC_POS;
						} else {
							//Comprobamos si hay fecha de presentaci�n, pero no hay fecha de resultado
							if (!tieneSolicitudAvDomiciliaria) {
								resultado = OFI_LOC_NEG_TOT;
							} else if (tieneSolicitudAvDomiciliaria &&
									msvInfoResumen.getResultadoAvDomiciliaria() == null) {
								resultado = OFI_LOC_PRESENT;
							} //Si el resultado es positivo
							else if (MSVDireccionFechaNotificacion.RESULTADO_POSITIVO.equals(msvInfoResumen
											.getResultadoAvDomiciliaria())) {
								//Si ya tenemos un resultado negativo en el requerimiento de pago de ese domicilio
								if (MSVDireccionFechaNotificacion.RESULTADO_NEGATIVO.equals(msvInfoResumen.getResultadoReqPago())) {
									resultado = OFI_LOC_POS_REP;
								} else {
									resultado = OFI_LOC_POS;
								}
							} //Si el resultado es negativo
							else if (MSVDireccionFechaNotificacion.RESULTADO_NEGATIVO.equals(msvInfoResumen
											.getResultadoAvDomiciliaria())) {
								//�Quedan otros domicilios por notificar?
								if (consultarSiQuedanDomiciliosPorNotificar(prc.getId(), idDemandado)) {
									resultado = OFI_LOC_NEG_PAR;
								} else {
									resultado = OFI_LOC_NEG_TOT;
								}
							}
							
						}
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultado;
	}



	private boolean compruebaSolicitudAveriguacionDomiciliaria(Long idProcedimiento,
			Long idDemandado) {
		
		MSVFechasNotificacionDto dto = new MSVFechasNotificacionDto();
		dto.setIdProcedimiento(idProcedimiento);
		dto.setIdPersona(idDemandado);
		dto.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION);
		
		List<MSVDireccionFechaNotificacion> listaFechas;
		
		try {
			listaFechas = getHistoricoDetalleNotificaciones(dto);
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listaFechas) {
				return !Checks.esNulo(msvDireccionFechaNotificacion.getFechaSolicitud());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}



	private boolean consultarSiQuedanDomiciliosPorNotificar(Long idProcedimiento, Long idDemandado) {
		List<MSVInfoResumenPersona> listaNotificaciones = null;
		boolean quedanDomiciliosPorNotificar = false;
		try {
			listaNotificaciones = this.getDetalleNotificaciones(idProcedimiento, idDemandado);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (!Checks.esNulo(listaNotificaciones)) {
			for (MSVInfoResumenPersona msvInfoResumenPersona : listaNotificaciones) {
				if (Checks.esNulo(msvInfoResumenPersona.getResultadoRequerimiento())) {
					quedanDomiciliosPorNotificar = true;
					break;
				}
			}
		}
		return quedanDomiciliosPorNotificar;
	}



	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_NOTIFICACION_NOCTURNOS)
	public String getTipoNotificacionHorarioNocturno(Procedimiento prc,
			List<Long> listaIdDemandados) {
//HORARIO_NOCTURNO_PRESENT, si s�lo se ha solicitado.
//HORARIO_NOCTURNO_POSITIVO, positivo.
//HORARIO_NOCTURNO_NEGATIVO, negativo.

		String resultado = HORARIO_NOCTURNO_PRESENT;
		for (Long idDemandado : listaIdDemandados) {
			List<MSVInfoResumenPersona> listaNotificaciones = null;
			try {
				listaNotificaciones = this.getDetalleNotificaciones(prc.getId(), idDemandado);
				for (MSVInfoResumenPersona msvInfoResumenPersona : listaNotificaciones) {
					if (!Checks.esNulo(msvInfoResumenPersona.getResultadoHorarioNocturno())) {
						if (MSVDireccionFechaNotificacion.RESULTADO_POSITIVO.equals(msvInfoResumenPersona.getResultadoHorarioNocturno())) {
							resultado = HORARIO_NOCTURNO_POSITIVO;
						} else {
							resultado = HORARIO_NOCTURNO_NEGATIVO;
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
		return resultado;
	}

}
