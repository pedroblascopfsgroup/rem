package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;


@Component
public class MSVSuperDiscPublicacionesProcesar extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final String ARROBA = "@";
	private static final String SI = "SI";
	private static final String S = "S";
	
	public static final class COL_NUM {
		
		static final int NUM_ACTIVO = 0;
		static final int ESTADO_FISICO_ACTIVO = 1;
		static final int OCUPADO = 2;
		static final int CON_TITULO = 3;
		static final int TAPIADO = 4;
		static final int OTROS = 5;
		static final int MOTIVO_OTROS = 6;
		static final int ACTIVO_INTEGRADO = 7;
		static final int DIVISION_HORIZONTAL_INTEGRADO = 8;
		static final int ESTADO_DIVISION_HORIZONTAL = 9;

	};
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_PUBLICACION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO)));

		Filter filtroEstadoActivo = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.ESTADO_FISICO_ACTIVO));
		DDEstadoActivo estadoActivo = genericDao.get(DDEstadoActivo.class, filtroEstadoActivo);
		if(!Checks.esNulo(estadoActivo)) {
			activo.setEstadoActivo(estadoActivo);
		}		
		
		//Situacion Posesoria
		
		ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
		if(Checks.esNulo(situacionPosesoria)){
			Integer ocupado = 0;
			Integer accesoTapiado = 0;
			Integer divisionHorizontal = 0;
			Integer inscritoDivisionHorizontal = 0;
			Date fechaHoy = new Date();
			
			//Ocupado
			
			if(S.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.OCUPADO))) || SI.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.OCUPADO)))) {	
				ocupado = 1;
			}else if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.OCUPADO)) || ARROBA.equals(exc.dameCelda(fila, COL_NUM.OCUPADO))) {
				situacionPosesoria.setOcupado(ocupado);
				situacionPosesoria.setConTitulo(null);
				
			}
			situacionPosesoria.setOcupado(ocupado);
			
			//ConTitulo
			Filter filtroTipoTitulo = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.CON_TITULO));
			DDTipoTituloActivoTPA tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, filtroTipoTitulo);
			
			if(!Checks.esNulo(tipoTitulo)) {
				situacionPosesoria.setConTitulo(tipoTitulo);
			}
			
			//Tapiado
			if(S.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.TAPIADO))) || SI.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.TAPIADO)))) {
				accesoTapiado = 1;
				situacionPosesoria.setFechaAccesoTapiado(fechaHoy);
			}
			situacionPosesoria.setAccesoTapiado(accesoTapiado);
			
			//Otros => No hay que persistirlo
			
			//Motivo Otros Publicacion
			if(Checks.esNulo(exc.dameCelda(fila, COL_NUM.OTROS)) || ARROBA.equals(exc.dameCelda(fila, COL_NUM.OTROS))) {
				situacionPosesoria.setOtro(null);
			}else {
				situacionPosesoria.setOtro(exc.dameCelda(fila, COL_NUM.MOTIVO_OTROS));
			}
			
			genericDao.save(ActivoSituacionPosesoria.class, situacionPosesoria);
			
			//DivisionHorizontal-Activo	Ingegrado
			
			Filter filtroEstadoDivisionHorizontal = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.ESTADO_DIVISION_HORIZONTAL));
			DDEstadoDivHorizontal estadoDivisionHorizontal = genericDao.get(DDEstadoDivHorizontal.class, filtroEstadoDivisionHorizontal);
			
			ActivoInfoRegistral activoInfoRegistral= activo.getInfoRegistral();
			if(SI.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.ACTIVO_INTEGRADO))) || S.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.ACTIVO_INTEGRADO)))){
				divisionHorizontal = 1;
				
				if(!Checks.esNulo(activoInfoRegistral)) {
					if(SI.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.DIVISION_HORIZONTAL_INTEGRADO))) || S.equalsIgnoreCase((exc.dameCelda(fila, COL_NUM.DIVISION_HORIZONTAL_INTEGRADO)))) {
						inscritoDivisionHorizontal = 1;
					}
					activoInfoRegistral.setDivHorInscrito(inscritoDivisionHorizontal);
					
					if(!Checks.esNulo(estadoDivisionHorizontal))
						activoInfoRegistral.setEstadoDivHorizontal(estadoDivisionHorizontal);
				}
			}else {
				
				if(!Checks.esNulo(activoInfoRegistral)) {
					activoInfoRegistral.setDivHorInscrito(null);
					activoInfoRegistral.setEstadoDivHorizontal(null);
				}
				
			}
			activo.setDivHorizontal(divisionHorizontal);
			
			activoDao.saveOrUpdate(activo);
			genericDao.save(ActivoInfoRegistral.class, activoInfoRegistral);
			
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
		}
		
		return new ResultadoProcesarFila();
	}
	
}
