package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Component
public class UpdaterServiceActuacionTecnicaAnalisisPeticion implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private GestorActivoApi gestorActivoApi;
    
    @Autowired
    private ProveedoresDao proveedoresDao;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoTrabajoDao activoTrabajoDao;
    
	private static final String CODIGO_T004_ANALISIS_PETICION = "T004_AnalisisPeticion";
	
	private static final String COMBO_TRAMITAR = "comboTramitar";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";
	private static final String COMBO_ASEGURADORAS = "comboAseguradoras";
	private static final String COMBO_CUBIERTO = "comboCubierto";
	private static final String COMBO_TARIFA = "comboTarifa";
	private static final String COMBO_TARIFA_PLANA = "comboTarifaPlana";
	
	@Transactional(readOnly = false)
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		ActivoProveedorContacto proveedorTecnicoContacto = new ActivoProveedorContacto();
		
		// Asignacion del Proveedor Tecnico si aplica

			Activo activo = tramite.getActivo();
			if(!Checks.esNulo(activo)) {
			Usuario proveedorTecnico = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_TIPO_PROVEEDOR_TECNICO);
				if(!Checks.esNulo(proveedorTecnico)){
					proveedorTecnicoContacto = proveedoresDao.getActivoProveedorContactoPorIdsUsuario(proveedorTecnico.getId());
				}else {
					proveedorTecnicoContacto = null;
				}
			}	
		
		for(TareaExternaValor valor :  valores){

			if(COMBO_TRAMITAR.equals(valor.getNombre())){
				// Por defecto el trabajo pasará a en trámite y en caso de que se deniegue a rechazado.
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
				
				if(valor.getValor().equals(DDSiNo.NO)){
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_RECHAZADO);
					trabajo.setFechaRechazo(new Date());
				}else{
					trabajo.setFechaAprobacion(new Date());
				}
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estado);
			}
			if(COMBO_TARIFA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				if(valor.getValor().equals(DDSiNo.SI)){
					trabajo.setEsTarificado(true);
				}else{
					trabajo.setEsTarificado(false);
				}
			}
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Sólo podrá introducirlo cuando el combo de tramitar es NO
				trabajo.setMotivoRechazo(valor.getValor());
			}
			if(COMBO_CUBIERTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				trabajo.setCubreSeguro(valor.getValor().equals(DDSiNo.SI) ? true : false);
			}
			if(COMBO_ASEGURADORAS.equals(valor.getNombre())){
				trabajo.setCiaAseguradora(valor.getValor());
			}
			if(COMBO_TARIFA_PLANA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){				
				if(valor.getValor().equals(DDSiNo.SI)){
					trabajo.setEsTarifaPlana(true);
					if(!Checks.esNulo(proveedorTecnicoContacto)) {
						trabajo.setProveedorContacto(proveedorTecnicoContacto);
					}
				} else {
					trabajo.setEsTarifaPlana(false);
				}
			}
		}
		
		genericDao.save(Trabajo.class, trabajo);
		
		List<ActivoTrabajo> actTrabajo = genericDao.getList(ActivoTrabajo.class,genericDao.createFilter(FilterType.EQUALS,"trabajo.id", trabajo.getId()));
		
		for(ActivoTrabajo at: actTrabajo) {
			activoApi.actualizarOfertasTrabajosVivos(at.getActivo());
		}
		
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_ANALISIS_PETICION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
