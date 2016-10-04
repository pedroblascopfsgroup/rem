package es.pfsgroup.plugin.rem.activo;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;

@Service("activoAgrupacionManager")
public class ActivoAgrupacionManager implements ActivoAgrupacionApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(ActivoAgrupacionManager.class);
	
	 @Autowired 
	 private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

//	@Override
//	public String managerName() {
//		return "activoAgrupacionManager";
//	}

	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	private ActivoAgrupacionFactoryApi activoAgrupacionFactoryApi;

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.get")
	public ActivoAgrupacion get(Long id) {
		return activoAgrupacionDao.get(id);
	}
	
	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem){
		return activoAgrupacionDao.getAgrupacionIdByNumAgrupRem(numAgrupRem);
	}
	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(ActivoAgrupacion activoAgrupacion) {
		activoAgrupacionDao.saveOrUpdate(activoAgrupacion);
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.deleteById")
	@Transactional
	public boolean deleteById(Long id) {
		activoAgrupacionDao.deleteById(id);
		return true;
	}

    
	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListAgrupaciones")
	public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListAgrupaciones(dto, usuarioLogado);
	}
	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListActivosAgrupacionById")
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado);
	}
	
	@Override
	public Long getNextNumAgrupacionRemManual() {
		return activoAgrupacionDao.getNextNumAgrupacionRemManual();
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoPrincipal")
	public Long haveActivoPrincipal(Long id) {
		return activoAgrupacionDao.haveActivoPrincipal(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoRestringidaAndObraNueva")
	public Long haveActivoRestringidaAndObraNueva(Long id) {
		return activoAgrupacionDao.haveActivoRestringidaAndObraNueva(id);
	}
	

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {
			
			ActivoAgrupacion agrupacion = get(Long.parseLong(fileItem.getParameter("idEntidad")));
			
			//ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo(fileItem.getFileItem());
			
			ActivoFoto activoFoto = new ActivoFoto(fileItem.getFileItem());
			
			activoFoto.setAgrupacion(agrupacion);
			
			/*Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			DDTipoFoto tipoFoto = (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
			
			activoFoto.setTipoFoto(tipoFoto);*/
						
			activoFoto.setTamanyo(fileItem.getFileItem().getLength());
			
			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));
			
			activoFoto.setPrincipal(true);
			
			activoFoto.setFechaDocumento(new Date());
			
			//activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));
			
			/*Integer orden = activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
			orden++;
			activoFoto.setOrden(orden);*/

			Auditoria.save(activoFoto);
	        
			agrupacion.getFotos().add(activoFoto);		
				
			activoAgrupacionDao.save(agrupacion);
					
		return "success";

	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFotoSubdivision")
	@Transactional(readOnly = false)
	public String uploadFotoSubdivision(WebFileItem fileItem) {
			
		BigDecimal subdivisionId = new BigDecimal(fileItem.getParameter("id"));
		Long agrupacionId = Long.parseLong(fileItem.getParameter("agrId"));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId );
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
			
					
		ActivoFoto activoFoto = new ActivoFoto(fileItem.getFileItem());
		
		activoFoto.setSubdivision(subdivisionId);
		
		activoFoto.setAgrupacion(agrupacion);

		activoFoto.setTamanyo(fileItem.getFileItem().getLength());
		
		activoFoto.setNombre(fileItem.getFileItem().getFileName());

		activoFoto.setDescripcion(fileItem.getParameter("descripcion"));
		
		activoFoto.setPrincipal(false);
		
		activoFoto.setFechaDocumento(new Date());
		
		Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId);
		orden++;
		activoFoto.setOrden(orden);

		Auditoria.save(activoFoto);
        
		agrupacion.getFotos().add(activoFoto);		
			
		genericDao.save(ActivoAgrupacion.class, agrupacion);
					
		return "success";

	}

	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getFotosActivosAgrupacionById")
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {
		return activoAgrupacionDao.getFotosActivosAgrupacionById(id);
	}

	@Override
	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion) {
		
		if (dtoAgrupacion.getTipoAgrupacion() == null){
			return false;
		}

		return activoAgrupacionFactoryApi.create(dtoAgrupacion);
		
	}
	
	@Override
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter) {
		return activoAgrupacionDao.getListSubdivisionesAgrupacionById(agrupacionFilter);
	}
	
	@Override
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision) {		
		return  activoAgrupacionDao.getListActivosSubdivisionById(subdivision);
	}

	@Override
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {			
		return activoAgrupacionDao.getFotosSubdivision(subdivision);
	}

	@Override
	public List<ActivoFoto> getFotosAgrupacionById(Long id) {
		
		return activoAgrupacionDao.getFotosAgrupacionById(id);
		
	}


	
	
}