package es.pfsgroup.plugin.rem.jbpm.handler.plazo.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class ResultadoPBCPlazoAssignationService implements PlazoAssignationService {
	
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	
	@Autowired
	GenericABMDao genericDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] {CODIGO_T013_RESULTADO_PBC};
	}

	@Override
	public Long getPlazoTarea(Long idTipoTarea, Long idTramite) {
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "id", idTramite);
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);
		Trabajo trabajo = tramite.getTrabajo();
		
		
		Filter filtroEco = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtroEco);
		
		List<TanteoActivoExpediente> tanteos = expediente.getTanteoActivoExpediente();	
		if(!tanteos.isEmpty()) {
			Date resultadoTanteo = null;
			for(TanteoActivoExpediente tanteo : tanteos) {
				Date finTanteo = tanteo.getFechaFinTanteo();
				if(resultadoTanteo == null) {
					resultadoTanteo = finTanteo;
				}else {
					if(resultadoTanteo.compareTo(finTanteo)<=0) {
						resultadoTanteo = finTanteo;
					}
				}
				
			}
			if(resultadoTanteo != null) {
				return resultadoTanteo.compareTo(new Date()) + 30*24*60*60*1000L;
			}else {
				return 30*24*60*60*1000L;
			}
		}else {
			return 30*24*60*60*1000L;
		}
	}

}
