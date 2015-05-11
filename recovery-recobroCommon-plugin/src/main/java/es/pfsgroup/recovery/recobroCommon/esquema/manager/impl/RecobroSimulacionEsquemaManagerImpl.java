package es.pfsgroup.recovery.recobroCommon.esquema.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.recovery.recobroCommon.core.manager.impl.DiccionarioManager;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.RecobroSimulacionEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSimulacionEsquemaManager;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoSimulacion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSimulacionEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroSimulacionEsquemaConstants;


@Service
public class RecobroSimulacionEsquemaManagerImpl implements
		RecobroSimulacionEsquemaManager {

	@Autowired
	private RecobroSimulacionEsquemaDao recobroSimulacionEsquemaDao;
	
	@Autowired
	private DiccionarioManager diccionarioManager;
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public Long obtenerNumeroProcesosEstadoPendiente() {
		RecobroDDEstadoSimulacion estadoPendienteSimulacion = (RecobroDDEstadoSimulacion) diccionarioManager.dameValorDiccionarioByCod(RecobroDDEstadoSimulacion.class, RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PENDIENTE_SIMULAR);
		return recobroSimulacionEsquemaDao.countProcesosPorEstado(estadoPendienteSimulacion.getId());		
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public RecobroSimulacionEsquema getProcesoEstadoPendiente() {
		RecobroDDEstadoSimulacion estadoPendienteSimulacion = (RecobroDDEstadoSimulacion) diccionarioManager.dameValorDiccionarioByCod(RecobroDDEstadoSimulacion.class, RecobroDDEstadoSimulacion.RCF_DD_ESI_ESTADO_SIMULACION_PENDIENTE_SIMULAR);
		
		List<RecobroSimulacionEsquema> esquemasSimulacion = recobroSimulacionEsquemaDao.getProcesosPorEstado(estadoPendienteSimulacion.getId());
		if (esquemasSimulacion!=null && esquemasSimulacion.size()>0)
			return esquemasSimulacion.get(0);
		else
			return null;
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public void grabarProceso(RecobroSimulacionEsquema esquema) {
		recobroSimulacionEsquemaDao.saveOrUpdate(esquema);
	}

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(RecobroSimulacionEsquemaConstants.RECOBRO_SIMULACION_GET_SIMULACIONES_ESQUEMA)
	@Override
	public List<RecobroSimulacionEsquema> getSimulacionesDelEsquema(Long idEsquema) {
		return recobroSimulacionEsquemaDao.getSimulacionesDelEsquema(idEsquema);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroSimulacionEsquemaConstants.RECOBRO_SIMULACION_GET_SIMULACIONES_POR_ESTADO)
	public List<RecobroSimulacionEsquema> getSimulacionesPorEstado(Long idEstado) {
		return recobroSimulacionEsquemaDao.getProcesosPorEstado(idEstado);
	}

}
