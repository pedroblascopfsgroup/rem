package es.capgemini.pfs.multigestor;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;

@Component
public class EXTDDTipoGestorManager implements EXTDDTipoGestorApi{
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	@BusinessOperation(EXT_BO_TIPOGESTOR_GETLIST)
	public List<EXTDDTipoGestor> getList() {
		List<EXTDDTipoGestor> listaTiposGestores = genericDao.getList(EXTDDTipoGestor.class);
		
		return listaTiposGestores;
	}
	
	@Override
	@BusinessOperation(EXT_BIO_TIPOGESTOR_GETBYCOD)
	public EXTDDTipoGestor getByCod(String codigo) {
		return genericDao.get(EXTDDTipoGestor.class,genericDao.createFilter(FilterType.EQUALS, "codigo", codigo));
	}
	
	@Override
	@BusinessOperation(EXT_BIO_TIPOGESTORLIST_GETBYCOD)
	public List<EXTDDTipoGestor> getByListCod(Set<String> codigos) {
		List<EXTDDTipoGestor> listaTipos = new ArrayList<EXTDDTipoGestor>();
		for(String codigo : codigos){
			EXTDDTipoGestor tGestor = new EXTDDTipoGestor();
			tGestor = getByCod(codigo);
			listaTipos.add(tGestor);
		}
		return listaTipos;
	}

}
