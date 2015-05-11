package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDemandadosDao;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;
import es.pfsgroup.recovery.api.ProcedimientoApi;

@Repository("MSVDemandadosDao")
public class MSVDemandadosDaoImpl implements MSVDemandadosDao {

	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	@Override
	public List<MSVInfoDemandado> getDemandadosYDomicilios(Long idProcedimiento) {
		Procedimiento procedimiento = apiProxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		return this.getDemandadosYDomicilios(procedimiento);
	}

	@Override
	public List<MSVInfoDemandado> getDemandadosYDomicilios(Procedimiento procedimiento) {

		List<MSVInfoDemandado> listadoDemandados = new ArrayList<MSVInfoDemandado>();
		List<Persona> demandados = procedimiento.getPersonasAfectadas();
		
		for (Persona persona : demandados) {
			MSVInfoDemandado msvInfoDemandado = new MSVInfoDemandado();
			msvInfoDemandado.setPersona(persona);
			listadoDemandados.add(msvInfoDemandado);
		}
		
		
		return listadoDemandados;
	}

}
