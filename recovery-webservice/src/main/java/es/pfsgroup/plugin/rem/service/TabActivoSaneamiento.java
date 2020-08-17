package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;

@Component
public class TabActivoSaneamiento implements TabActivoService {
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoCargasApi activoCargasApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Resource
	private MessageService messageServices;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	protected static final Log logger = LogFactory.getLog(TabActivoSaneamiento.class);

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_SANEAMIENTO};
	}
	

	public DtoActivoSaneamiento getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoSaneamiento activoDto = new DtoActivoSaneamiento();
		
		//******************************PARTE DE CARGAS***********************************
		
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		
		if(esUA) {
			activoDto.setUnidadAlquilable(true);
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if(agrupacion != null) {
				if(activoCargasApi.tieneCargasOcultasCargaMasivaEsparta(agrupacion.getId())) {
					if(activoCargasApi.esCargasOcultasCargaMasivaEsparta(agrupacion.getId())) {
						activoDto.setConCargas(1);
					} else {
						activoDto.setConCargas(0);
					}
				} else if(activoCargasApi.esActivoConCargasNoCanceladas(agrupacion.getId())) {
					activoDto.setConCargas(1);
				} else {
					activoDto.setConCargas(0);
				}
				
				//******************************PARTE DE PROTECCION OFICIAL***************************
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (activoMatriz != null) {
					if (activoMatriz.getInfoAdministrativa() != null) {
						BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
						if(activoMatriz.getInfoAdministrativa().getTipoVpo() != null) {
							activoDto.setTipoVpoId(activoMatriz.getInfoAdministrativa().getTipoVpo().getId());
							activoDto.setTipoVpoCodigo(activoMatriz.getInfoAdministrativa().getTipoVpo().getCodigo());
							activoDto.setTipoVpoDescripcion(activoMatriz.getInfoAdministrativa().getTipoVpo().getDescripcion());
						}
					}
					activoDto.setVpo(activoMatriz.getVpo());
				}
				//******************************PARTE DE PROTECCION OFICIAL***************************
			}
		} else {
			activoDto.setUnidadAlquilable(false);
			if(activoCargasApi.tieneCargasOcultasCargaMasivaEsparta(activo.getId())) {
				if(activoCargasApi.esCargasOcultasCargaMasivaEsparta(activo.getId())) {
					activoDto.setConCargas(1);
				} else {
					activoDto.setConCargas(0);
				}
			} else if(activoCargasApi.esActivoConCargasNoCanceladas(activo.getId())) {
				activoDto.setConCargas(1);
			} else {
				activoDto.setConCargas(0);
			}

			//******************************PARTE DE PROTECCION OFICIAL***************************
			if (activo.getInfoAdministrativa() != null) {
				BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
				if(activo.getInfoAdministrativa().getTipoVpo() != null) {
					activoDto.setTipoVpoId(activo.getInfoAdministrativa().getTipoVpo().getId());
					activoDto.setTipoVpoCodigo(activo.getInfoAdministrativa().getTipoVpo().getCodigo());
					activoDto.setTipoVpoDescripcion(activo.getInfoAdministrativa().getTipoVpo().getDescripcion());
				}
			}
			activoDto.setVpo(activo.getVpo());
			//******************************PARTE DE PROTECCION OFICIAL***************************			
		}
		
		if (activo.getEstadoCargaActivo() != null) {
			activoDto.setEstadoCargas(activo.getEstadoCargaActivo().getDescripcion());
		}
		
		if (activo.getFechaRevisionCarga() != null) {
			activoDto.setFechaRevisionCarga(activo.getFechaRevisionCarga());
		}
		
		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		if(activoDao.isActivoMatriz(activo.getId())) {	
			activoDto.setCamposPropagablesUas(TabActivoService.TAB_SANEAMIENTO);
		} else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoDto.setCamposPropagables(TabActivoService.TAB_SANEAMIENTO);
		}
		
		//******************************FIN PARTE DE CARGAS***********************************
		//******************************PARTE DE PROTECCION OFICIAL***************************	
		// Datos informacion relacionada con VPO
		if (activo.getInfoAdministrativa() != null) {
			activoDto.setVigencia(activo.getInfoAdministrativa().getVigencia());
			activoDto.setComunicarAdquisicion(activo.getInfoAdministrativa().getComunicarAdquisicion());
			activoDto.setNecesarioInscribirVpo(activo.getInfoAdministrativa().getNecesarioInscribirVpo());
			activoDto.setLibertadCesion(activo.getInfoAdministrativa().getLibertadCesion());
			activoDto.setRenunciaTanteoRetrac(activo.getInfoAdministrativa().getRenunciaTanteoRetrac());
			activoDto.setVisaContratoPriv(activo.getInfoAdministrativa().getVisaContratoPriv());
			activoDto.setVenderPersonaJuridica(activo.getInfoAdministrativa().getVenderPersonaJuridica());
			activoDto.setMinusvalia(activo.getInfoAdministrativa().getMinusvalia());
			activoDto.setInscripcionRegistroDemVpo(activo.getInfoAdministrativa().getInscripcionRegistroDemVpo());
			activoDto.setIngresosInfNivel(activo.getInfoAdministrativa().getIngresosInfNivel());
			activoDto.setResidenciaComAutonoma(activo.getInfoAdministrativa().getResidenciaComAutonoma());
			activoDto.setNoTitularOtraVivienda(activo.getInfoAdministrativa().getNoTitularOtraVivienda());
		}
		//******************************FIN PARTE DE PROTECCION OFICIAL***************************
		 
		return activoDto;
	}
	
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoSaneamiento activoDto = (DtoActivoSaneamiento) webDto;
		
		//******************************PARTE DE CARGAS***********************************
		if (activoDto.getFechaRevisionCarga() != null) {
			activo.setFechaRevisionCarga(activoDto.getFechaRevisionCarga());
		}
		//******************************FIN PARTE DE CARGAS***********************************
		//******************************PARTE DE PROTECCION OFICIAL***************************	
		if (activo.getInfoAdministrativa() == null) {
			activo.setInfoAdministrativa(new ActivoInfAdministrativa());
			activo.getInfoAdministrativa().setActivo(activo);
		}
		try {
			beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), activoDto);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
		if (activoDto.getTipoVpoCodigo() != null) {
			DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, activoDto.getTipoVpoCodigo());
			activo.getInfoAdministrativa().setTipoVpo(tipoVpo);
		}
		//******************************FIN PARTE DE PROTECCION OFICIAL***************************
		
		genericDao.save(Activo.class, activo);
		
		return activo;
	}	
}
