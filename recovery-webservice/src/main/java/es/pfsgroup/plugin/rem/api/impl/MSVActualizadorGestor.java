package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;


@Component
public class MSVActualizadorGestor implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	

	SimpleDateFormat simpleDate = new SimpleDateFormat("dd/MM/yyyy");
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GESTORES.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);

		try {
			Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
			for (int fila = getFilaInicial(); fila < numFilas; fila++) {
				
				Activo activo= null;
				ActivoAgrupacion agrupacion= null;
				ExpedienteComercial expediente= null;
				Usuario usuario= null;
				EXTDDTipoGestor tipoGestor= null;
				
				if(!Checks.esNulo(exc.dameCelda(fila, 2))){
					activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 2)));
				}
				if(!Checks.esNulo(exc.dameCelda(fila, 3))){
					Long idAgrupacion= activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(Long.parseLong(exc.dameCelda(fila, 3)));
					agrupacion= activoAgrupacionApi.get(idAgrupacion);
				}
				
				if(!Checks.esNulo(exc.dameCelda(fila, 4))){
					expediente= expedienteComercialApi.findOneByNumExpediente(Long.parseLong(exc.dameCelda(fila, 4)));
				}
				
				if(!Checks.esNulo(exc.dameCelda(fila, 0))){					
					Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, 0));
					Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor,filtroBorrado);
				}
				
				if(!Checks.esNulo(exc.dameCelda(fila, 1))){
					Filter filtroUsuario= genericDao.createFilter(FilterType.EQUALS,"username", exc.dameCelda(fila, 1));
					Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					usuario = genericDao.get(Usuario.class,filtroUsuario,filtroBorrado);
				}
				
				if(!Checks.esNulo(tipoGestor) && !Checks.esNulo(usuario)){
					if(!Checks.esNulo(activo)){
						GestorEntidadDto dto = new GestorEntidadDto();
						dto.setIdEntidad(activo.getId());
						dto.setIdUsuario(usuario.getId());
						dto.setIdTipoGestor(tipoGestor.getId());
						activoAdapter.insertarGestorAdicional(dto);
					}
					else if(!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getTipoAgrupacion()) && 
								DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo()) &&
								tipoGestor.getCodigo().equals(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL)){
						
							ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;
							agrupacionTemp.setUsuarioGestorComercial(usuario);
							activoAgrupacionApi.saveOrUpdate(agrupacionTemp);
					}
					else if(!Checks.esNulo(expediente)){
						GestorEntidadDto dto = new GestorEntidadDto();
						dto.setIdEntidad(expediente.getId());
						dto.setIdUsuario(usuario.getId());
						dto.setIdTipoGestor(tipoGestor.getId());
						expedienteComercialApi.insertarGestorAdicional(dto);
					}
					else{
						return false;
					}
				}
				
			}

		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return true;
	}

	@Override
	public int getFilaInicial() {
		return 1;
	}

}
