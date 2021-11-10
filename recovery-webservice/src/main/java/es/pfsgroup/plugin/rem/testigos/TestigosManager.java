package es.pfsgroup.plugin.rem.testigos;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.TestigosApi;
import es.pfsgroup.plugin.rem.model.DtoTestigoObligatorio;
import es.pfsgroup.plugin.rem.model.TestigosObligatorios;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.testigos.dao.TestigosDao;

@Service("testigosManager")
public class TestigosManager extends BusinessOperationOverrider<TestigosApi> implements TestigosApi {

	protected static final Log logger = LogFactory.getLog(TestigosManager.class);
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private TestigosDao testigosDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UsuarioManager usuarioApi;
	
	@Override
	public String managerName() {
		return "testigosManager";
	}
	
	@Override
	public List<DtoTestigoObligatorio> getTestigosObligatorios() {
		
		List<TestigosObligatorios> lista = testigosDao.getTestigosList();
   		List<DtoTestigoObligatorio> listaTestigosObligatorios = new ArrayList<DtoTestigoObligatorio>();
   		
		for(TestigosObligatorios testigo: lista) {
			listaTestigosObligatorios.add(testigoObligatorioToDto(testigo));			
		}		
		return listaTestigosObligatorios;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio) {
		
		TestigosObligatorios testigoObligatorio = dtoToTestigoObligatorio(dtoTestigoObligatorio);
		
		if(testigoObligatorio != null) {
			testigosDao.save(testigoObligatorio);
			return true;
		} else {
			return false;
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio) {
		
		TestigosObligatorios testigoObligatorio = dtoToTestigoObligatorio(dtoTestigoObligatorio);
		
		if(testigoObligatorio != null) {
			Auditoria auditoria = testigoObligatorio.getAuditoria();
			auditoria.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
			auditoria.setFechaModificar(new Date());
			
			testigosDao.update(testigoObligatorio);
			
			return true;
		} else {
			return false;
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio) {
		
		TestigosObligatorios testigoObligatorio = dtoToTestigoObligatorio(dtoTestigoObligatorio);
		
		//Se realiza el borrado físico debido a la UK compuesta de todos los diccionarios de la tabla correspondiente.
		testigosDao.deleteTestigoById(testigoObligatorio.getId());
		
		return true;
	}
	
	private DtoTestigoObligatorio testigoObligatorioToDto(TestigosObligatorios testigo) {
		
		DtoTestigoObligatorio dtoTestigoObligatorio = new DtoTestigoObligatorio();
		
		try {
			
			beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "id", testigo.getId());
			if(testigo.getCartera() != null) {
				beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "cartera", testigo.getCartera().getDescripcion());
			}
			if(testigo.getSubcartera() != null) {
				beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "subcartera", testigo.getSubcartera().getDescripcion());
			}
			if(testigo.getTipoComercializacion() != null) {
				beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "tipoComercializacion", testigo.getTipoComercializacion().getDescripcion());
			}
			if(testigo.getEquipoGestion() != null) {
				beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "equipoGestion", testigo.getEquipoGestion().getDescripcion());
			}
			beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "porcentajeDescuento", testigo.getPorcentajeDescuento());
			beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "importeMinimo", testigo.getImporteMinimo());
			beanUtilNotNull.copyProperty(dtoTestigoObligatorio, "requiereTestigos", testigo.getRequiereTestigos());
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return dtoTestigoObligatorio;
		
	}
	
	private TestigosObligatorios dtoToTestigoObligatorio(DtoTestigoObligatorio dtoTestigoObligatorio) {
		
		TestigosObligatorios testigoObligatorio = new TestigosObligatorios();
		
		if(dtoTestigoObligatorio != null && dtoTestigoObligatorio.getId() != null && !dtoTestigoObligatorio.getId().contains("Testigo") && !dtoTestigoObligatorio.getId().isEmpty()) {
			testigoObligatorio = genericDao.get(TestigosObligatorios.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoTestigoObligatorio.getId())));
		}
		
		try {
			
			beanUtilNotNull.copyProperty(testigoObligatorio, "id", dtoTestigoObligatorio.getId());			
			if(dtoTestigoObligatorio.getCartera() != null) {
				DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTestigoObligatorio.getCartera()));
				if(cartera != null)
					beanUtilNotNull.copyProperty(testigoObligatorio, "cartera", cartera);
			}			
			if(dtoTestigoObligatorio.getSubcartera() != null) {
				DDSubcartera subcartera = genericDao.get(DDSubcartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTestigoObligatorio.getSubcartera()));
				if(subcartera != null)
					beanUtilNotNull.copyProperty(testigoObligatorio, "subcartera", subcartera);
			}
			if(dtoTestigoObligatorio.getTipoComercializacion() != null) {
				DDTipoComercializacion tipoComercializacion = genericDao.get(DDTipoComercializacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTestigoObligatorio.getTipoComercializacion()));
				if(tipoComercializacion != null)
					beanUtilNotNull.copyProperty(testigoObligatorio, "tipoComercializacion", tipoComercializacion);
			}
			if(dtoTestigoObligatorio.getEquipoGestion() != null) {
				DDEquipoGestion equipoGestion = genericDao.get(DDEquipoGestion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTestigoObligatorio.getEquipoGestion()));
				if(equipoGestion != null)
					beanUtilNotNull.copyProperty(testigoObligatorio, "equipoGestion", equipoGestion);
			}
			if(dtoTestigoObligatorio.getPorcentajeDescuento() != null)
				beanUtilNotNull.copyProperty(testigoObligatorio, "porcentajeDescuento", dtoTestigoObligatorio.getPorcentajeDescuento());
			
			if(dtoTestigoObligatorio.getImporteMinimo() != null)
				beanUtilNotNull.copyProperty(testigoObligatorio, "importeMinimo", dtoTestigoObligatorio.getImporteMinimo());
			
			if(dtoTestigoObligatorio.getRequiereTestigos() != null && (DDSinSiNo.CODIGO_SI.equals(dtoTestigoObligatorio.getRequiereTestigos()) || "true".equals(dtoTestigoObligatorio.getRequiereTestigos()))) {
				beanUtilNotNull.copyProperty(testigoObligatorio, "requiereTestigos", true);
			} else if(dtoTestigoObligatorio.getRequiereTestigos() == null && testigoObligatorio != null && testigoObligatorio.getRequiereTestigos() != null && testigoObligatorio.getRequiereTestigos()){
				beanUtilNotNull.copyProperty(testigoObligatorio, "requiereTestigos", true);
			} else {
				beanUtilNotNull.copyProperty(testigoObligatorio, "requiereTestigos", false);
			}
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return testigoObligatorio;
		
	}

}
