<%@ tag body-content="scriptless" %><%@ attribute name="value" required="true" type="java.lang.String"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%
	String name = jspContext.getAttribute("value").toString();
    String value = null;
    String clazz = name.substring(0, name.lastIndexOf('.'));
    String prop = name.substring(name.lastIndexOf('.') + 1);
    try {
        Class c = Class.forName(clazz);
        jspContext.setAttribute("result", c.getField(prop).get(c).toString());
    } catch (Exception e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
%>${result}