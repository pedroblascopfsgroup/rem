package es.pfsgroup.plugin.rem.excel;

import java.util.List;

public interface ExcelReport {

	List<String> getCabeceras();

	List<List<String>> getData();

	String getReportName();

}