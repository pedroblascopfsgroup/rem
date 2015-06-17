package es.capgemini.pfs.registro;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;



import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.util.HistoricoProcedimientoComparator;
import es.capgemini.pfs.util.HistoricoProcedimientoTramiteDeSubastaComparator;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.registro.dao.HistoricoProcedimientoExtDao;

@Component
public class EXTHistoricoProcedimientoManager extends 
	BusinessOperationOverrider<HistoricoProcedimientoApi> implements 
	HistoricoProcedimientoApi, EXTHistoricoProcedimientoApi{
	
	public static final String BEAN_NAME = "mEJHistoricoProcedimientoManager";

	@Autowired(required = false)
	private List<HistoricoProcedimientoBuilder> builders;
	
	@Autowired
    private HistoricoProcedimientoExtDao historicoProcedimientoExtDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String managerName() {
		return "historicoProcedimientoManager";
	}

	@Override
	@BusinessOperation(overrides= ExternaBusinessOperation.BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO)
	public List<HistoricoProcedimiento> getListByProcedimiento(
			Long idProcedimiento) {
		List<HistoricoProcedimiento> lista = new ArrayList<HistoricoProcedimiento>();
		//lista.addAll(parent().getListByProcedimiento(
		//		idProcedimiento));
		lista.addAll(historicoProcedimientoExtDao.getListByProcedimiento(idProcedimiento));

		if (builders != null) {
			for (HistoricoProcedimientoBuilder b : builders) {
				addHistorico(lista, b.getHistorico(idProcedimiento));
			}
		}
		
		if(checkProcedimientoTramiteDeSubasta(idProcedimiento)){
			return ordenaListaTramiteDeSubasta(lista);
		}else{
			return ordenaLista(lista);
		}
	}
	
	/**
	 * Chequea si el procedimiento es de tipo T. de subasta
	 * @param idProcedimiento
	 * @return
	 */
	private boolean checkProcedimientoTramiteDeSubasta(Long idProcedimiento) {
		boolean resultado = false;
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento));
		// DD_TPO_TIPO_PROCEDIMIENTO Id = 29, Codigo = P11, Descripcion = T. de Subasta
		if(prc != null && prc.getTipoProcedimiento().getCodigo().equals("P11")){
			resultado = true;
		}
		return resultado;
	}
	
	@Override
	@BusinessOperation(BO_HIST_PRC_MGR_GET_BY_PROCEDIMIENTO_EXT)
	public List<EXTHistoricoProcedimiento> getListByProcedimientoEXT(
			Long idProcedimiento) {
		List<EXTHistoricoProcedimiento> lista = new ArrayList<EXTHistoricoProcedimiento>();
		lista.addAll(getEXTHistoricoProcedimiento(idProcedimiento));

		if (builders != null) {
			for (HistoricoProcedimientoBuilder b : builders) {
				addHistoricoExt(lista, b.getHistorico(idProcedimiento));
			}
		}

		return ordenaListaExt(lista);
	}
	
		
	private void addHistoricoExt(List<EXTHistoricoProcedimiento> lista,
			List<HistoricoProcedimientoDto> historico) {
		for (HistoricoProcedimientoDto dto : historico) {
			EXTHistoricoProcedimiento hp = new EXTHistoricoProcedimiento();
			try {
				BeanUtils.copyProperties(dto, hp);
				lista.add(hp);
			} catch (Exception e) {
				BusinessOperationException ex = new BusinessOperationException(
						"plugin.coreextension.error.historicoProcedimiento.getListByProcedimiento.completar");
				ex.initCause(e);
				throw ex;
			}

		}
		
	}

	private List<EXTHistoricoProcedimiento> getEXTHistoricoProcedimiento(Long idProcedimiento) {
		return historicoProcedimientoExtDao.getListByProcedimiento(idProcedimiento);
	}

	@SuppressWarnings("unchecked")
	private List<HistoricoProcedimiento> ordenaLista(
			List<HistoricoProcedimiento> lista) {
		if (lista != null) {
			Collections.sort(lista, new HistoricoProcedimientoComparator());
		}
		return lista;

	}
	
	@SuppressWarnings("unchecked")
	private List<HistoricoProcedimiento> ordenaListaTramiteDeSubasta(List<HistoricoProcedimiento> lista) {
		if (lista != null) {
			Collections.sort(lista, new HistoricoProcedimientoTramiteDeSubastaComparator());			
		}
		return lista;

	}
	
	@SuppressWarnings("unchecked")
	private List<EXTHistoricoProcedimiento> ordenaListaExt(
			List<EXTHistoricoProcedimiento> lista) {
		if (lista != null) {
			Collections.sort(lista, new HistoricoProcedimientoComparator());
		}
		return lista;

	}

	private void addHistorico(List<HistoricoProcedimiento> lista,
			List<HistoricoProcedimientoDto> historico) {
		for (HistoricoProcedimientoDto dto : historico) {
			HistoricoProcedimiento hp = new HistoricoProcedimiento();
			try {
				//BeanUtils.copyProperties(hp, dto);
				BeanUtils.copyProperties(dto, hp);
				lista.add(hp);
			} catch (Exception e) {
				BusinessOperationException ex = new BusinessOperationException(
						"plugin.coreextension.error.historicoProcedimiento.getListByProcedimiento.completar");
				ex.initCause(e);
				throw ex;
			}

		}

	}
	
	
	
	public void setBuilders(List<HistoricoProcedimientoBuilder> blist) {
		builders = blist;
	}





	

}
