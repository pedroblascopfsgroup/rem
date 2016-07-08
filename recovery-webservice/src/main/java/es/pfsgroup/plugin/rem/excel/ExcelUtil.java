package es.pfsgroup.plugin.rem.excel;

public class ExcelUtil {

//	public <T> void writeReportToExcel(List<T> data) throws Exception {
//        Sheet sheet = getWorkbook().createSheet(
//                        data.get(0).getClass().getName());
//        setupFieldsForClass(data.get(0).getClass());
//        // Create a row and put some cells in it. Rows are 0 based.
//        int rowCount = 0;
//        int columnCount = 0;
//
//        Row row = sheet.createRow(rowCount++);
//        for (String fieldName : fieldNames) {
//                Cell cel = row.createCell(columnCount++);
//                cel.setCellValue(fieldName);
//        }
//        Class<? extends Object> classz = data.get(0).getClass();
//        for (T t : data) {
//                row = sheet.createRow(rowCount++);
//                columnCount = 0;
//                for (String fieldName : fieldNames) {
//                        Cell cel = row.createCell(columnCount);
//                        Method method = classz.getMethod("get" + capitalize(fieldName));
//                        Object value = method.invoke(t, (Object[]) null);
//                        if (value != null) {
//                                if (value instanceof String) {
//                                        cel.setCellValue((String) value);
//                                } else if (value instanceof Long) {
//                                        cel.setCellValue((Long) value);
//                                } else if (value instanceof Integer) {
//                                        cel.setCellValue((Integer)value);
//                                }else if (value instanceof Double) {
//                                        cel.setCellValue((Double) value);
//                                }
//                        }
//                        columnCount++;
//                }
//        }
//}
//	
//	private boolean setupFieldsForClass(Class<?> clazz) throws Exception {
//        Field[] fields = clazz.getDeclaredFields();
//        for (int i = 0; i < fields.length; i++) {
//                fieldNames.add(fields[i].getName());
//        }
//        return true;
//}


}
