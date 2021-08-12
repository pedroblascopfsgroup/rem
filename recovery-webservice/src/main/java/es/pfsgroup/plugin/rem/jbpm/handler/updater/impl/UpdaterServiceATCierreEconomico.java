package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.VBusquedaPresupuestosActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@Component
public class UpdaterServiceATCierreEconomico implements UpdaterService {
	
	@Autowired
	ActivoApi activoApi;
	
	@Autowired
    private GenericABMDao genericDao;
	
	@Autowired
	ActivoDao activoDao;
    
	private static final String FECHA_CIERRE = "fechaCierre";
	private static final String TIENE_OK_TECNICO = "tieneOkTecnico";

	private static final String CODIGO_T004_CIERRE_ECONOMICO = "T004_CierreEconomico";


	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor :  valores){

			//Fecha cierre
			if(FECHA_CIERRE.equals(valor.getNombre()))
			{
				//Guardado adicional Fecha cierre económico 
				//Trabajo -> gestión económica -> Fecha cierre económico
				try {
					trabajo.setFechaCierreEconomico(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				Filter filter = null;
				if(!trabajo.getEsTarifaPlana()){
					if(Checks.esNulo(trabajo.getFechaPago())){
						//Por finalizar la tarea "Cierre Económico", SIN fecha pago en trabajo, estado trabajo a "PENDIENTE PAGO"
						filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
					}else{
						//Por finalizar la tarea "Cierre Económico", CON fecha pago en trabajo, estado trabajo a "PAGADO"
						filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_PAGADO);
					}
				}
				else{
					//Si el trabajo es de tarifa plana, estado trabajo a "PAGADO CON TARIFA PLANA"
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_PAGADO_TARIFA_PLANA);
				}
				DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estadoTrabajo);
			}
			//OK Tecnico, solo aparece en el Cierre economico de los trabajos de Toma de Posesion
			else if(DDSubtipoTrabajo.CODIGO_TOMA_DE_POSESION.equals(trabajo.getSubtipoTrabajo().getCodigo()) && TIENE_OK_TECNICO.equals(valor.getNombre())){
				trabajo.getActivo().setTieneOkTecnico(Boolean.valueOf(valor.getValor()));
			}
		}
		int numActivos = trabajo.getActivosTrabajo().size();
		if(numActivos>1){
			for(ActivoTrabajo acttrabajo: trabajo.getActivosTrabajo()){
				Activo activo = acttrabajo.getActivo();
				if(!Checks.esNulo(trabajo)){

					SimpleDateFormat dfAnyo = new SimpleDateFormat("yyyy");
					String ejercicioActual = dfAnyo.format(new Date());
					
					Double ultimoPresupuestoActivoImporte = 0D;
					Double acumuladoTrabajosActivoImporte = 0D;
					Long idUltimoPresupuestoActivo = 0L;
					VBusquedaPresupuestosActivo ultimoPresupuestoActivo = new VBusquedaPresupuestosActivo();
					
					// Obtiene el presupuesto del activo, si se asigno para el ejercicio actual
					if (!Checks.esNulo(activo))
						idUltimoPresupuestoActivo = activoApi.getPresupuestoActual(activo.getId());
			 		
					if (!Checks.esNulo(idUltimoPresupuestoActivo)){
						Filter filtroUltimoPresupuesto = genericDao.createFilter(FilterType.EQUALS, "id", idUltimoPresupuestoActivo.toString());
						ultimoPresupuestoActivo =  genericDao.get(VBusquedaPresupuestosActivo.class, filtroUltimoPresupuesto);
					}
			 		
					if (!Checks.esNulo(ultimoPresupuestoActivo) && !Checks.esNulo(ultimoPresupuestoActivo.getImporteInicial()))
						if(!Checks.esNulo(ultimoPresupuestoActivo.getSumaIncrementos()))
							ultimoPresupuestoActivoImporte = ultimoPresupuestoActivo.getImporteInicial() + ultimoPresupuestoActivo.getSumaIncrementos();
						else
							ultimoPresupuestoActivoImporte = ultimoPresupuestoActivo.getImporteInicial();

					// Obtiene el acumulado de presupuestos de trabajos del activo, para el ejercicio actual
					Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId().toString());
					Filter filtroEjercicioActual = genericDao.createFilter(FilterType.EQUALS, "ejercicio", ejercicioActual);
					List<VBusquedaActivosTrabajoPresupuesto> listaTrabajosActivo = genericDao.getList(VBusquedaActivosTrabajoPresupuesto.class, filtroActivo, filtroEjercicioActual);

					BigDecimal importeParticipacionTrabajo = new BigDecimal(0);
					for (VBusquedaActivosTrabajoPresupuesto trabajoActivo : listaTrabajosActivo) {
						if(!Checks.esNulo(trabajoActivo.getImporteParticipa()))
							importeParticipacionTrabajo = new BigDecimal(trabajoActivo.getImporteParticipa());
						else
							importeParticipacionTrabajo = new BigDecimal(0);
						
						acumuladoTrabajosActivoImporte = acumuladoTrabajosActivoImporte + importeParticipacionTrabajo.doubleValue();
					}

				
					BigDecimal importeExcesoPresupuesto = new BigDecimal(acumuladoTrabajosActivoImporte - ultimoPresupuestoActivoImporte);

					if(importeExcesoPresupuesto.floatValue()>0L){
						Long idIncremento = activoApi.getPresupuestoActual(activo.getId());
						Filter filterIncremento = genericDao.createFilter(FilterType.EQUALS,"id", idIncremento);
						PresupuestoActivo presupuesto = genericDao.get(PresupuestoActivo.class,filterIncremento);

						// Crea un nuevo incremento
						IncrementoPresupuesto nuevoIncremento = new IncrementoPresupuesto();
						nuevoIncremento.setPresupuestoActivo(presupuesto);
						nuevoIncremento.setTrabajo(trabajo);
						
						// Actualiza la fecha de incremento
						nuevoIncremento.setFechaAprobacion(new Date());
						
						// Establece valores del incremento, viendo el exceso de presupuesto
						nuevoIncremento.setImporteIncremento(importeExcesoPresupuesto.floatValue());
						
						genericDao.save(IncrementoPresupuesto.class, nuevoIncremento);
					}
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
		// TODO Constantes con los nombres de los nodos que ejecutan este guardado adicional
		return new String[]{CODIGO_T004_CIERRE_ECONOMICO };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
