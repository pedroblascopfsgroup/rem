package es.pfsgroup.plugin.rem.excel;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.model.DtoExcelFichaComercial;

import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;

import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.model.VReportAdvisoryNotes;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorRequest;
import es.pfsgroup.plugin.rem.rest.dto.ReportGeneratorResponse;

public interface ExcelReportGeneratorApi {
	
	public void sendReport(String fileName,File reportFile, HttpServletResponse response) throws IOException;

	public void sendReport(File reportFile, HttpServletResponse response) throws IOException;

	public File generateReport(ExcelReport report);
	
	public File generateBankiaReport(List<DtoPropuestaAlqBankia> lDtoPropuestaAlq, HttpServletRequest rm)  throws IOException;

	public void generateAndSend(ExcelReport report, HttpServletResponse response) throws IOException;
	
	public int getStart();
	
	public int getLimit();

	File getAdvisoryNoteReport(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request, String subcartera) throws IOException;
	
	File getAdvisoryNoteReportArrow(List<VReportAdvisoryNotes> listaAN, HttpServletRequest request) throws IOException;
	
	String generateBbvaReportGetName(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request)
			throws IOException;

	File generateBbvaReportGetFile(DtoExcelFichaComercial dtoExcelFichaComercial, HttpServletRequest request)
			throws IOException;
	
	public void downloadExcel(ReportGeneratorResponse report, HttpServletResponse response) throws IOException;

	ReportGeneratorResponse requestExcel(ReportGeneratorRequest request, String url) throws IOException;

	String sendExcelFichaComercial(Long numExpediente, ReportGeneratorResponse report, String scheme, String serverName) throws IOException;


}