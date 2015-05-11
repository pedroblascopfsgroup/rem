package es.capgemini.pfs.batch.recobro.facturacion.manager.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroControlCobrosDAO;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroControlCobrosManager;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

@Service
public class RecobroControlCobrosManagerImpl implements RecobroControlCobrosManager {
	
	@Autowired
	private RecobroControlCobrosDAO recobroControlCobrosDAO;
	
	@Autowired
	private RecobroSubCarteraDao recobroSubCarteraDAO;
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public boolean EstaDiaProcesado(Date dia) {
		if (recobroControlCobrosDAO.cuentaControlCobrosDia(dia) > 0)
			return true;

		return false;
	}

	/**
	 * {@inheritDoc}
	 */		
	@Override
	public int CountNumeroRegistrosEntreDias(Date desde, Date hasta) {
		return recobroControlCobrosDAO.cuentaControlCobrosEntreDias(desde, hasta);
	}

	@Override
	public List<RecobroSubCartera> getSubcarterasCobrosPagosPorFechas(Date fechaDesde, Date fechaHasta) {
		List<RecobroSubCartera> subCarteras = new ArrayList<RecobroSubCartera>();

		//Primero necesitamos obtener los ids de las subcarteras de cpr
		List<Map> listSubCarteras = recobroControlCobrosDAO.getSubcarterasCobrosPagosPorFechas(fechaDesde, fechaHasta);
		
		//Obtenemos los objetos subcartera de cada id recogido
		for (Map idSubCartera : listSubCarteras) {
			RecobroSubCartera subCartera = recobroSubCarteraDAO.get(Long.parseLong(idSubCartera.get("RCF_SCA_ID").toString()));
			if (subCartera!=null)
				subCarteras.add(subCartera);
		}
		
		if (subCarteras.size()==0)
			return null;
		else
			return subCarteras;
	}

}
