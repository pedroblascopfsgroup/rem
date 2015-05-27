package es.pfsgroup.plugin.recovery.procuradores.procurador.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.RelacionProcuradorProcedimientoApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorProcedimientoDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.RelacionProcuradorProcedimientoDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;



@Service("RelacionProcuradorProcedimiento")
@Transactional(readOnly = false)
public class RelacionProcuradorProcedimientoManager  implements RelacionProcuradorProcedimientoApi{

	@Autowired
	private RelacionProcuradorProcedimientoDao relacionProcuradorProcedimientoDao;
	
//	
//	@Autowired
//	private CategoriaApi categoriaApi;
//	
//	@Autowired
//	private GenericABMDao genericDao;


	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#guardarRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_PROCEDIMIENTO_GUARDAR_RELACION)
	public RelacionProcuradorProcedimiento guardarRelacionProcuradorProcedimiento(RelacionProcuradorProcedimientoDto dto) throws BusinessOperationException{
		
		RelacionProcuradorProcedimiento relProProc = null;
		
		if (Checks.esNulo(dto.getProcurador())){	
			throw new BusinessOperationException("No se ha pasado el id del procurador.");
			
		}else if (Checks.esNulo(dto.getProcedimiento())){
			throw new BusinessOperationException("No se ha pasado el id del procedimiento.");
			
		}else{
			
			///Comprobamos si el procedimiento tiene asignado procurador
			List<RelacionProcuradorProcedimiento> rels = relacionProcuradorProcedimientoDao.getProcuradorProcedimiento(dto.getProcedimiento().getId());
			if(rels.size() > 0 ){
				
				relProProc = rels.get(0);
				relProProc.setProcurador(dto.getProcurador());
				relacionProcuradorProcedimientoDao.saveOrUpdate(relProProc);
				
			}else{
				
				relProProc = new RelacionProcuradorProcedimiento();
				relProProc.setProcedimiento(dto.getProcedimiento());
				relProProc.setProcurador(dto.getProcurador());
				relacionProcuradorProcedimientoDao.saveOrUpdate(relProProc);
				
			}
			
		}
		
		return relProProc;
		
	}





	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_PROCEDIMIENTO_GET_PROCURADOR)
	public Procurador getProcurador(Long idProcedimiento) {
		List<RelacionProcuradorProcedimiento> listaProcuradores = relacionProcuradorProcedimientoDao.getProcuradorProcedimiento(idProcedimiento);
		if (listaProcuradores.size()>0)
			return listaProcuradores.get(0).getProcurador();
		else 
			return null;
	}



	
	


}
