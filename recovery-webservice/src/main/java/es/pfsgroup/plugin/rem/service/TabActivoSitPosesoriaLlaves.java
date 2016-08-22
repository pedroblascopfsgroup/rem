package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;

@Component
public class TabActivoSitPosesoriaLlaves implements TabActivoService {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_SIT_POSESORIA_LLAVES};
	}
	
	
	public DtoActivoSituacionPosesoria getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoSituacionPosesoria activoDto = new DtoActivoSituacionPosesoria();
		if (activo != null){
			BeanUtils.copyProperty(activoDto, "necesarias", activo.getLlavesNecesarias());
			BeanUtils.copyProperty(activoDto, "llaveHre", activo.getLlavesHre());
			BeanUtils.copyProperty(activoDto, "fechaRecepcionLlave", activo.getFechaRecepcionLlaves());
			BeanUtils.copyProperty(activoDto, "numJuegos", activo.getNumJuegosLlaves());
		}
		
		if (activo.getSituacionPosesoria() != null) {
			beanUtilNotNull.copyProperties(activoDto, activo.getSituacionPosesoria());
			if (activo.getSituacionPosesoria().getTipoTituloPosesorio() != null) {
				BeanUtils.copyProperty(activoDto, "tipoTituloPosesorioCodigo", activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo());
			}
		}
		/*
		//Añadir al DTO los atributos de llaves también
		
		if (activo.getLlaves() != null) {
			for (int i = 0; i < activo.getLlaves().size(); i++)
			{
				try {

					ActivoLlave llave = activo.getLlaves().get(i);	
					BeanUtils.copyProperties(activoDto, llave);
				}
				catch (Exception e) {
					e.printStackTrace();
					return null;
				}
			}
		}*/
		
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
	

		DtoActivoSituacionPosesoria dto = (DtoActivoSituacionPosesoria) webDto;
		
		try {
						
			if (activo.getSituacionPosesoria() == null) {
				
				activo.setSituacionPosesoria(new ActivoSituacionPosesoria());
				activo.getSituacionPosesoria().setActivo(activo);
				
			}
			
			if(!Checks.esNulo(dto.getOcupado()) && !BooleanUtils.toBoolean(dto.getOcupado())) {				
				dto.setConTitulo(null);				
			}
				
			beanUtilNotNull.copyProperties(activo.getSituacionPosesoria(), dto);
			
			activo.setSituacionPosesoria(genericDao.save(ActivoSituacionPosesoria.class, activo.getSituacionPosesoria()));
			
			if (dto.getTipoTituloPosesorioCodigo() != null) {
				
				DDTipoTituloPosesorio tipoTitulo = (DDTipoTituloPosesorio) 
						diccionarioApi.dameValorDiccionario(DDTipoTituloPosesorio.class,  new Long(dto.getTipoTituloPosesorioCodigo()));
	
				activo.getSituacionPosesoria().setTipoTituloPosesorio(tipoTitulo);
				
			}

			if (dto.getNecesarias()!=null)
			{
				activo.setLlavesNecesarias(dto.getNecesarias());
			}
			if (dto.getLlaveHre()!=null)
			{
				activo.setLlavesHre(dto.getLlaveHre());
			}
			
			if (dto.getFechaRecepcionLlave()!=null)
			{
				activo.setFechaRecepcionLlaves(dto.getFechaRecepcionLlave());
			}
			if (dto.getNumJuegos()!=null)
			{
				activo.setNumJuegosLlaves(Integer.valueOf(dto.getNumJuegos()));
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
	}

}
