package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;


@Component
public class MSVExcelValidatorImpl extends MSVExcelValidatorAbstract{

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto file) {
		// TODO Auto-generated method stub
		return null;
	}

//	@Override
//	public MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto file) {
//		MSVDtoValidacion dto= new MSVDtoValidacion();
//		dto.setFicheroTieneErrores(false);
//		//dto.setExcelErroresFormato(new FileItem());
//		return dto;
//	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		// TODO Auto-generated method stub
		return null;
	}

}
