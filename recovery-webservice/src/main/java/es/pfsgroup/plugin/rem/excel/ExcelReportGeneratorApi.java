package es.pfsgroup.plugin.rem.excel;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.plugin.rem.model.DtoPropuestaAlqBankia;

public interface ExcelReportGeneratorApi {
	
	public void sendReport(String fileName,File reportFile, HttpServletResponse response) throws IOException;

	public void sendReport(File reportFile, HttpServletResponse response) throws IOException;

	public File generateReport(ExcelReport report);
	
	public File generateBankiaReport(List<DtoPropuestaAlqBankia> l_DtoPropuestaAlq, HttpServletRequest rm);

	public void generateAndSend(ExcelReport report, HttpServletResponse response) throws IOException;
	
	public int getStart();
	
	public int getLimit();

}