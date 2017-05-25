package es.pfsgroup.plugin.rem.jbpm.handler.plazo.impl;

import java.util.Calendar;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class ResultadoATPlazoAssignationService implements PlazoAssignationService {

	private static final String CODIGO_T004_RESULTADO_TARIFICADA = "T004_ResultadoTarificada";
	private static final String CODIGO_T004_RESULTADO_NOTARIFICADA = "T004_ResultadoNoTarificada";

	@Autowired
	GenericABMDao genericDao;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T004_RESULTADO_TARIFICADA, CODIGO_T004_RESULTADO_NOTARIFICADA };
	}

	@Override
	public Long getPlazoTarea(Long idTipoTarea, Long idTramite) {
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "id", idTramite);
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);

		Trabajo trabajo = tramite.getTrabajo();
		Date fechaNueva = new Date((!Checks.esNulo(trabajo.getFechaHoraConcreta()) ? trabajo.getFechaHoraConcreta()
				: trabajo.getFechaTope()).getTime());
		// en los plazos tope situamos la fecha en el ultimo segundo del dia. En
		// caso de seleccionar la fecha de hoy, si no hacemos esto, la
		// diferencia sera negativa
		Calendar cal = Calendar.getInstance();
		cal.setTime(fechaNueva);
		cal.add(Calendar.HOUR_OF_DAY, 23);
		cal.add(Calendar.MINUTE, 59);
		cal.add(Calendar.SECOND, 59);
		fechaNueva = cal.getTime();
		Date hoy = new Date();
		return (fechaNueva.getTime() - hoy.getTime());
	}
}