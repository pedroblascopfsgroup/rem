package es.capgemini.pfs.exceptuar.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.exceptuar.api.ExceptuacionApi;
import es.capgemini.pfs.exceptuar.dao.ExceptuacionDao;
import es.capgemini.pfs.exceptuar.dto.DtoExceptuacion;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;
import es.capgemini.pfs.exceptuar.model.ExceptuacionContrato;
import es.capgemini.pfs.exceptuar.model.ExceptuacionMotivo;
import es.capgemini.pfs.exceptuar.model.ExceptuacionPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Manager de la entidad exceptuacion.
 * 
 * @author Oscar
 * 
 */
@Component
public class ExceptuacionManager implements ExceptuacionApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	ExceptuacionDao exceptuacionDao;

	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

	@Override
	@BusinessOperation(BO_EXISTE_EXCEPTUACION_BY_DTO)
	public Boolean existeExceptuacion(DtoExceptuacion dto) {
		
		return this.existeExceptuacion(dto.getIdEntidad(), dto.getTipo());
	
	}

	@Override
	@BusinessOperation(BO_EXISTE_EXCEPTUACION_BY_PERID_TIPO)
	public Boolean existeExceptuacion(Long id, String tipo) {

		//Long excId = null;

		if (DtoExceptuacion.TIPO_PERSONA.equals(tipo)) {

			List<ExceptuacionPersona> listado = genericDao.getList(ExceptuacionPersona.class, genericDao.createFilter(FilterType.EQUALS, "persona.id", id),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			for(ExceptuacionPersona epe: listado){
				if (Checks.esNulo(epe.getFechaHasta()) || posteriorAHoy(epe.getFechaHasta())) {
					//excId = epe.getId();
					return true;
				}
			}

		} else if (DtoExceptuacion.TIPO_CONTRATO.equals(tipo)) {

			List<ExceptuacionContrato> listado = genericDao.getList(ExceptuacionContrato.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", id),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			for(ExceptuacionContrato eco: listado){
				if (Checks.esNulo(eco.getFechaHasta()) || posteriorAHoy(eco.getFechaHasta())) {
					//excId = eco.getId();
					return true;
				}
			}
		}

//		if (!Checks.esNulo(excId)) {
//			Exceptuacion exc = genericDao.get(Exceptuacion.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "id", excId));
//			if (!Checks.esNulo(exc)) {
//				if(Checks.esNulo(exc.getFechaHasta()) || posteriorAHoy(exc.getFechaHasta())) {
//					return true;
//				}
//			}
//		}

		return false;
	}
	
	private Boolean posteriorAHoy(Date fechaHasta){
		
		Calendar cal1 = new GregorianCalendar();
		cal1.setTime(fechaHasta);
		
		Date hoy = new Date();
		Calendar cal2 = new GregorianCalendar();
		cal2.setTime(hoy);
		
		if(cal1.after(cal2)) return true; 
		
		return false;
	}

	@Override
	@BusinessOperation(BO_GET_EXCEPTUACION_BY_ID)
	public Exceptuacion getExceptuacion(Long id) {

		List<Exceptuacion> listado = genericDao.getList(Exceptuacion.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "id", id));
		
		for(Exceptuacion exc: listado){
			//Solo puede quedar UNA!
			if(Checks.esNulo(exc.getFechaHasta()) || posteriorAHoy(exc.getFechaHasta())){
				return exc;
			}
		}
		
		return null;
	}

	@Override
	@BusinessOperation(BO_GET_EXCEPTUACION_BY_ID_TIPO)
	public Exceptuacion getExceptuacionByIdTipo(Long id, String tipo) {

		Exceptuacion exc = null;
		if (DtoExceptuacion.TIPO_PERSONA.equals(tipo)) {
			ExceptuacionPersona epe = genericDao.get(ExceptuacionPersona.class, genericDao.createFilter(FilterType.EQUALS, "persona.id", id),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			exc = proxyFactory.proxy(ExceptuacionApi.class).getExceptuacion(epe.getId());
		} else if (DtoExceptuacion.TIPO_CONTRATO.equals(tipo)) {
			ExceptuacionContrato eco = genericDao.get(ExceptuacionContrato.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", id),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			exc = proxyFactory.proxy(ExceptuacionApi.class).getExceptuacion(eco.getId());
		}

		if (!Checks.esNulo(exc)) {
			return exc;
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_GUARDAR_EXCEPTUACION)
	public void guardarExceptuacion(DtoExceptuacion dto) {

		ExceptuacionMotivo moe = genericDao.get(ExceptuacionMotivo.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdMotivo()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		if (DtoExceptuacion.TIPO_PERSONA.equals(dto.getTipo())) {
			ExceptuacionPersona epe = null;
			if (!Checks.esNulo(dto.getExcId())) 
				epe = genericDao.get(ExceptuacionPersona.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getExcId()));
			else
				epe = new ExceptuacionPersona();

			try {
				if(Checks.esNulo(dto.getFechaHasta()))
					epe.setFechaHasta(null);
				else
					epe.setFechaHasta(formatter.parse(dto.getFechaHasta()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha", e);
			}
			epe.setMotivo(moe);
			epe.setComentario(dto.getObservaciones());
			epe.setAuditoria(Auditoria.getNewInstance());

			Persona per = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEntidad()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			epe.setPersona(per);

			exceptuacionDao.save(epe);
		} else if (DtoExceptuacion.TIPO_CONTRATO.equals(dto.getTipo())) {
			
			ExceptuacionContrato eco = null;
			if (!Checks.esNulo(dto.getExcId()))
				eco = genericDao.get(ExceptuacionContrato.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getExcId()));
			else
				eco = new ExceptuacionContrato();
			
			try {
				if(Checks.esNulo(dto.getFechaHasta()))
					eco.setFechaHasta(null);
				else
					eco.setFechaHasta(formatter.parse(dto.getFechaHasta()));
			} catch (ParseException e) {
				logger.error("Error parseando la fecha", e);
			}
			eco.setMotivo(moe);
			eco.setComentario(dto.getObservaciones());
			eco.setAuditoria(Auditoria.getNewInstance());

			Contrato cnt = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEntidad()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			eco.setContrato(cnt);

			exceptuacionDao.save(eco);
		}

	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_BORRAR_EXCEPTUACION)
	public void borrarExceptuacion(Long id) {

		exceptuacionDao.deleteById(id);
	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_MOTIVOS_EXCEPTUACION)
	public List<ExceptuacionMotivo> getListadoMotivosExceptuacion() {

		return genericDao.getList(ExceptuacionMotivo.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));

	}

}
